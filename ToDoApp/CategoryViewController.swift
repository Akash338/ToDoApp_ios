//
//  CategoryViewController.swift
//  ToDoApp
//
//  Created by Mac on 22/05/20.
//  Copyright © 2020 Akash. All rights reserved.
//

import UIKit
import CoreData

class CategoryViewController: UIViewController, UITableViewDelegate,UITableViewDataSource{
    
    var catagories = [Category]()
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        catagories.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell")
        cell?.textLabel?.text = catagories[indexPath.row].name
        return cell!
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let index = tableView.indexPathForSelectedRow {
            let vc = storyboard?.instantiateViewController(identifier: "ListViewController") as! ListViewController
            vc.cat = catagories[index.row]
            tableView.deselectRow(at: indexPath, animated: true)
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete{
            context.delete(catagories[indexPath.row])
            catagories.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
            save()
        }
    }
    
    @IBOutlet weak var tableview: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        featch()
    }
    
    @IBAction func addbutton(_ sender: UIBarButtonItem) {
        var textfield = UITextField()
        
        let alert = UIAlertController(title: "Add Category", message: nil, preferredStyle: .alert)
        let action = UIAlertAction(title: "Save", style: .default) { (actions) in
            let new = Category(context: self.context)
            new.name = textfield.text!
            
            self.catagories.append(new)
            self.save()
            
        }
        let cancel = UIAlertAction(title: "back", style: .cancel, handler: nil)
        
        alert.addAction(cancel)
        alert.addAction(action)
        
        alert.addTextField { (text) in
            textfield = text
        }
        
        present(alert, animated: true, completion: nil)
        
    }
    
    func save(){
        do{
            try context.save()
        }catch{
            print("saving error in cat")
        }
        tableview.reloadData()
    }
    
    func featch(){
        let request:NSFetchRequest<Category> = Category.fetchRequest()
        
        do{
            catagories = try context.fetch(request)
        }catch{
            print("featch error")
        }
        tableview.reloadData()
    }
    
}
