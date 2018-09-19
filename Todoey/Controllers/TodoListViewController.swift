//
//  ViewController.swift
//  Todoey
//
//  Created by Will Campen on 04/09/2018.
//  Copyright © 2018 Will Campen. All rights reserved.
//

import UIKit
import RealmSwift

class TodoListViewController: UITableViewController {

  var todoItems: Results<Item>?
  let realm = try! Realm()
  
  var selectedCategory : Category? {
    didSet {
      loadItems()
    }
  }
  
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
    return todoItems?.count ?? 1
  }
  
  override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    
    // Create cell
    let cell = tableView.dequeueReusableCell(withIdentifier: "ToDoItemCell", for: indexPath)
    
    if let item = todoItems?[indexPath.row] {
      
      // Populate cell with text for current row
      cell.textLabel?.text = item.title
      
      // Use ternary operator to reduece 5 lines of code to 1 line.
      cell.accessoryType = item.done ? .checkmark : .none
    } else {
      cell.textLabel?.text = "No items added"
    }
    
    // Return (and display) cell
    return cell
  }
  
  
  //MARK: - TableView Delegate Methods
  
  // What to do when a row is selected.
  override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    
    // If todoItems is not nil, pick out the item at indexPath.row and write the new checkmark status
    // to realm.
    if let item = todoItems?[indexPath.row] {
      do {
        try realm.write {
          item.done = !item.done
        }
      } catch {
        print("Error saving done status, \(error)")
      } // catch
    }
      
    tableView.reloadData()
    
    // Deselect the cell, so that it is no longer highlighted
    tableView.deselectRow(at: indexPath, animated: true)
  }
  
  
  //MARK: - Add New Items
  @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
    
    var textField = UITextField()
    
    let alert = UIAlertController(title: "Add New Todoey Item", message: "", preferredStyle: .alert)
    
    let action = UIAlertAction(title: "Add Item", style: .default) { (action) in
      // What will happen once user clicks the add button on our UIAlert
      
      if let currentCategory = self.selectedCategory {
        do {
          try self.realm.write() {
            let newItem = Item()
            newItem.title = textField.text!
            newItem.dateCreated = Date()
            // Append the new item to the list of items in the current category
            currentCategory.items.append(newItem)
          }
        } catch {
          print("Error saving new items, \(error)")
        } // catch
      } // Optional binding block
      
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
  
  func loadItems() {
    
    todoItems = selectedCategory?.items.sorted(byKeyPath: "dateCreated", ascending: true)
    tableView.reloadData()
    
  } // loadItems()
  
}


// MARK: - Search Bar Methods
extension TodoListViewController: UISearchBarDelegate {

  func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
    
    // Filter realm results (in todoItems) by title using searchBar text. Then sort in order of dateCreated.
    todoItems = todoItems?.filter("title CONTAINS[cd] %@", searchBar.text!).sorted(byKeyPath: "dateCreated", ascending: true)

    tableView.reloadData()

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

