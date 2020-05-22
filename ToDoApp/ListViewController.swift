//
//  ListViewController.swift
//  ToDoApp
//
//  Created by Mac on 22/05/20.
//  Copyright © 2020 Akash. All rights reserved.
//

import UIKit
import CoreData

class ListViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    var listArray = [List]()
    
    var cat : Category? {
        didSet{
            loaddata()
        }
    }
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        listArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let list = listArray[indexPath.row]
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "listcell")
        cell?.textLabel?.text = (list.value(forKey: "item") as! String)
        cell?.accessoryType = list.done ? .checkmark : .none
        
        //        if list.done == true{
        //            cell?.accessoryType =
        //        } else{
        //            cell?.accessoryType = .none
        //        }
        return cell!
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        listArray[indexPath.row].done = !listArray[indexPath.row].done
        tableView.reloadData()
        savelist()
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete{
            context.delete(listArray[indexPath.row])
            listArray.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
            savelist()
        }
    }
    
    @IBOutlet weak var tableview: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    @IBAction func addBT(_ sender: UIBarButtonItem) {
        var textfield = UITextField()
        
        let alert = UIAlertController(title: "Add Item", message: nil, preferredStyle: .alert)
        
        let action = UIAlertAction(title: "save", style: .default) { (actions) in
            let newL = List(context: self.context)
            newL.item = textfield.text!
            newL.done = false
            newL.perentCategory = self.cat
            self.listArray.append(newL)
            self.savelist()
            
        }
        
        let cancel = UIAlertAction(title: "back", style: .cancel, handler: nil)
        
        alert.addAction(action)
        alert.addAction(cancel)
        
        alert.addTextField { (text) in
            textfield = text
        }
        
        present(alert, animated: true, completion: nil)
        
    }
    
    func savelist(){
        do {
            try context.save()
        }catch{
            print("saveList error")
        }
        tableview.reloadData()
    }
    
    
    func loaddata(with request: NSFetchRequest<List> = List.fetchRequest(), predicate:NSPredicate? = nil){
        let categoryPredicate = NSPredicate(format: "perentCategory.name MATCHES %@", cat!.name!)
        
        request.predicate = categoryPredicate
        
        do {
            listArray = try context.fetch(request)
        }catch{
            print("error")
        }
        // tableview.reloadData()
        
    }
}
