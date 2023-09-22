//
//  DataModel.swift
//  Checklist
//
//  Created by fredrick osuala on 19/09/2023.
//

import Foundation

class DataModel {
    var lists = [Checklist]()
    
    init() {
        loadCheckListData()
        registerDefaults()
        handleFirstTime()
    }
    
    var indexOfSelectedChecklist: Int {
        get {
            UserDefaults.standard.integer(forKey: "ChecklistIndex")
        }
        set {
            UserDefaults.standard.set(newValue, forKey: "ChecklistIndex")
        }
    }
    
    func sortItems() {
        lists.sort { item1, item2 in
            return item1.name.localizedStandardCompare(item2.name) == .orderedAscending
        }
    }
    
    func documentsDirectory() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory,in: .userDomainMask)
        return paths[0]
    }

    func dataFilePath() -> URL {
        return documentsDirectory().appendingPathComponent("Checklists.plist")
    }

    func saveCheckListData() {
        let encoder = PropertyListEncoder()
        do {
            let data = try encoder.encode(lists)
            try data.write(to: dataFilePath(), options: Data.WritingOptions.atomic)
        } catch {
            print("Error encoding items array \(error.localizedDescription)")
        }
    }

    func loadCheckListData() {
        let path = dataFilePath()
        if let data = try? Data(contentsOf: path) {
            let decoder = PropertyListDecoder()
            do {
                lists = try decoder.decode([Checklist].self, from: data)
                sortItems()
            }
        catch {
            print("Error encoding items array \(error.localizedDescription)")
        }
    }
}
    
    func registerDefaults() {
        let dictionary = [ "ChecklistIndex": -1, "FirstTime": true ] as [String: Any]
        UserDefaults.standard.register(defaults: dictionary)
    }
    
    func handleFirstTime() {
        let userDefaults = UserDefaults.standard
        let firstTime = userDefaults.bool(forKey: "FirstTime")
        if firstTime {
            let checklist = Checklist(name: "List")
            lists.append(checklist)
            indexOfSelectedChecklist = 0
            userDefaults.set(false, forKey: "FirstTime")
        }
    }
    
    class func nextChecklistItemID() -> Int {
        let userDefaults = UserDefaults.standard
        let itemID = userDefaults.integer(forKey: "ChecklistItemID")
        userDefaults.set(itemID + 1, forKey: "ChecklistItemID")
        return itemID
    }
    
}
