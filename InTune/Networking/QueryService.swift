//
//  QueryService.swift
//  InTune
//
//  Created by Christina Lu on 12/4/19.
//  Copyright © 2019 Christina Lu. All rights reserved.
//

import Foundation

class QueryService {
    
    static func networkRequestWithSearchTerm(term: String, completion: @escaping ([Song]) -> Void) {
        
        guard let safeTerm = term.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) else { return }
        let url = URL(string: "https://itunes.apple.com/search?term=\(safeTerm)")
        
        let session = URLSession(configuration: URLSessionConfiguration.default)
        let task = session.dataTask(with: url!) { (data, response, error) in
            
            guard (error == nil) else {
                print(error!.localizedDescription)
                return
            }
            
            guard let status = (response as? HTTPURLResponse)?.statusCode, status == 200 else {
                print("Not 200 response code")
                return
            }
            
        
            if let songs = Song.dataToSongs(data) {
                completion(songs)
            } else {
                print("Error")
            }
        }
        task.resume()
    
    }
    
}
