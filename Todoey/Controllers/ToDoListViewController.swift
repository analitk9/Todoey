//
//  ViewController.swift
//  Todoey
//
//  Created by Denis Evdokimov on 03/10/2018.
//  Copyright © 2018 Denis Evdokimov. All rights reserved.
//

import UIKit
import RealmSwift

class ToDoListViewController: UITableViewController {

    var todoItems: Results<Item>?
    var selectedCategory: Category?{
        didSet {
           //loadItems()
        }
    }
    let realm = try! Realm()
    
   
    override func viewDidLoad() {
        super.viewDidLoad()
      // print(FileManager.default.urls(for: .documentDirectory, in: .userDomainMask))
     
    }
    
    //MARK - Tableview DataSource Methods
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return todoItems?.count ?? 1
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ToDoItemCell", for: indexPath)
        let title =  todoItems?[indexPath.row].title ?? "no item added yet"
        let done = todoItems?[indexPath.row].done ?? false
        cell.textLabel?.text = title
        
        cell.accessoryType = done == true ? .checkmark : .none

        return cell
    }
    //MARK -  TableView Delegate Methods
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let item = todoItems?[indexPath.row]{
            do{
                try realm.write {
                    item.done = !item.done
                }
            }catch{
                print(error)
            }
        }
        
        tableView.reloadData()
        
        //  itemArray[indexPath.row].done = !itemArray[indexPath.row].done
        
        //      saveItems()
        
        //   tableView.deselectRow(at: indexPath, animated: true)
     
    }
    
    //MARK  - Add new items
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        var textField = UITextField()
        let alert = UIAlertController(title: "Add new item Todoye item", message: "", preferredStyle: .alert)
        let action = UIAlertAction(title: "add item", style: .default) { (action) in
            if let new = textField.text{
                if let currenCategory = self.selectedCategory {
                    do{
                        try self.realm.write {
                            let newItem = Item()
                            newItem.title = new
                            newItem.dateCreated = Date()
                            currenCategory.items.append(newItem)
                        }
                    }catch{
                        print(error)
                    }
                }
            }
            self.tableView.reloadData()
        }
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Create new item"
            textField = alertTextField
        }
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
    }

    //MARK  - Model Manipulation Methods



    func loadItems(){
        todoItems = selectedCategory?.items.sorted(byKeyPath: "title", ascending: true)
        tableView.reloadData()
    }

}
extension ToDoListViewController: UISearchBarDelegate{
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        todoItems = todoItems?.filter("title CONTAINS[cd] %@", searchBar.text!).sorted(byKeyPath: "dateCreated", ascending: true)
        tableView.reloadData()
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchBar.text?.count == 0 {
            loadItems()

            DispatchQueue.main.async {
                searchBar.resignFirstResponder()
            }

        }
    }

}

