//
//  SongDB.swift
//  InTune
//
//  Created by Christina Lu on 12/4/19.
//  Copyright © 2019 Christina Lu. All rights reserved.
//

import Foundation

struct SongDB {
    var songs = [Song]()
    
    func songCount() -> Int {
        return songs.count
    }
    
    func getSong(i: Int) -> Song {
        return songs[i]
    }
    
    mutating func refreshSongs(songsParam: [Song]) {
        songs.removeAll()
        songs.append(contentsOf: songsParam)
    }
    
}
