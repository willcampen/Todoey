//
//  ViewController.swift
//  Todoey
//
//  Created by Will Campen on 04/09/2018.
//  Copyright © 2018 Will Campen. All rights reserved.
//

import UIKit

class TodoListViewController: UITableViewController {

  var itemArray = [Item]()
  
  let defaults = UserDefaults.standard
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    let newItem = Item()
    newItem.title = "Find Mike"
    itemArray.append(newItem)
    
    let newItem2 = Item()
    newItem2.title = "Buy Eggs"
    itemArray.append(newItem2)
    
    let newItem3 = Item()
    newItem3.title = "Destroy Demogorgon"
    itemArray.append(newItem3)
    
    if let items = UserDefaults.standard.array(forKey: "TodoListArray") as? [Item] {
      itemArray = items
    }
    
  }

  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }
  
  //MARK - Tableview Datasource Methods
  
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
  
  //MARK - TableView Delegate Methods
  
  // What to do when a row is selected.
  override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    
    // Inverts the 'done' instance variable value.
    itemArray[indexPath.row].done = !itemArray[indexPath.row].done
    
    tableView.reloadData()
    
    // Deselect the cell, so that it is no longer highlighted
    tableView.deselectRow(at: indexPath, animated: true)
    
  }

  //MARK - Add New Items
  @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
    
    var textField = UITextField()
    
    let alert = UIAlertController(title: "Add New Todoey Item", message: "", preferredStyle: .alert)
    
    let action = UIAlertAction(title: "Add Item", style: .default) { (action) in
      // What will happen once user clicks the add button on our UIAlert
      
      let newItem = Item()
      newItem.title = textField.text!
      
      self.itemArray.append(newItem)
      
      self.defaults.set(self.itemArray, forKey: "TodoListArray")
      
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
  
  
}

