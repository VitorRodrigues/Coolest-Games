//
//  APIError.swift
//  coolergames
//
//  Created by Vitor Rodrigues on 2/15/18.
//  Copyright © 2018 Vitor Rodrigues. All rights reserved.
//

import Foundation

class APIError: NSError {
    static let domain: String = "br.com.coolergames.error"
    
    static let unknownErrorCode: Int = -999
    
    convenience init(code: Int, userInfo: [String: Any]? = nil) {
        self.init(domain: APIError.domain, code: code, userInfo: userInfo)
    }
}
