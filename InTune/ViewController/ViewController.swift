//
//  ViewController.swift
//  InTune
//
//  Created by Christina Lu on 11/14/19.
//  Copyright © 2019 Christina Lu. All rights reserved.
//

import UIKit

class EntryCell: UITableViewCell {
    
    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var artist: UILabel!
    @IBOutlet weak var date: UILabel!
    @IBOutlet weak var year: UILabel!
    @IBOutlet weak var color: UIImageView!
    @IBOutlet weak var img: UIImageView!
    
    func updateCell(e: Entry) {
        let dateFormatter = DateFormatter()
        
        title.text = e.name
        artist.text = e.artist
        
        dateFormatter.dateFormat = "MMM d"
        date.text = dateFormatter.string(from: e.date)
        
        dateFormatter.dateFormat = "yyyy"
        year.text = dateFormatter.string(from: e.date)
        
        if let url = URL(string: e.imgUrl) {
            if let data = try? Data(contentsOf: url) {
                img.image = UIImage(data: data)
            }
        }
    }
}

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var entriesTableView: UITableView!
    @IBAction func unwindToHome(segue:UIStoryboardSegue) { }

    let defaults = UserDefaults.standard
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.entriesTableView.delegate = self
        self.entriesTableView.dataSource = self
        if let decoded  = UserDefaults.standard.object(forKey: "entries") as? Data {
            if let decodedEntries = try? NSKeyedUnarchiver.unarchiveTopLevelObjectWithData(decoded) as? [Entry] {
                EntryDB.entries = decodedEntries
            }
        }
        self.entriesTableView.reloadData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.entriesTableView.dataSource = self
        self.entriesTableView.reloadData()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return EntryDB.entries.count
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 20
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let footerView = UIView()
        footerView.backgroundColor = UIColor.clear
        return footerView
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "entry", for: indexPath) as! EntryCell
        let c = EntryDB.entries[indexPath.section]
        cell.updateCell(e: c)
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 90
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "showEntry") {
            let entryIndex = entriesTableView.indexPathForSelectedRow?.section
            let selectedEntry = EntryDB.entries[entryIndex!]
            if let vc = segue.destination as? EntryViewController {
                vc.entry = selectedEntry
            }
        }
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == UITableViewCell.EditingStyle.delete {
            EntryDB.entries.remove(at: indexPath.section)
            entriesTableView.deleteSections([indexPath.section], with: UITableView.RowAnimation.automatic)
        }
    }
}

