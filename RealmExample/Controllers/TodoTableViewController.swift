//
//  TodoTableViewController.swift
//  RealmExample
//
//  Created by Salih on 19.02.2023.
//

import UIKit

class TodoTableViewController: UITableViewController {
    
    var itemArray:[Item] = []
    let userDefaults = UserDefaults.standard
    let dataFilePath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathExtension("Items.plist")
    

    override func viewDidLoad() {
        super.viewDidLoad()
     

        newItem()
        if let items = userDefaults.array(forKey: "list") as? [Item] {
            itemArray = items
        }
        
    }
    
    // MARK: - Function
    
    func makeAlert(title:String,message:String){
        var textField = UITextField()
        
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okButton = UIAlertAction(title: "Ok", style: .default)
        
        let action = UIAlertAction(title: "Add", style: .default) {(action) in
            
            let newItem = Item()
            newItem.title = textField.text!
            
            self.itemArray.append(newItem)
            self.saveItems()
            //self.userDefaults.set(self.itemArray, forKey: "list")
         
            
        }
        alert.addAction(action)
        alert.addTextField { (alertTextField) in
            
            alertTextField.placeholder = "Yeni şehir ekle"
            textField = alertTextField
        }
        self.present(alert, animated: true)
    }
    
    func newItem(){
        
        let newItem = Item()
        newItem.title = "Adana"
        newItem.checkMark = false
        itemArray.append(newItem)
        
    }
    
    func saveItems(){
        
        //MARK: -  ENCODER
        
        let encoder = PropertyListEncoder()
        do{
            let data = try encoder.encode(itemArray)
            try data.write(to: dataFilePath!)
        }catch {
            print("Error encoding item array : \(error)")
        }
        
        tableView.reloadData()
    }
  


    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return itemArray.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let item = itemArray[indexPath.row]
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = item.title
        cell.accessoryType = item.checkMark == true ? .checkmark : .none
        return cell
        
    }
    
    // MARK: - TableView Delegate Methods
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        itemArray[indexPath.row].checkMark = !itemArray[indexPath.row].checkMark
        
        tableView.reloadData()
        print("didSelect")
        self.saveItems()
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
  
    
    
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        
        makeAlert(title: "Şehir", message: "Yeni Şehir Ekle")
        
    }
    
    
    
}
