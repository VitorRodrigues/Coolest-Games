//
//  TopGamesRequester.swift
//  coolergames
//
//  Created by Vitor Rodrigues on 2/15/18.
//  Copyright © 2018 Vitor Rodrigues. All rights reserved.
//

import UIKit
import Alamofire

class TopGamesRequester: BaseRequester {

    func getTop(limit: Int = 30, offset: Int = 0, completion: @escaping (Result<[Game]>)->Void) -> Request {
        let path = "/top"
        
        let params = ["limit": limit,
                      "offset": offset]
        
        return performRequest(path: path,
                              method: .get,
                              parameters: params,
                              completion: { (result) in
                                switch result {
                                case .failure(let error):
                                    completion(.failure(error))
                                case .success(let json):
                                    //Do something
                                    let games = json["top"].arrayValue.flatMap { Game(with: $0["game"]) }
                                    completion(Result.success(games))
                                    break
                                    
                                }
        })
    }
    
}
