//
//  SearchViewController.swift
//  InTune
//
//  Created by Christina Lu on 12/2/19.
//  Copyright © 2019 Christina Lu. All rights reserved.
//

import Foundation
import UIKit

class ResultCell: UITableViewCell {
    @IBOutlet weak var songName: UILabel!
    @IBOutlet weak var songArtist: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
}

class SearchViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var db = SongDB()
    @IBOutlet weak var resultsTableView: UITableView!
    @IBOutlet weak var searchBar: UISearchBar!
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.db.songCount()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = resultsTableView.dequeueReusableCell(withIdentifier: "songCell") as? ResultCell
        cell?.textLabel?.text = db.getSong(i: indexPath.row).name
        cell?.detailTextLabel?.text = db.getSong(i: indexPath.row).artist
        return cell!
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.resultsTableView.delegate = self
        self.resultsTableView.dataSource = self
        self.resultsTableView.reloadData()
        
    }
    
    @IBAction func search(_ sender: AnyObject) {
        if let term = searchBar.text {
            QueryService.networkRequestWithSearchTerm(term: term) { (songs) in
                self.db.refreshSongs(songsParam: songs)
                DispatchQueue.main.async {
                    self.resultsTableView.reloadData()
                }
            }
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "writeEntry") {
            let songIndex = resultsTableView.indexPathForSelectedRow?.row
            let selectedSong = db.songs[songIndex!]
            
            if let vc = segue.destination as? AddViewController {
                vc.song = selectedSong
            }
        }
    }
}
