//
//  TopListViewController.swift
//  coolergames
//
//  Created by Vitor Rodrigues on 2/15/18.
//  Copyright © 2018 Vitor Rodrigues. All rights reserved.
//

import UIKit

class TopListViewController: UIViewController {
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    var dataSource:GamesDataSource!
    let proxy = GamesProxy()
    var loadingView: VRLoadingView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        dataSource = GamesDataSource(collectionView: collectionView, proxy: proxy)
        loadingView = VRLoadingView.fromXib()
        loadingView.show(in: view)
        collectionView.dataSource = dataSource
        let refresh = UIRefreshControl()
        refresh.addTarget(self, action: #selector(didPullToRefresh(_:)), for: .valueChanged)
        dataSource.delegate = self
        collectionView.refreshControl = refresh
        dataSource.loadPage() {
            self.checkForError($0)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "detail" {
            let vc = segue.destination as! GameDetailsViewController
            vc.game = sender as? Game
        }
    }
    
    @objc func didPullToRefresh(_ sender: UIRefreshControl) {
        sender.endRefreshing()
        dataSource.reset()
        dataSource.loadPage() {
            self.checkForError($0)
        }
    }
    
    func checkForError(_ error: Error?) {
        guard let error = error else { return }
        showError(error)
    }
}

extension TopListViewController: GameDataSourceDelegate {
    func dataSourceDidBeginFetching(_ ds: GamesDataSource) {
        loadingView.show()
    }
    
    func dataSourceDidEndFetching(_ ds: GamesDataSource) {
        loadingView.hide()
    }
    
    func dataSource(_ ds: GamesDataSource, didSelect game: Game) {
        self.performSegue(withIdentifier: "detail", sender: game)
    }
}

