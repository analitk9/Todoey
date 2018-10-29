//
//  CategoryViewController.swift
//  Todoey
//
//  Created by Denis Evdokimov on 15/10/2018.
//  Copyright © 2018 Denis Evdokimov. All rights reserved.
//

import UIKit
import RealmSwift

class CategoryViewController: UITableViewController {
 
    var categories: Results<Category>!
    let realm = try? Realm()


    override func viewDidLoad() {
        super.viewDidLoad()
        loadCategory()
    }

    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        var textField = UITextField()
        let alert = UIAlertController(title: "Add new Category Todoye", message: "", preferredStyle: .alert)
        let action = UIAlertAction(title: "add category", style: .default) { (action) in
            if let name = textField.text{
                let newCategory = Category()
                newCategory.name = name
                //   self.categoryArray.append(newCategory)
                self.save(category: newCategory)
                
            }
            
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
        let cell = tableView.dequeueReusableCell(withIdentifier: "CategoryCell", for: indexPath)
        let catName = categories?[indexPath.row].name ?? "no category add yet"
        cell.textLabel?.text = catName
        return cell
    }
    
    //MARK: - Data Manipulation Methods
    func loadCategory(){
         categories = realm?.objects(Category.self)
        
       tableView.reloadData()
    }
    
    func save(category: Category){
        
        do{
            try realm!.write {
                realm!.add(category)
            }
        }catch{
            print("Error saving context \(error)")
        }
       tableView.reloadData()
    }

}
