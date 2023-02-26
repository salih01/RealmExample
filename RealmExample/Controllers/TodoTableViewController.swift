//
//  TodoTableViewController.swift
//  RealmExample
//
//  Created by Salih on 19.02.2023.
//

import UIKit
import CoreData

// MARK: - Core Data
let appDelegate = UIApplication.shared.delegate as! AppDelegate
let context = appDelegate.persistentContainer.viewContext


class TodoTableViewController: UITableViewController ,UISearchBarDelegate{
    
    var itemArray:[Item] = []
    let userDefaults = UserDefaults.standard

    override func viewDidLoad() {
        super.viewDidLoad()
     

        print(FileManager.default.urls(for: .documentDirectory, in: .userDomainMask))
        
        newItem()
        if let items = userDefaults.array(forKey: "list") as? [Item] {
            itemArray = items
        }
        let request : NSFetchRequest<Item> = Item.fetchRequest()
        loadItems(request: request)
        
    }
    
    // MARK: - Function
    
    func makeAlert(title:String,message:String){
        var textField = UITextField()
        
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okButton = UIAlertAction(title: "Ok", style: .default)
        
        let action = UIAlertAction(title: "Add", style: .default) {(action) in
            

            let newItem = Item(context: context)
            
            newItem.title = textField.text!
            
            self.itemArray.append(newItem)
            self.saveItems()
         
            
        }
        alert.addAction(action)
        alert.addTextField { (alertTextField) in
            
            alertTextField.placeholder = "Yeni şehir ekle"
            textField = alertTextField
        }
        self.present(alert, animated: true)
    }
    
    func newItem(){
        
        let newItem = Item(context: context)
        newItem.title = "Adana"
        newItem.done = false
        itemArray.append(newItem)
        
    }
    // MARK: - saveItems
    func saveItems(){

        do{
           
            try context.save()
        }catch {
            print("Error encoding item array : \(error)")
        }
        
        tableView.reloadData()
    }
    // MARK: - loadItems
    func loadItems(request:NSFetchRequest<Item> = Item.fetchRequest()){
       
        do{
           itemArray = try context.fetch(request)
        } catch{
            print("loadItemsError : \(error.localizedDescription)")
        }
        tableView.reloadData()
    }
    // MARK: - SerchBar
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        let request :NSFetchRequest<Item> = Item.fetchRequest()
        let predicate = NSPredicate(format: "title CONTAINS[cd] %@", searchBar.text!)
      
        request.sortDescriptors = [NSSortDescriptor(key: "title", ascending: true)]
 
        loadItems(request: request)
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
       if searchBar.text?.count == 0 {
            loadItems()
           DispatchQueue.main.async {
               searchBar.resignFirstResponder()
           }
        }
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
        cell.accessoryType = item.done == true ? .checkmark : .none
        return cell
        
    }
    
    // MARK: - TableView Delegate Methods
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        //context.delete(itemArray[indexPath.row])
        //itemArray.remove(at: indexPath.row)

        
        itemArray[indexPath.row].done = !itemArray[indexPath.row].done
    
        print("didSelect")
        self.saveItems()
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
  
    
    
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        
        makeAlert(title: "Şehir", message: "Yeni Şehir Ekle")
        
    }
    
    
    
}
