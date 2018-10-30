//
//  ViewController.swift
//  Todoey
//
//  Created by Denis Evdokimov on 03/10/2018.
//  Copyright © 2018 Denis Evdokimov. All rights reserved.
//

import UIKit
import RealmSwift
import ChameleonFramework

class ToDoListViewController: SwipeTableViewController {

    @IBOutlet weak var searhBar: UISearchBar!
    
    var todoItems: Results<Item>?
    var selectedCategory: Category?{
        didSet {
           loadItems()
        }
    }
    let realm = try! Realm()
    
   
    override func viewDidLoad() {
        super.viewDidLoad()
       
      // print(FileManager.default.urls(for: .documentDirectory, in: .userDomainMask))
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        title = selectedCategory?.name
        guard let hexColour = selectedCategory?.color else{fatalError()}
        updateNavBar(withHexCode: hexColour)
 
    }
    
    
    override func viewWillDisappear(_ animated: Bool) {
       
       updateNavBar(withHexCode: "1D9BF6")
    }
    
    
    
    func updateNavBar(withHexCode colourHexCode: String){
        
        guard let tintColor = UIColor(hexString: colourHexCode) else {fatalError()}
        guard let navBar = navigationController?.navigationBar else {fatalError("navBar not existing")}
        navBar.barTintColor = tintColor
        navBar.tintColor = ContrastColorOf(backgroundColor: tintColor, returnFlat: true)
        navBar.largeTitleTextAttributes = [NSAttributedString.Key.foregroundColor: ContrastColorOf(backgroundColor: tintColor, returnFlat: true)]
        searhBar.tintColor = tintColor
    }
    
    //MARK - Tableview DataSource Methods
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return todoItems?.count ?? 1
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        let cell = super.tableView(tableView, cellForRowAt: indexPath)
        if  let item =  todoItems?[indexPath.row]{
            if let color = UIColor(hexString:selectedCategory!.color).darken(byPercentage: CGFloat(indexPath.row) / CGFloat(todoItems!.count)){
                
                cell.accessoryType = item.done == true ? .checkmark : .none
                cell.textLabel?.text = item.title
                cell.backgroundColor = color
                cell.textLabel?.textColor = ContrastColorOf(backgroundColor: color, returnFlat: true)
            }
        }
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
        self.tableView.reloadData()
    }

    //MARK  - Model Manipulation Methods


    func loadItems(){
        todoItems = selectedCategory?.items.sorted(byKeyPath: "title", ascending: true)
        tableView.reloadData()
    }
    
    override func updateModel(at indexPath: IndexPath) {
        if let item = self.todoItems?[indexPath.row]{
            do{
                try self.realm.write {
                    self.realm.delete(item)
                }
            }catch{
                print("Error deleting category \(error)")
            }
        }
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

