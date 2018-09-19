//
//  SwipeTableViewController.swift
//  Todoey
//
//  Created by Will Campen on 19/09/2018.
//  Copyright © 2018 Will Campen. All rights reserved.
//

import UIKit
import SwipeCellKit

class SwipeTableViewController: UITableViewController, SwipeTableViewCellDelegate {

  override func viewDidLoad() {
      super.viewDidLoad()
      tableView.rowHeight = 80
  }
  
  //TableView Datasource Methods
  override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    // Create Cell
    let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! SwipeTableViewCell

    cell.delegate = self
    
    return cell
  } // cellForRowAt
  
  func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> [SwipeAction]? {
    
    guard orientation == .right else { return nil }
    
    let deleteAction = SwipeAction(style: .destructive, title: "Delete") { action, indexPath in
      // handle action by updating model with deletion
      self.updateModel(at: indexPath)

    } // closure
    
    // customize the action appearance
    deleteAction.image = UIImage(named: "delete-icon")
    
    // Return delete action as a response to the user swiping the cell
    return [deleteAction]
  }
  
  // Function to customise swipe style
  func tableView(_ tableView: UITableView, editActionsOptionsForRowAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> SwipeOptions {
    var options = SwipeOptions()
    options.expansionStyle = .destructive
    return options
  }
  
  func updateModel(at indexPath: IndexPath) {
    // Update data model
    print("Item deleted from superclass")
  }

} // class
