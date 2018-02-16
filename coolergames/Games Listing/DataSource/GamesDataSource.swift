//
//  GamesDataSource.swift
//  coolergames
//
//  Created by Vitor Rodrigues on 2/15/18.
//  Copyright © 2018 Vitor Rodrigues. All rights reserved.
//

import UIKit

protocol GameDataSourceDelegate {
    func dataSource(_ ds: GamesDataSource, didSelect game: Game)
    func dataSourceDidBeginFetching(_ ds: GamesDataSource)
    func dataSourceDidEndFetching(_ ds: GamesDataSource)
    func dataSource(_ ds: GamesDataSource, didFailToDownload error: Error)
}

class GamesDataSource: NSObject, UICollectionViewDataSource, UICollectionViewDelegate {
    
    weak var collectionView: UICollectionView?
    var delegate: GameDataSourceDelegate?
    var isNextPageAvailable: Bool = true
    var requesting: Bool = false {
        didSet {
            if requesting {
                delegate?.dataSourceDidBeginFetching(self)
            } else {
                delegate?.dataSourceDidEndFetching(self)
            }
        }
    }
    var page = 1
    private let pageSize = 50
    
    let proxy: GamesProxy!
    var loadedGames: [Game] = [] {
        didSet {
            setupFlowLayout()
            collectionView?.reloadData()
        }
    }
    
    var columnLayout: DynamicColumnLayout? {
        return collectionView?.collectionViewLayout as? DynamicColumnLayout
    }
    
    init(collectionView: UICollectionView, proxy: GamesProxy = GamesProxy()) {
        self.collectionView = collectionView
        self.proxy = proxy
        super.init()
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.contentInset = UIEdgeInsetsMake(8, 8, 8, 8)
        // Show all games that are stored in our DB
        loadedGames.append(contentsOf: proxy.allGames)
    }
    
    /**
     Forces the DataSource to calculate the size of its items
     */
    func setupFlowLayout() {
        if UI_USER_INTERFACE_IDIOM() == .pad {
            if UIDeviceOrientationIsLandscape(UIDevice.current.orientation) {
                columnLayout?.columns = 3
            } else {
                columnLayout?.columns = 4
            }
        } else {
            columnLayout?.columns = 2
        }
    }
    
    func reset() {
        isNextPageAvailable = true
        page = 1
        proxy.reset()
        loadPage()
    }
    
    func loadPage() {
        guard !requesting else { return }
        let pageIndex = page-1
        let pageSize = self.pageSize
        let offset = pageIndex * pageSize
        requesting = true
        proxy.loadGames(limit: pageSize, offset: offset) { (games, saved, error)  in
            if !games.isEmpty {
                self.isNextPageAvailable = pageSize == games.count
                if self.page == 1 {
                    self.loadedGames = games
                } else {
                    // Increment after page 2
                    self.loadedGames.append(contentsOf: games)
                }
            } else {
                self.isNextPageAvailable = false
            }
            self.requesting = false
            if let error = error {
                self.delegate?.dataSource(self, didFailToDownload: error)
            }
        }
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return loadedGames.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! GameCollectionViewCell
        let game = loadedGames[indexPath.row]
        cell.configure(game, index: indexPath.row+1)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let game = loadedGames[indexPath.row]
        delegate?.dataSource(self, didSelect: game)
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        guard isNextPageAvailable else { return }
        let contentHeight = scrollView.contentSize.height
        // Ensure the content did load before checking for next page
        guard contentHeight > 0 else { return }
        let viewHeight = scrollView.bounds.size.height
        let offsetY = scrollView.contentOffset.y + viewHeight
        let bottomLine = contentHeight - viewHeight
        if bottomLine <= offsetY && !requesting {
            requestNextPage()
        }
    }
    
    private func requestNextPage() {
        page += 1
        loadPage()
    }
}
