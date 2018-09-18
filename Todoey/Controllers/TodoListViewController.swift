//
//  ViewController.swift
//  Todoey
//
//  Created by Will Campen on 04/09/2018.
//  Copyright © 2018 Will Campen. All rights reserved.
//

import UIKit
import CoreData

class TodoListViewController: UITableViewController {

  var itemArray = [Item]()
  
  var selectedCategory : Category? {
    didSet {
      loadItems()
    }
  }


  // Get shared singleton object of the application, accessing its delegate and down-casting it
  // as the AppDelegate. Can now access AppDelegate as an object, and access the viewContext from
  // persistentContainer in the app delegate.
  let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    // print(FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("Items.plist"))
  }

  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }
  
  //MARK: - Tableview Datasource Methods
  
  override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return itemArray.count
  }
  
  override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    
    // Create cell
    let cell = tableView.dequeueReusableCell(withIdentifier: "ToDoItemCell", for: indexPath)
    
    let item = itemArray[indexPath.row]
    
    // Populate cell with text for current row
    cell.textLabel?.text = item.title
    
    // Use ternary operator to reduece 5 lines of code to 1 line.
    cell.accessoryType = item.done ? .checkmark : .none
    
    // Return (and display) cell
    return cell
  }
  
  //MARK: - TableView Delegate Methods
  
  // What to do when a row is selected.
  override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    
    // Inverts the 'done' instance variable value.
    itemArray[indexPath.row].done = !itemArray[indexPath.row].done
    
    self.saveItems()
    
    // Deselect the cell, so that it is no longer highlighted
    tableView.deselectRow(at: indexPath, animated: true)
    
  }

  //MARK: - Add New Items
  @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
    
    var textField = UITextField()
    
    let alert = UIAlertController(title: "Add New Todoey Item", message: "", preferredStyle: .alert)
    
    let action = UIAlertAction(title: "Add Item", style: .default) { (action) in
      // What will happen once user clicks the add button on our UIAlert
      
      // Create new entity entry, which is a new NSManagedObject. Set title and done fields, and then
      // save the context to the persistent store.
      let newItem = Item(context: self.context)
      newItem.title = textField.text!
      newItem.done = false
      newItem.parentCategory = self.selectedCategory
      self.itemArray.append(newItem)
      
      self.saveItems()
      
      
      self.tableView.reloadData()
    }
    
    alert.addTextField { (alertTextField) in
      alertTextField.placeholder = "Create new item"
      textField = alertTextField
    }
    
    
    alert.addAction(action)
    
    // Show the alert
    present(alert, animated: true, completion: nil)
    
  }
  
  //MARK: - Model Manipulation Methods
  
  func saveItems() {

    do {
      try context.save()
    } catch {
      print("Error saving context \(error)")
    } // catch

    self.tableView.reloadData()
  } // saveItems()
  
  
  func loadItems(with request: NSFetchRequest<Item> = Item.fetchRequest(), predicate: NSPredicate? = nil) {
    
    let categoryPredicate = NSPredicate(format: "parentCategory.name MATCHES %@", selectedCategory!.name!)
    
    if let additionalPredicate = predicate {
      request.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: [categoryPredicate, additionalPredicate])
    } else {
      request.predicate = categoryPredicate
    }
    
    
    do {
      itemArray = try context.fetch(request)
    } catch {
      print("Error fetching data from context \(error)")
    }
    tableView.reloadData()
  } // loadItems()
  
  
}


//MARK: - Search Bar Methods
extension TodoListViewController: UISearchBarDelegate {
  
  func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
    
    let request : NSFetchRequest<Item> = Item.fetchRequest()
    
    let predicate = NSPredicate(format: "title CONTAINS[cd] %@", searchBar.text!)
    
    request.sortDescriptors = [NSSortDescriptor(key: "title", ascending: true)]
    
    loadItems(with: request, predicate: predicate)
    
  }
  
  func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
    if searchBar.text?.count == 0 {
      loadItems()
      
      // In main control thread, dismiss the keyboard
      DispatchQueue.main.async {
        searchBar.resignFirstResponder()
      }
      
    } // if
  }
}

