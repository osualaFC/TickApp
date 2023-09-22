//
//  CheckList.swift
//  Checklist
//
//  Created by fredrick osuala on 18/09/2023.
//

import UIKit

class Checklist: NSObject, Codable {
    var name = ""
    var items: [ChecklistItem] = []
    var iconName = "No Icon"
    
    init(name: String) {
        self.name = name
        super.init()
    }
    
    func countUnCheckedItems() -> Int {
        var count = 0
        if !items.isEmpty {
            for item in items where !item.checked {
                count += 1
            }
        }
        return count
    }
    
}
