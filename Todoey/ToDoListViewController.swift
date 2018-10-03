//
//  ViewController.swift
//  Todoey
//
//  Created by Denis Evdokimov on 03/10/2018.
//  Copyright © 2018 Denis Evdokimov. All rights reserved.
//

import UIKit

class ToDoListViewController: UITableViewController {
    var itemArray = ["найти молоко", "купить яйца","уничтожить Демогоргону","Спасти мир","съесть лягушку"]
    let userDefault = UserDefaults.standard
    override func viewDidLoad() {
        super.viewDidLoad()
        if let items = userDefault.array(forKey: "TodoListArray") as? [String]{
            itemArray = items
        }
      
    }
    
    //MARK - Tableview DataSource Methods
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemArray.count
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ToDoItemCell", for: indexPath)
        cell.textLabel?.text = itemArray[indexPath.row]
        return cell
    }
    //MARK -  TableView Delegate Methods
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        //print(itemArray[indexPath.row])
        if tableView.cellForRow(at: indexPath)?.accessoryType == .checkmark{
            tableView.cellForRow(at: indexPath)?.accessoryType = .none
        }else {
            tableView.cellForRow(at: indexPath)?.accessoryType = .checkmark
        }
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    //MARK Add new items
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        var textField = UITextField()
        let alert = UIAlertController(title: "Add new item Todoye item", message: "", preferredStyle: .alert)
        let action = UIAlertAction(title: "add item", style: .default) { (action) in
            if let newItem = textField.text{
                self.itemArray.append(newItem)
                self.userDefault.set(self.itemArray, forKey: "TodoListArray")
              self.tableView.reloadData()
            }
            // добавление новой задачи в масссив ТуДу
        }
        
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Create new item"
            textField = alertTextField
        }
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
    }
    
}

