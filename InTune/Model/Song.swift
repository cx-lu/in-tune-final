//
//  Song.swift
//  InTune
//
//  Created by Christina Lu on 12/4/19.
//  Copyright © 2019 Christina Lu. All rights reserved.
//

import Foundation
import UIKit

struct SongsWrapper: Codable {
    let results : [Song]
}

struct Song : Codable {
    var name : String = ""
    var artist : String = ""
    var previewUrl : String = ""
    var imageUrl : String = ""
    
    init(name : String, artist : String, previewUrl : String, imageUrl: String) {
        self.name = name
        self.artist = artist
        self.previewUrl = previewUrl
        self.imageUrl = imageUrl
    }
    
    enum CodingKeys : String, CodingKey {
        case name = "trackName"
        case artist = "artistName"
        case previewUrl
        case imageUrl = "artworkUrl100"
    }
    
    func getUrl() -> URL? {
        let url = URL(string: previewUrl)
        return url
    }
    
    static func getImage(from url: URL) -> UIImage? {
        if let data = try? Data(contentsOf: url) {
            return UIImage(data: data)
        }
        return nil
    }
    
    static func dataToSongs(_ data : Data?) -> [Song]? {
        guard let data = data else {
            print("Error: Nothing to decode")
            return nil
        }
        
        let decoder = JSONDecoder()
        
        guard let songWrapper = try? decoder.decode(SongsWrapper.self, from: data) else {
            print(data)
            print("Error: Unable to decode songs data to Song")
            return nil
        }
        
        print("Success")
        return songWrapper.results
    }

}
