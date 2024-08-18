//
//  ViewController.swift
//  Todoey
//
//  Created by Philipp Muellauer on 02/12/2019.
//  Copyright © 2019 App Brewery. All rights reserved.
//

import UIKit
//import CoreData
import RealmSwift
import ChameleonFramework

class ToDoListViewController: SwipeTableViewController {
    
    @IBOutlet weak var searchBar: UISearchBar!
    let realm = try! Realm()
    
    //    var items = [Item]()
    var toDoItems: Results<Item>?
    
    var selectedCategory : Category? {
        didSet {
            loadItems()
            
        }
    }
    
    //    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    //    let defaults = UserDefaults.standard
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.separatorStyle = .none
        
        //        let dataFilePath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        //        print(dataFilePath)
        
        
        //        print(dataFilePath)
        
        //        let newItem = Item()
        //        newItem.title = "Find Mike"
        //        toDoItems.append(newItem)
        //
        //        let newItem1 = Item()
        //        newItem1.title = "Buy Eggos"
        //        toDoItems.append(newItem1)
        //
        //        let newItem2 = Item()
        //        newItem2.title = "Destroy Demogorgon"
        //        toDoItems.append(newItem2)
        
        //        if let toDoItems = defaults.array(forKey: "ToDoListArray") as? [Item] {
        //            toDoItems = toDoItems
        //        }
        
        //        loadItems()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        if let colorHex = selectedCategory?.color {
            
            title = selectedCategory!.name
            
            guard let navBar = navigationController?.navigationBar else {fatalError("Navigation controller does not exist.")}
            
            if let navBarColor = UIColor(hexString: colorHex) {
                navBar.barTintColor = navBarColor
                navBar.backgroundColor = navBarColor
                navBar.tintColor = ContrastColorOf(navBarColor, returnFlat: true)
                
                navBar.largeTitleTextAttributes = [NSAttributedString.Key.foregroundColor: ContrastColorOf(navBarColor, returnFlat: true)]
                
                searchBar.barTintColor = UIColor(hexString: colorHex)
                
            }
            
            
        }
    }
    
    //MARK: - Tableview Datasource Methods
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return toDoItems?.count ?? 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = super.tableView(tableView, cellForRowAt: indexPath)
        
        if let item = toDoItems?[indexPath.row] {
            
            cell.textLabel?.text = item.title
            
            if let color = UIColor(hexString: selectedCategory!.color)?.darken(byPercentage: CGFloat(indexPath.row)/CGFloat(toDoItems!.count)) {
                cell.backgroundColor = color
                cell.textLabel?.textColor = ContrastColorOf(color, returnFlat: true)
            }
            
            cell.accessoryType = item.done ? .checkmark : .none
        } else {
            cell.textLabel?.text = "No Items Added"
        }
        
        return cell
    }
    
    //MARK: - Table View Delegate Methods
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if let item = toDoItems?[indexPath.row] {
            do {
                try realm.write {
                    item.done = !item.done
                    //                    realm.delete(item)
                }
            } catch {
                print("Error saving done status, \(error)")
            }
        }
        //        if let item = toDoItems?[indexPath.row] {
        //            do {
        //                try realm.write {
        //                    realm.delete(item)
        //                }
        //            } catch {
        //            print("Error saving done status, \(error)")
        //            }
        //        }
        
        tableView.reloadData()
        //        print(toDoItems[indexPath.row])
        
        //        todoItems?[indexPath.row].done = !toDoItems[indexPath.row].done
        
        //        saveItems()
        
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        var textField = UITextField()
        
        let alert = UIAlertController(title: "Add New Todey Item", message: "", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Add Item", style: .default) { (action) in
            //            print(textField.text)
            
            if let currentCategory = self.selectedCategory {
                do {
                    try self.realm.write {
                        let newItem = Item()
                        newItem.title = textField.text!
                        newItem.dateCreated = Date()
                        currentCategory.items.append(newItem)
                    }
                } catch {
                    print("Error saving new items, \(error)")
                }
            }
            self.tableView.reloadData()
            
            //            newItem.parentCategory = self.selectedCategory
            //
            //            self.toDoItems.append(newItem)
            //
            //            self.defaults.set(self.toDoItems, forKey: "TodoListArray")
            
            //            self.saveItems()
            
        }
        
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Create new item"
            textField = alertTextField
        }
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
        
    }
    
    //    func saveItems() {
    //        do {
    //            try context.save()
    //        } catch {
    //           print("Error saving context \(error)")
    //        }
    //
    //        tableView.reloadData()
    //    }
    
    func loadItems() {
        
        toDoItems = selectedCategory?.items.sorted(byKeyPath: "title", ascending: true)
        
        tableView.reloadData()
        //        let request: NSFetchRequest<Item> = Item.fetchRequest()
        
        //        let categoryPredicate = NSPredicate(format: "parentCategory.name MATCHES %@", selectedCategory!.name!)
        //
        //        if let additionalPredicate = predicate {
        //            request.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: [categoryPredicate, additionalPredicate])
        //        } else {
        //            request.predicate = categoryPredicate
        //        }
        //
        //
        //        do {
        //            toDoItems = try context.fetch(request)
        //        } catch {
        //            print("Error fetching data from context \(error)")
        //        }
        
    }
    
    //MARK: - Delete Data From Swipe
    
    override func updateModel(at indexPath: IndexPath) {
        if let item = self.toDoItems?[indexPath.row] {
            do {
                try self.realm.write {
                    self.realm.delete(item)
                }
            } catch {
                print("Error deleting item, \(error)")
            }
        }
        //        tableView.reloadData()
    }
}

//MARK: - Search bar methods

extension ToDoListViewController: UISearchBarDelegate {
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        if searchBar.text?.count == 0 {
            loadItems()
            DispatchQueue.main.async {
                searchBar.resignFirstResponder()
            }
        } else {
            toDoItems = toDoItems?.filter("title CONTAINS[cd] %@", searchBar.text!).sorted(byKeyPath: "dateCreated", ascending: false)
            
            tableView.reloadData()
            
            //            let request: NSFetchRequest<Item> = Item.fetchRequest()
            //
            //            let predicate = NSPredicate(format: "title CONTAINS[cd] %@", searchBar.text!)
            //
            //            request.sortDescriptors = [NSSortDescriptor(key: "title", ascending: true)]
            //
            //            loadItems(with: request, predicate: predicate)
        }
        
    }
}
