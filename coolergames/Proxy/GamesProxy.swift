//
//  GamesProxy.swift
//  coolergames
//
//  Created by Vitor Rodrigues on 2/15/18.
//  Copyright © 2018 Vitor Rodrigues. All rights reserved.
//

import UIKit

class GamesProxy: NSObject {

    let repository = GamesRepository()
    let requester = TopGamesRequester()
    var allGames: [Game] = []
    var lastFetchOffset = -1
    
    func reset() {
        repository.reset()
        allGames = []
        lastFetchOffset = -1
    }
    
    /**
     Fetch the games in coredata, if there's no one available, download from the web
     The completion block returns the newest games and a boolean indicating if it's on
     our  repository :)
     */
    func loadGames(limit: Int = 100, offset: Int = 0, completion: @escaping ([Game], Bool, Error?)->Void) {
        guard lastFetchOffset < offset else {
            completion([], false, nil)
            return
        }
        lastFetchOffset = offset
        if let games = repository.loadStoredGames(limit: limit, offset: offset), !games.isEmpty {
            let newGames = games.flatMap({ Game(from: $0) })
            self.allGames.append(contentsOf: newGames)
            completion(newGames, true, nil)
        } else {
            // I will not use the return of this getter because I'm not controlling the cancellation
            // of an "ongoing request"
            _ = requester.getTop(limit, offset: offset, completion: { (result) in
                switch result {
                case .failure(let error):
                    completion([], false, error)
                case .success(let newGames):
                    self.allGames.append(contentsOf: newGames)
                    self.store(games: newGames)
                    completion(newGames, false, nil)
                }
            })
        }
    }
    
    private func store(games: [Game]) {
        let saved = repository.storeAll(games, in: repository.backgroundContext)
        if saved {
            print("All data stored")
        } else {
            print("Couldn't store those games in coredata")
        }
    }
}
