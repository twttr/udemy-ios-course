//
//  ViewController.swift
//  Todoey
//
//  Created by Philipp Muellauer on 02/12/2019.
//  Copyright © 2019 App Brewery. All rights reserved.
//

import UIKit
import RealmSwift
import ChameleonFramework

class TodoListViewController: SwipeTableViewController {
    @IBOutlet weak var searchBer: UISearchBar!
    
    var todoItems: Results<Item>?
    let realm = try! Realm()
    var selectedCategory: Category? {
        didSet {
            loadData()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.backgroundColor = UIColor(hexString: selectedCategory!.color)
        navigationItem.title = selectedCategory?.name
        searchBer.barTintColor = UIColor(hexString: selectedCategory!.color)
        navigationController?.navigationBar.tintColor = ContrastColorOf(UIColor(hexString: selectedCategory!.color)!, returnFlat: true)
        navigationController?.navigationBar.largeTitleTextAttributes = [NSAttributedString.Key.foregroundColor: ContrastColorOf(UIColor(hexString: selectedCategory!.color)!, returnFlat: true)]
    }

    //MARK: - Datasource
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return todoItems?.count ?? 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = super.tableView(tableView, cellForRowAt: indexPath)
        let currentCellValue = todoItems?[indexPath.row]
        cell.textLabel?.text = currentCellValue?.title ?? "No items"
        cell.backgroundColor = UIColor(hexString: selectedCategory!.color)!.darken(byPercentage: CGFloat(indexPath.row) / CGFloat(todoItems!.count))
        cell.textLabel?.textColor = ContrastColorOf(cell.backgroundColor!, returnFlat: true)
        cell.accessoryType = currentCellValue?.checked ?? false ? .checkmark : UITableViewCell.AccessoryType.none
        return cell
    }
    
    //MARK: - Delegate
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
                
        if let item = todoItems?[indexPath.row] {
            do {
                try realm.write {
                    item.checked = !item.checked
                }
            } catch {
                print(error)
            }
        }
        tableView.reloadData()
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    //MARK: - Add New Items
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        var textField = UITextField()
        
        let alert = UIAlertController(title: "Add New", message: "", preferredStyle: .alert)
        
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "New Item"
            textField = alertTextField
        }
        
        let action = UIAlertAction(title: "Add", style: .default) { (action) in
            
            let newItem = Item()
            newItem.title = textField.text!
            newItem.dateCreated = Date()
            
            self.saveData(item: newItem)
        }
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
    }
    
    //MARK: - Model Manipulation
    
    func saveData(item: Item) {
        do {
            try realm.write{
                self.selectedCategory?.items.append(item)
                realm.add(item)
            }
        } catch {
            print(error)
        }
        
        tableView.reloadData()
    }
    
    func loadData() {
        todoItems = selectedCategory?.items.sorted(byKeyPath: "title", ascending: true)

        tableView.reloadData()
    }
    
    override func updateModel(at indexPath: IndexPath) {
        if let selectedItem = self.todoItems?[indexPath.row] {
            do {
                try self.realm.write{
                    self.realm.delete(selectedItem)
                }
            } catch {
                print(error)
            }
            
        }
    }
}

extension TodoListViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        todoItems = todoItems?.filter(NSPredicate(format: "title CONTAINS[cd] %@", searchBar.text!)).sorted(byKeyPath: "dateCreated", ascending: true)
        tableView.reloadData()
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchBar.text?.count == 0 {
            loadData()
            DispatchQueue.main.async {
                searchBar.resignFirstResponder()
            }
        }
    }
}

