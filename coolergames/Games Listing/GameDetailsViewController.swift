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
    @IBOutlet weak var backgroundImageView: UIImageView?
    @IBOutlet weak var popularityLabel: UILabel!
    
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
            self.title = game.name
            if isViewLoaded {
                boxImageView.setImage(for: game) { [weak self] image in
                    self?.setBackgroundImage(image)
                }
                gameTitleLabel.text = game.name
                popularityLabel.text = "Popularity: \(game.popularity!)"
            }
        }
    }
    
    private func setBackgroundImage(_ image: UIImage?) {
        guard let backgroundImageView = backgroundImageView else { return }
        UIView.transition(with: backgroundImageView,
                          duration: 0.3,
                          options: .curveEaseOut,
                          animations: {
                            backgroundImageView.image = image
        }, completion: nil)
        
    }
}
