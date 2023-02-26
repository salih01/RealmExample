//
//  CategoryTableViewController.swift
//  RealmExample
//
//  Created by Salih on 26.02.2023.
//

import UIKit
import CoreData



class CategoryTableViewController: UITableViewController {
    
    var categories = [Category]()
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    
    override func viewDidLoad() {
        
        super.viewDidLoad()

        loadCategory()
        
    }
    
    // MARK: - Save and Load
    
    func saveCategory(){
        
        do {
            try context.save()
        } catch{
            print("saveCategory ERROR !: \(error.localizedDescription)")
        }
        tableView.reloadData()
    }
    
    func loadCategory(){
        
        let request:NSFetchRequest<Category> = Category.fetchRequest()
        
        do{
            categories =  try context.fetch(request)
        }catch{
            print("loadCategory ERROR !: \(error.localizedDescription)")
        }
        tableView.reloadData()
    }

    

    // MARK: -  TableView Data Source
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categories.count
    }
    
  
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "categoryCell", for: indexPath)
        cell.textLabel?.text = categories[indexPath.row].name
        
        return cell
        
    }
    
    // MARK: - TableView Delegate
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        performSegue(withIdentifier: "goToItems", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationVc = segue.destination as! TodoTableViewController
        if let indexPath = tableView.indexPathForSelectedRow {
            destinationVc.selectedCategory = categories[indexPath.row]
        }
    }
    
    func makeAlert(title:String,message:String){
        
        var textField = UITextField()
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let action = UIAlertAction(title: "Add", style: .default) {(action) in
            

            let newCategory = Category(context: self.context)
            newCategory.name = textField.text!
            self.categories.append(newCategory)
            self.saveCategory()
            
        }
        alert.addTextField { (alertTextField) in
            
            alertTextField.placeholder = "Yeni şehir ekle"
            textField = alertTextField
        }
        alert.addAction(action)
        self.present(alert, animated: true)
    }
    
  
    @IBAction func addButton(_ sender: UIBarButtonItem) {
        
        makeAlert(title: "Category", message: "Ne eklemek istersin ")
    }
    
    
    
    
}
