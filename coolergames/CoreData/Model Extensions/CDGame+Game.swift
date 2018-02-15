//
//  CDGame+Game.swift
//  coolergames
//
//  Created by Vitor Rodrigues on 2/15/18.
//  Copyright © 2018 Vitor Rodrigues. All rights reserved.
//

import Foundation

extension CDGame {
    func update(_ game: Game) {
        identifier = Int32(game.identifier)
        name = game.name
        boxTemplateUrl = game.boxImageUrlTemplate
        popularity = Int64(game.popularity)
    }
}
