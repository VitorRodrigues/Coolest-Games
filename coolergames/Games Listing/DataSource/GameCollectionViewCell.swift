//
//  GameCollectionViewCell.swift
//  coolergames
//
//  Created by Vitor Rodrigues on 2/15/18.
//  Copyright © 2018 Vitor Rodrigues. All rights reserved.
//

import UIKit
import SDWebImage

class GameCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var boxImage: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    
    override func prepareForReuse() {
        boxImage.sd_cancelCurrentImageLoad()
    }
    
    func configure(_ game: Game) {
        boxImage.setImage(for: game)
        titleLabel.text = game.name
    }
}
