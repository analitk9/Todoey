//
//  CategoryViewController.swift
//  Todoey
//
//  Created by Denis Evdokimov on 15/10/2018.
//  Copyright © 2018 Denis Evdokimov. All rights reserved.
//

import UIKit
import CoreData

class CategoryViewController: UITableViewController {
 
    var categoryArray = [Category]()
    
     let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        var textField = UITextField()
        let alert = UIAlertController(title: "Add new Category Todoye", message: "", preferredStyle: .alert)
        let action = UIAlertAction(title: "add category", style: .default) { (action) in
            if let name = textField.text{
                
                
                let newCategory = Category(context: self.context)
                newCategory.name = name
           
                self.categoryArray.append(newCategory)
                self.saveItems()
                
            }
       
        }
        
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Create new category"
            textField = alertTextField
        }
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadCategory()
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
      return  categoryArray.count
    }
    
    //MARK: - TalbeView Delegate Methods
    override  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "goToItems", sender: self)
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationVC = segue.destination as! ToDoListViewController
        if let indexPath = tableView.indexPathForSelectedRow{
            destinationVC.selectedCategory = categoryArray[indexPath.row]
            
        }
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CategoryCell", for: indexPath)
        let catName = categoryArray[indexPath.row]
        cell.textLabel?.text = catName.name
        return cell
    }
    
    //MARK: - Data Manipulation Methods
    func loadCategory(){
        
        let request: NSFetchRequest<Category> = Category.fetchRequest()
        do{
            categoryArray = try context.fetch(request)
        }catch{
            print("problem with fetch \(error)")
        }
        tableView.reloadData()
    }
    
    func saveItems(){
        
        do{
            try context.save()
        }catch{
            print("Error saving context \(error)")
        }
       tableView.reloadData()
    }

}
