//
//  CategoryViewController.swift
//  Todoey
//
//  Created by Will Campen on 17/09/2018.
//  Copyright © 2018 Will Campen. All rights reserved.
//

import UIKit
import CoreData

class CategoryViewController: UITableViewController {
  
  var categoryArray = [Category]()
  
  let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext

    override func viewDidLoad() {
        super.viewDidLoad()
        loadCategories()

    }
  
  //MARK: - TableView Datasource Methods
  
  override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return categoryArray.count
  }
  
  override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    // Create Cell
    let cell = tableView.dequeueReusableCell(withIdentifier: "CategoryCell", for: indexPath)
    
    // Populate newly created cell with text from categoryArray entry
    cell.textLabel?.text = categoryArray[indexPath.row].name
    
    return cell
  }
  
  //MARK: - TableView Delegate Methods
  override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    
    performSegue(withIdentifier: "goToItems", sender: self)
    
  }
  
  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    let destinationVC = segue.destination as! TodoListViewController
    
    if let indexPath = tableView.indexPathForSelectedRow {
      destinationVC.selectedCategory = categoryArray[indexPath.row]
    }
  }
  
  
  
  //MARK: - Data Manipulation Methods
  
  func saveCategories() {
    do {
      try context.save()
    } catch {
      print("Error saving context \(error)")
    } // catch
    
    self.tableView.reloadData()
  } // saveCategories()

  
  func loadCategories(with request: NSFetchRequest<Category> = Category.fetchRequest()) {
    do {
      categoryArray = try context.fetch(request)
    } catch {
      print("Error fetching data from context \(error)")
    } // catch
    
    tableView.reloadData()
    
  } // loadCategories()
  
  

  //MARK: - Add New Categories
  
  @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
    
    var textField = UITextField()
    
    let alert = UIAlertController(title: "Add New Category", message: "", preferredStyle: .alert)
    
    let action = UIAlertAction(title: "Add Category", style: .default) { (action) in
      let newCategory = Category(context: self.context)
      newCategory.name = textField.text
      self.categoryArray.append(newCategory)
      
      self.saveCategories()
      
    }
    
    alert.addTextField { (alertTextField) in
      alertTextField.placeholder = "Create new category"
      textField = alertTextField
    }
    
    alert.addAction(action)
    
    // Show the alert
    present(alert, animated: true, completion: nil)
    
  }
  



  
  

}
