//
//  EntryDB.swift
//  InTune
//
//  Created by Christina Lu on 12/4/19.
//  Copyright © 2019 Christina Lu. All rights reserved.
//

import Foundation

struct EntryDB {
    
    static var entries : [Entry] = []
    
    static func addEntry(e: Entry) {
        entries.insert(e, at: 0)
        let encodedData = try? NSKeyedArchiver.archivedData(withRootObject: entries, requiringSecureCoding: true)
        let defaults = UserDefaults.standard
        defaults.set(encodedData, forKey: "entries")

    }
    
}
