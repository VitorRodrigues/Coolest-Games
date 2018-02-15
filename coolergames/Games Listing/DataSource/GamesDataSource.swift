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
}

class GamesDataSource: NSObject, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    weak var collectionView: UICollectionView?
    var delegate: GameDataSourceDelegate?
    
    let proxy: GamesProxy!
    var loadedGames: [Game] = [] {
        didSet {
            collectionView?.reloadData()
        }
    }
    var cellSize: CGSize = CGSize(width: 166, height: 206)
    var page = 1
    private let pageSize = 50
    init(collectionView: UICollectionView, proxy: GamesProxy = GamesProxy()) {
        self.collectionView = collectionView
        self.proxy = proxy
        super.init()
        collectionView.delegate = self
        collectionView.dataSource = self
    }
    
    func reset() {
        page = 1
        proxy.reset()
        loadPage()
    }
    
    func loadPage(completion: ((Error?)->Void)? = nil) {
        let pageIndex = page-1
        delegate?.dataSourceDidBeginFetching(self)
        proxy.loadGames(limit: pageSize, offset: pageIndex * pageSize) { [weak self] (games, saved, error)  in
            self?.loadedGames.append(contentsOf: games)
            if let safeSelf = self {
                safeSelf.delegate?.dataSourceDidEndFetching(safeSelf)
            }
            completion?(error)
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
        cell.configure(game)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return cellSize
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let game = loadedGames[indexPath.row]
        delegate?.dataSource(self, didSelect: game)
    }
}