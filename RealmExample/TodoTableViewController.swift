//
//  TodoTableViewController.swift
//  RealmExample
//
//  Created by Salih on 19.02.2023.
//

import UIKit

class TodoTableViewController: UITableViewController {
    
    var itemArray = [String]()
    let userDefaults = UserDefaults.standard

    override func viewDidLoad() {
        super.viewDidLoad()

        if let items = userDefaults.array(forKey: "list") as? [String] {
            
            itemArray = items
        }
    }

    // MARK: - Table view data source

   

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return itemArray.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = itemArray[indexPath.row]
        
        return cell
        
    }
    
    // MARK: - TableView Delegate Methods
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        
        if tableView.cellForRow(at: indexPath)?.accessoryType == .checkmark {
            tableView.cellForRow(at: indexPath)?.accessoryType = .none
        } else {
            tableView.cellForRow(at: indexPath)?.accessoryType = .checkmark

        }
    }
    
    // MARK: - Function
    
    func makeAlert(title:String,message:String){
        var textField = UITextField()
        
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okButton = UIAlertAction(title: "Ok", style: .default)
        
        let action = UIAlertAction(title: "Add", style: .default) {(action) in
            self.itemArray.append(textField.text!)
            self.userDefaults.set(self.itemArray, forKey: "list")
            self.tableView.reloadData()
            
        }
        alert.addAction(action)
        
        alert.addTextField { (alertTextField) in
            
            alertTextField.placeholder = "Yeni şehir ekle"
            textField = alertTextField
        }
        self.present(alert, animated: true)
    }
    

    
    
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        
        makeAlert(title: "Şehir", message: "Yeni Şehir Ekle")
        
    }
    
    
    
}
