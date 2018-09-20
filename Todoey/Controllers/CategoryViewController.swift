//
//  CategoryViewController.swift
//  Todoey
//
//  Created by Will Campen on 17/09/2018.
//  Copyright © 2018 Will Campen. All rights reserved.
//

import UIKit
import RealmSwift
import ChameleonFramework

class CategoryViewController: SwipeTableViewController {
  
  // Declare and create a new realm
  let realm = try! Realm()
  
  var categories: Results<Category>?
  

  override func viewDidLoad() {
    super.viewDidLoad()
  
    loadCategories()
  
    tableView.separatorStyle = .none
      
  } // viewDidLoad()
  
  //MARK: - TableView Datasource Methods
  
  override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    
    return categories?.count ?? 1
    
  }
  
  override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    
    let cell = super.tableView(tableView, cellForRowAt: indexPath)
    
    // Populate newly created cell with text from categories entry. Otherwise, set text of the only
    // cell visible with message to say no categories.
    cell.textLabel?.text = categories?[indexPath.row].name ?? "No categories added yet"
    
    if let category = categories?[indexPath.row] {
      
      guard let categoryBackgroundColour = UIColor(hexString: category.categoryColour) else {fatalError()}
    
      cell.backgroundColor = categoryBackgroundColour
      
      cell.textLabel?.textColor = ContrastColorOf(categoryBackgroundColour, returnFlat: true)
    }
  
    return cell
  }
  
  //MARK: - TableView Delegate Methods
  override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    
    performSegue(withIdentifier: "goToItems", sender: self)
    
  }
  
  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    let destinationVC = segue.destination as! TodoListViewController
    
    if let indexPath = tableView.indexPathForSelectedRow {
      destinationVC.selectedCategory = categories?[indexPath.row]
    }
  }
  
  
  
  //MARK: - Data Manipulation Methods
  
  func save(category: Category) {
    do {
      try realm.write {
        realm.add(category)
      }
    } catch {
      print("Error saving context \(error)")
    } // catch
    
    self.tableView.reloadData()
  } // saveCategories()

  
  func loadCategories() {
  
    categories = realm.objects(Category.self)
    tableView.reloadData()
  
  } // loadCategories()
  
  //MARK: - Delete data from Swipe
  
  override func updateModel(at indexPath: IndexPath) {
    if let categoryToDelete = self.categories?[indexPath.row] {
      do {
        try self.realm.write {
          self.realm.delete(categoryToDelete)
        }
      } catch {
        print("Error deleting category, \(error)")
      } // catch
    } // optional binding
  } // updateModel
  
  
  //MARK: - Add New Categories
  
  @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
    
    var textField = UITextField()
    
    let alert = UIAlertController(title: "Add New Category", message: "", preferredStyle: .alert)
    
    let action = UIAlertAction(title: "Add Category", style: .default) { (action) in
      
      let newCategory = Category()
      newCategory.name = textField.text!
      // Persist random background colour for newly created cell, storing the hexValue of the random
      // colour in a string.
      newCategory.categoryColour = UIColor.randomFlat.hexValue()
      
      self.save(category: newCategory)
    }
    
    alert.addTextField { (alertTextField) in
      alertTextField.placeholder = "Create new category"
      textField = alertTextField
    }
    
    alert.addAction(action)
    
    // Show the alert
    present(alert, animated: true, completion: nil)
  } // addButtonPressed
  
} // class
