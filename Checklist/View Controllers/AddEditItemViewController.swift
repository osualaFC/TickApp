//
//  AddItemTableViewController.swift
//  Checklist
//
//  Created by fredrick osuala on 16/09/2023.
//

import UIKit

protocol AddEditItemViewControllerDelegate : AnyObject {
    func addEditItemViewControllerDidCancel(_ controller: AddEditItemViewController)
    func addEditItemViewController(
        _ controller: AddEditItemViewController,
        didFinishAddingItem item: ChecklistItem
    )
    func addEditItemViewController(
        _ controller: AddEditItemViewController,
        didFinishEditingItem item: ChecklistItem
    )
}

class AddEditItemViewController: UITableViewController, UITextFieldDelegate {
    
    weak var delegate: AddEditItemViewControllerDelegate?
    
    var itemToEdit: ChecklistItem?
    
    @IBOutlet weak var textField: UITextField!

    @IBOutlet weak var doneBarButton: UIBarButtonItem!
    
    @IBOutlet weak var shouldRemindSwitch: UISwitch!
    
    @IBOutlet weak var datePicker: UIDatePicker!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.largeTitleDisplayMode = .never
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        textField.becomeFirstResponder()
        
        if let itemToEdit = itemToEdit {
            title = "Edit Item"
            textField.text = itemToEdit.text
            shouldRemindSwitch.isOn = itemToEdit.shouldRemind
            datePicker.date = itemToEdit.dueDate
            doneBarButton.isEnabled = true
        }
    }
    
    //MARK: - Private methods
    
    @IBAction func shouldRemindToggled(_ switchControl: UISwitch) {
        textField.resignFirstResponder()
        if switchControl.isOn {
            let center = UNUserNotificationCenter.current()
            center.requestAuthorization(options: [.alert, .sound]) {_, _
            in
                // do nothing
            }
        }
    }
    
    //MARK: - TextField Delegate
    // It is invoked every time the user changes the text, whether by tapping on the keyboard or via cut/paste.
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let oldText = textField.text!
        let stringRange = Range(range, in: oldText)!
        let newText = oldText.replacingCharacters(in: stringRange, with: string)
        doneBarButton.isEnabled = !newText.isEmpty
        return true
    }
    // called when the textfiled is cleared using the clear button
    func textFieldShouldClear(_ textField: UITextField) -> Bool {
        doneBarButton.isEnabled = false
        return true
    }

    // MARK: - Actions
    @IBAction func cancel() {
        delegate?.addEditItemViewControllerDidCancel(self)
    }
    
    @IBAction func done() {
        if let item = itemToEdit {
            item.text = textField.text!
            item.dueDate = datePicker.date
            item.shouldRemind = shouldRemindSwitch.isOn
            item.scheduleNotification()
            delegate?.addEditItemViewController(self, didFinishEditingItem: item)
        } else {
            let item = ChecklistItem()
            item.text = textField.text!
            item.dueDate = datePicker.date
            item.shouldRemind = shouldRemindSwitch.isOn
            item.scheduleNotification()
            delegate?.addEditItemViewController(self, didFinishAddingItem: item)
        }
    }
    
    //MARK: - Table view delegates
    
    //disable selection
    override func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath? {
        return nil
    }

}
