//
//  Category.swift
//  Todoey
//
//  Created by Will Campen on 18/09/2018.
//  Copyright © 2018 Will Campen. All rights reserved.
//

import Foundation
import RealmSwift

class Category: Object {
  @objc dynamic var name: String = ""
  @objc dynamic var categoryColour: String = "#ffffff"
  let items = List<Item>()
}
