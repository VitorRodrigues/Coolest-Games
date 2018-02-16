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
    @IBOutlet weak var positionLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    
    override func awakeFromNib() {
        let indexLayer = contentView.layer
        indexLayer.shadowRadius = 5
        indexLayer.shadowColor = UIColor.black.cgColor
        indexLayer.shadowOpacity = 0.7
        indexLayer.shadowOffset = CGSize(width: 0, height: 10)
        indexLayer.shadowPath = CGPath(rect: self.bounds, transform: nil)
        
        contentView.layer.cornerRadius = 10
        contentView.layer.masksToBounds = true
    }
    
    override func prepareForReuse() {
        boxImage.sd_cancelCurrentImageLoad()
    }
    
    func configure(_ game: Game, index: Int) {
        boxImage.setImage(for: game)
        titleLabel.text = game.name
        positionLabel.text = "\(index)"
    }
}
