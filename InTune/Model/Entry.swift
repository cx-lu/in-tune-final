//
//  Entry.swift
//  InTune
//
//  Created by Christina Lu on 11/21/19.
//  Copyright © 2019 Christina Lu. All rights reserved.
//

import Foundation
import UIKit

struct Entry {
    var name : String = ""
    var artist : String = ""
    var imgUrl : String = ""
    var date : Date
    var lyrics : String = ""
    var journalEntry : String = ""
    var color : UIColor
    var song : Song
    
    init(song: Song, journalEntry : String, color: UIColor, date: Date) {
        self.name = song.name
        self.artist = song.artist
        self.imgUrl = song.imageUrl
        self.date = date
        self.journalEntry = journalEntry
        self.color = color
        self.song = song
}

}
