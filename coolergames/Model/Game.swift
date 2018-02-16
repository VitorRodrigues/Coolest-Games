//
//  Game.swift
//  coolergames
//
//  Created by Vitor Rodrigues on 2/15/18.
//  Copyright © 2018 Vitor Rodrigues. All rights reserved.
//

import Foundation
import SwiftyJSON

class Game: NSObject {
    
    let identifier: Int!
    let name: String!
    let boxImageUrlTemplate: String!
    var popularity: Int!
    
    override var debugDescription: String {
        return "\(identifier): \(name) (\(popularity))"
    }
    
    // MARK: - Initializers
    init(with json: JSON) {
        identifier = json["_id"].intValue
        name = json["name"].stringValue
        boxImageUrlTemplate = json["box"]["template"].stringValue
        popularity = json["popularity"].intValue
    }
    
    init(identifier: Int, name: String, boxTemplateUrl: String, popularity: Int = 0) {
        self.identifier = identifier
        self.name = name
        self.boxImageUrlTemplate = boxTemplateUrl
        self.popularity = popularity
    }
    
    convenience init(from coreData: CDGame) {
        self.init(identifier: Int(coreData.identifier),
                  name: coreData.name!,
                  boxTemplateUrl: coreData.boxTemplateUrl!,
                  popularity: Int(coreData.popularity))
        
    }
    // MARK: - Methods
    func boxImageUrl(size: CGSize) -> URL? {
        return boxImageUrl(width:Int(size.width), height: Int(size.height))
    }
    
    func boxImageUrl(width: Int, height: Int) -> URL? {
        let fullUrl = boxImageUrlTemplate
            .replacingOccurrences(of: "{height}", with: "\(height)")
            .replacingOccurrences(of: "{width}", with: "\(width)")
        return URL(string: fullUrl)
    }
}
