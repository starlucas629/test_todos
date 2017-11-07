//
//  MainVC.swift
//  Todo-App
//
//  Created by kerberos-mac on 9/16/17.
//  Copyright © 2017 kerberos-mac. All rights reserved.
//

import UIKit

class MainViewController: UIViewController {
    
    @IBOutlet weak var viewTitle: UIView!
    @IBOutlet weak var searchbar: UISearchBar!
    @IBOutlet weak var tableview: UITableView!
    
    var dbinfo = DBInfo.shared
    var todoinfos = [todoinfo]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        searchbar.returnKeyType = .done
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if dbinfo.isCreate {
            initialSearchBar()
        }
        
        chooseTodos()
    }
    
    func initialSearchBar() {
        searchbar.text = ""
        searchbar.resignFirstResponder()
    }
    
    func chooseTodos() {
        todoinfos = []
        let allTodos = dbinfo.realm.objects(todoinfo.self)
        
        for data in allTodos {
            if searchbar.text!.characters.count > 0 {
                let stringTitle = data.title.lowercased() as NSString
                if stringTitle.range(of: searchbar.text!.lowercased()).location != NSNotFound {
                    todoinfos.append(data)
                }
            } else {
                todoinfos.append(data)
            }
        }
        
        sortTodos()
        tableview.reloadData()
    }
    
    func sortTodos() {
        todoinfos = todoinfos.sorted(by: {
            $0.title < $1.title
        })
    }
    
    
    @IBAction func OnPressAdd(_ sender: UIButton) {
        dbinfo.isCreate = true
        
        let addVC = self.storyboard?.instantiateViewController(withIdentifier: "AddVC") as? AddViewController
        self.navigationController?.pushViewController(addVC!, animated: true)
    }
    

}

extension MainViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return todoinfos.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MainTableCell") as? MainTableCell
        cell?.setProperties(todoData: todoinfos[indexPath.row])
        cell?.delegate = self
        

        return cell!
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableview.deselectRow(at: indexPath, animated: true)
        searchbar.resignFirstResponder()
        
        dbinfo.isCreate = false
        let dbId = todoinfos[indexPath.row].dbId
        if let obj = dbinfo.realm.objects(todoinfo.self).filter("dbId = %@", dbId!).first {
            dbinfo.selecetedObj = obj
            let addVC = self.storyboard?.instantiateViewController(withIdentifier: "AddVC") as? AddViewController
            self.navigationController?.pushViewController(addVC!, animated: true)
        }
    }
}

extension MainViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        chooseTodos()
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchbar.resignFirstResponder()
    }
}


extension MainViewController: DeleteCellDelegate {
    func deleteCell(dbIndex: String) {
        
        let alert = UIAlertController(title: "DELETE", message: "Are you sure?", preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: { action in

            self.deleteData(dbIndex: dbIndex)
        }))

        alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.cancel, handler: nil))
        self.present(alert, animated: true, completion: nil)
        
        
    }
    
    func deleteData(dbIndex: String) {
        
        if let obj = dbinfo.realm.objects(todoinfo.self).filter("dbId = %@", dbIndex).first {
            try! dbinfo.realm.write {
                dbinfo.realm.delete(obj)
            }
            
            chooseTodos()
        }
        
    }

}

