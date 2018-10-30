//
//  CategoryViewController.swift
//  Todoey
//
//  Created by Denis Evdokimov on 15/10/2018.
//  Copyright © 2018 Denis Evdokimov. All rights reserved.
//

import UIKit
import RealmSwift
import  ChameleonFramework


class CategoryViewController: SwipeTableViewController{
   
 
    var categories: Results<Category>?
    let realm = try! Realm()


    override func viewDidLoad() {
        super.viewDidLoad()
        loadCategory()
        tableView.separatorStyle = .none
   
    }

    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        var textField = UITextField()
        let alert = UIAlertController(title: "Add new Category Todoye", message: "", preferredStyle: .alert)
        let action = UIAlertAction(title: "add category", style: .default) { (action) in
            if let name = textField.text{
                let newCategory = Category()
                newCategory.name = name
                newCategory.color = UIColor.randomFlat()?.hexValue()
                self.save(category: newCategory)
            }
            self.tableView.reloadData()
        }
        
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Create new category"
            textField = alertTextField
        }
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
        
    }
    
 
     //MARK: - TalbeView Delegate Methods
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
      return  categories?.count ?? 1
    }
    
   
    override  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "goToItems", sender: self)
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationVC = segue.destination as! ToDoListViewController
        if let indexPath = tableView.indexPathForSelectedRow{
            destinationVC.selectedCategory = categories?[indexPath.row]
            
        }
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
   
        let cell = super.tableView(tableView, cellForRowAt: indexPath)
        cell.textLabel?.text = categories?[indexPath.row].name ?? "no category add yet"
       
        guard let categoryColor = categories?[indexPath.row].color else { fatalError()}
        
        cell.backgroundColor = UIColor(hexString: categoryColor)
        cell.textLabel?.textColor = ContrastColorOf(backgroundColor: UIColor(hexString: categoryColor), returnFlat: true)

        return cell
    }
    
    //MARK: - Data Manipulation Methods
    func loadCategory(){
         categories = realm.objects(Category.self)
        
       tableView.reloadData()
    }
    
    func save(category: Category){
        
        do{
            try realm.write {
                realm.add(category)
            }
        }catch{
            print("Error saving context \(error)")
        }
      
    }
    
    //MARK: -  Delete Data from swipe
    override func updateModel(at indexPath: IndexPath) {
        if let categoryForDeletion = self.categories?[indexPath.row]{
            do{
                try self.realm.write {
                    self.realm.delete(categoryForDeletion)
                }
            }catch{
                print("Error deleting category \(error)")
            }
        }
    }
    }
    





