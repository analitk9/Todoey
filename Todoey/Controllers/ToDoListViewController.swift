//
//  ViewController.swift
//  Todoey
//
//  Created by Denis Evdokimov on 03/10/2018.
//  Copyright © 2018 Denis Evdokimov. All rights reserved.
//

import UIKit

class ToDoListViewController: UITableViewController {
   
    var itemArray = [Item]()
    
     let dataFilePath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("Items.plist")
    
    //let userDefault = UserDefaults.standard
    
    override func viewDidLoad() {
        super.viewDidLoad()
       
       
        
        let newItem = Item()
        newItem.title = "Fine Mike"
        itemArray.append(newItem)
        let newItem2 = Item()
        newItem.title = "Fine Dave"
        itemArray.append(newItem2)
        let newItem3 = Item()
        newItem.title = "Fine Eggos"
        itemArray.append(newItem3)
        
//       if let items = userDefault.array(forKey: "TodoListArray") as? [Item]{
//          itemArray = items
//        }
      
    }
    
    //MARK - Tableview DataSource Methods
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemArray.count
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ToDoItemCell", for: indexPath)
        let item =  itemArray[indexPath.row]
        cell.textLabel?.text = item.title
        
        cell.accessoryType = item.done == true ? .checkmark : .none

        return cell
    }
    //MARK -  TableView Delegate Methods
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        //print(itemArray[indexPath.row])
      itemArray[indexPath.row].done = !itemArray[indexPath.row].done
        
       
        tableView.deselectRow(at: indexPath, animated: true)
        tableView.reloadData()
    }
    
    //MARK Add new items
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        var textField = UITextField()
        let alert = UIAlertController(title: "Add new item Todoye item", message: "", preferredStyle: .alert)
        let action = UIAlertAction(title: "add item", style: .default) { (action) in
            if let new = textField.text{
               let newItem = Item()
                newItem.title = new
                self.itemArray.append(newItem)
                let encoder =  PropertyListEncoder()
                do{
                    let data = try encoder.encode(self.itemArray)
                    try data.write(to: self.dataFilePath!)
                }catch{
                    print("error encoding \(error)")
                }
                
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

