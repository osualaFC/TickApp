//
//  ViewController.swift
//  Checklist
//
//  Created by fredrick osuala on 15/09/2023.
//

import UIKit

class ChecklistViewController: UITableViewController, AddEditItemViewControllerDelegate {
    
    var checklist: Checklist!

    override func viewDidLoad() {
        super.viewDidLoad()
        title = checklist.name
        navigationItem.largeTitleDisplayMode = .never
    }
    
    //MARK: - Private methods
    func addNewItem(item: ChecklistItem) {
        let newRowIndex = checklist.items.count
        checklist.items.append(item)
        
        let indexPath = IndexPath(row: newRowIndex, section: 0)
        let indexPaths = [indexPath]
        tableView.insertRows(at: indexPaths, with: .automatic)
    }
    
    //MARK: - AddItemViewController delegates
    func addEditItemViewControllerDidCancel(_ controller: AddEditItemViewController) {
        navigationController?.popViewController(animated: true)
    }
    
    func addEditItemViewController(_ controller: AddEditItemViewController, didFinishAddingItem item: ChecklistItem) {
        addNewItem(item: item)
        navigationController?.popViewController(animated: true)
    }
    
    func addEditItemViewController(_ controller: AddEditItemViewController, didFinishEditingItem item: ChecklistItem) {
        if let index = checklist.items.firstIndex(of: item) {
            let indexPath = IndexPath(row: index, section: 0)
            if let cell = tableView.cellForRow(at: indexPath) {
                configureText(for: cell, with: item)
            }
        }
        navigationController?.popViewController(animated: true)
    }
    
    //MARK: - UITableViewDataSource
    //Protocol to return no of rows in the table usually based on data size
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return checklist.items.count
    }
    
    //Protocol to determine the cell for a row - this is where you will normally put the row data into the cell
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(
            withIdentifier: "ChecklistItem",
            for: indexPath
        )
        
        let item = checklist.items[indexPath.row]
        configureText(for: cell, with: item)
        configureCheckmark(for: cell, with: item)
        return cell
    }
    
    //MARK: - UITableViewDelegate
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if let cell = tableView.cellForRow(at: indexPath) {
            let item = checklist.items[indexPath.row]
             item.checked.toggle()
             configureCheckmark(for: cell, with: item)
        }
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    //swipe to delete
    override func tableView(
        _ tableView: UITableView,
        commit editingStyle: UITableViewCell.EditingStyle,
        forRowAt indexPath: IndexPath
    ) {
        checklist.items.remove(at: indexPath.row)
        let indexPaths = [indexPath]
        tableView.deleteRows(at: indexPaths, with: .automatic)
    }
    
    //MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "AddItem" {
            let controller = segue.destination as! AddEditItemViewController
            controller.delegate = self
        }
        else if segue.identifier == "EditItem" {
            let controller = segue.destination as! AddEditItemViewController
            controller.delegate = self
            
            if let indexPath = tableView.indexPath(for: sender as! UITableViewCell) {
                controller.itemToEdit = checklist.items[indexPath.row]
            }
        }
    }
    
    //MARK: - Custom Methods
    func configureCheckmark(for cell: UITableViewCell, with item: ChecklistItem) {
        let lebel = cell.viewWithTag(1001) as! UILabel
        if item.checked {
            lebel.text = "√"
         } else {
             lebel.text = ""
            }
        }
    
    func configureText(for cell: UITableViewCell, with item: ChecklistItem) {
        let label = cell.viewWithTag(1000) as! UILabel
        label.text = item.text
    }

}

//    func documentsDirectory() -> URL {
//        let paths = FileManager.default.urls(for: .documentDirectory,in: .userDomainMask)
//        return paths[0]
//    }
//
//    func dataFilePath() -> URL {
//        return documentsDirectory().appendingPathComponent("Checklists.plist")
//    }
//
//    func saveCheckListItems() {
//        let encoder = PropertyListEncoder()
//        do {
//            let data = try encoder.encode(items)
//            try data.write(to: dataFilePath(), options: Data.WritingOptions.atomic)
//        } catch {
//            print("Error encoding items array \(error.localizedDescription)")
//        }
//    }
//
//    func loadCheckListItems() {
//        let path = dataFilePath()
//        if let data = try? Data(contentsOf: path) {
//            let decoder = PropertyListDecoder()
//            do {
//                items = try decoder.decode([ChecklistItem].self, from: data)
//            }
//        catch {
//            print("Error encoding items array \(error.localizedDescription)")
//        }
//    }
//}

