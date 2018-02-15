//
//  BaseRequester.swift
//  coolergames
//
//  Created by Vitor Rodrigues on 2/15/18.
//  Copyright © 2018 Vitor Rodrigues. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

enum Result<Value> {
    case success(Value)
    case failure(Error)
}

struct ResponseWrapper<T> {
    var code: Int16
    var status: Int16
    var result: Result<T>
}

class BaseRequester: NSObject {
    var defaultHeaders: HTTPHeaders? = ["Client-ID": "iqtfz53gst6bnq60n5rm45kygai38d"]
    var encoding: ParameterEncoding {
        return URLEncoding.default
    }
    
    var apiHost: String {
        return "https://api.twitch.tv/kraken/games"
    }
    func performRequest(path: String, method: HTTPMethod, parameters: Parameters?, queue: DispatchQueue? = nil, reauthenticate: Bool = true, completion: @escaping (Result<JSON>)->Void) -> Request {
        var finalPath = path;
        if !finalPath.hasPrefix("/") {
            // Add the bar to the path
            finalPath = "/\(path)"
        }
        
        let request = buildRequest(path: finalPath, method: method, parameters: parameters)
        return performJSON(request: request, queue: queue) { (wrappedResponse) in
            // Unwrap the response to keep message simpler to upper classes
            switch wrappedResponse.result {
            case .success(let value): completion(Result.success(JSON(value)))
            case .failure(let error as AFError):
                self.handleError(code: error.responseCode!, error: error, completion: completion)
            case .failure(let error as NSError):
                self.handleError(code: error.code, error: error, completion: completion)
            }
        }
    }
    
    private func handleError(code: Int, error: Error, completion: @escaping (Result<JSON>)->Void) {
        let nsError = error as NSError
        let error = APIError(code: code, userInfo: nsError.userInfo)
        completion(Result.failure(error))
    }
    
    private func buildRequest(path: String, method: HTTPMethod, parameters: Parameters?, headers: HTTPHeaders? = nil) -> DataRequest {
        let url = apiHost.appending(path)
        var customHeaders: HTTPHeaders = defaultHeaders ?? [:]
        if let headers = headers {
            headers.forEach({ (key, value) in
                customHeaders.updateValue(value, forKey: key)
            })
        }
        
        return Alamofire
            .request(url, method: method, parameters: parameters, encoding: encoding, headers: customHeaders)
            .validate(statusCode: 200..<400)
            .validate(contentType: ["application/json"])
        
    }
    
    
    private func performJSON(request: DataRequest, queue: DispatchQueue? = nil, completion: @escaping (ResponseWrapper<Any>)->Void) -> Request {
        return request.responseJSON(queue: queue, options: .allowFragments) { (response) in
            if let error = response.result.error {
                let statusCode = response.response?.statusCode ?? 404
                guard let data = response.data,
                    let jsonWrapped = try? JSONSerialization.jsonObject(with: data, options: .allowFragments) as? [String: Any],
                    let json = jsonWrapped else {
                        let wrapper = ResponseWrapper<Any>(code: Int16(statusCode),
                                                           status: Int16(statusCode),
                                                           result: Result.failure(error))
                        completion(wrapper)
                        return
                }
                
                let errorCode = json["code"] as? Int ?? APIError.unknownErrorCode
                let message = json["message"] as? String ?? "" //No error message given
                
                let error = APIError(code: errorCode, userInfo: [NSLocalizedDescriptionKey: message])
                
                let wrapper = ResponseWrapper<Any>(code: Int16(errorCode),
                                                   status: Int16(statusCode),
                                                   result: Result.failure(error))
                completion(wrapper)
                
            } else if let data = response.result.value as? [String: Any] {
                let wrapper = ResponseWrapper<Any>(code: 200,
                                                   status: 200,
                                                   result: Result.success(data))
                completion(wrapper)
            } else {
                // If we can't parse the value, something did go very wrong in the API
                let urlString = response.request?.url?.absoluteString ?? "malformed url"
                let error = APIError(code: APIError.unknownErrorCode, userInfo: ["url": urlString])
                let statusCode = response.response?.statusCode ?? error.code
                let wrapper = ResponseWrapper<Any>(code: Int16(statusCode),
                                                   status: Int16(statusCode),
                                                   result: Result.failure(error))
                completion(wrapper)
            }
        }
    }
}
