//
//  UIImageView+Game.swift
//  coolergames
//
//  Created by Vitor Rodrigues on 2/15/18.
//  Copyright © 2018 Vitor Rodrigues. All rights reserved.
//

import UIKit

extension UIImageView {
    func setImage(for game: Game, completion: ((UIImage?)->Void)? = nil) {
        let imageSize = CGSize(width: 200, height: 350)
        let boxImageUrl = game.boxImageUrl(size: imageSize)
        self.sd_setImage(with: boxImageUrl) { (image, error, cache, url) in
            completion?(image) // This allows us to manipulate the image later
        }
    }
}
