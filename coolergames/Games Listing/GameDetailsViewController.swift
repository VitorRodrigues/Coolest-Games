//
//  GameDetailsViewController.swift
//  coolergames
//
//  Created by Vitor Rodrigues on 2/15/18.
//  Copyright © 2018 Vitor Rodrigues. All rights reserved.
//

import UIKit

class GameDetailsViewController: UIViewController {
    
    @IBOutlet weak var gameTitleLabel: UILabel!
    @IBOutlet weak var boxImageView: UIImageView!
    
    var game: Game? {
        didSet {
            configureView()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        configureView()
    }

    private func configureView() {
        if let game = game {
            if isViewLoaded {
                boxImageView.setImage(for: game)
                gameTitleLabel.text = game.name
            }
        }
    }
}
