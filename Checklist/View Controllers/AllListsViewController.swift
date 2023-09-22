//
//  AllListsViewController.swift
//  Checklist
//
//  Created by fredrick osuala on 18/09/2023.
//

import UIKit

class AllListsViewController: UITableViewController, ListDetailViewControllerDelegate, UINavigationControllerDelegate {
    
    
    let cellIdentifier = "ChecklistCell"
    
    var dataModel: DataModel!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationController?.navigationBar.prefersLargeTitles = true
        //add a table view cell programmatically
        //tableView.register(UITableViewCell.self, forCellReuseIdentifier: cellIdentifier)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tableView.reloadData()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        navigationController?.delegate = self
        let index = dataModel.indexOfSelectedChecklist
        if index >= 0 && index < dataModel.lists.count {
            let checklist = dataModel.lists[index]
            performSegue(withIdentifier: "ShowCheckList", sender: checklist)
        }
    }
    
    //MARK: - Navigation controller
    //listen for onbackpressed
    func navigationController(_ navigationController: UINavigationController, willShow viewController: UIViewController, animated: Bool) {
        if viewController === self {
            dataModel.indexOfSelectedChecklist = -1
        }
    }

    // MARK: - Table view data source
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataModel.lists.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell : UITableViewCell!
        if let temp = tableView.dequeueReusableCell(withIdentifier: cellIdentifier) {
            cell = temp
        } else {
            cell = UITableViewCell(style: .subtitle, reuseIdentifier: cellIdentifier)
        }
        let checkList = dataModel.lists[indexPath.row]
        cell.textLabel!.text = checkList.name
        let count = checkList.countUnCheckedItems()
        if checkList.items.count == 0 {
            cell.detailTextLabel!.text = "No items"
        } else {
        cell.detailTextLabel!.text = count == 0 ? "All done" : "\(count) remaining"
        }
        cell.accessoryType = .detailDisclosureButton
        cell.imageView!.image = UIImage(named: checkList.iconName)
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let checklist = dataModel.lists[indexPath.row]
        performSegue(withIdentifier: "ShowCheckList", sender: checklist)
        tableView.deselectRow(at: indexPath, animated: true)
        dataModel.indexOfSelectedChecklist = indexPath.row
    }
    
    override func tableView( _ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        dataModel.lists.remove(at: indexPath.row)
        let indexPaths = [indexPath]
        tableView.deleteRows(at: indexPaths, with: .automatic)
    }
    
    override func tableView(_ tableView: UITableView, accessoryButtonTappedForRowWith indexPath: IndexPath) {
        let controller = storyboard?.instantiateViewController(withIdentifier: "ListDetailViewController") as! ListDetailViewController
        controller.delegate = self
        let checklist = dataModel.lists[indexPath.row]
        controller.checklistToEdit = checklist
        navigationController?.pushViewController(controller, animated: true)
    }
    
    //MARK: - List details delegate
    func listDetailViewControllerDidCancel(_ controller: ListDetailViewController) {
        navigationController?.popViewController(animated: true)
    }
    
    func listDetailViewController(_ controller: ListDetailViewController, didFinishAdding checklist: Checklist) {
        let index = dataModel.lists.count
        dataModel.lists.append(checklist)
        
        let indexPath = IndexPath(row: index, section: 0)
        let indexPaths = [indexPath]
        tableView.insertRows(at: indexPaths, with: .automatic)
        dataModel.sortItems()
        tableView.reloadData()
        navigationController?.popViewController(animated: true)
    }
    
    func listDetailViewController(_ controller: ListDetailViewController, didFinishEditing checklist: Checklist) {
        if let index = dataModel.lists.firstIndex(of: checklist) {
            let indexPath = IndexPath(row: index, section: 0)
            if let cell = tableView.cellForRow(at: indexPath) {
                cell.textLabel?.text = checklist.name
            }
        }
        dataModel.sortItems()
        tableView.reloadData()
        navigationController?.popViewController(animated: true)
    }
    
    //MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ShowCheckList" {
            let controller = segue.destination as! ChecklistViewController
            controller.checklist = sender as? Checklist
        }
       else if segue.identifier == "AddChecklist" {
           let controller = segue.destination as! ListDetailViewController
           controller.delegate = self
        }
//        else if segue.identifier == "EditChecklist" {
//            let controller = segue.destination as! ListDetailViewController
//            controller.delegate = self
//         }
    }


}
