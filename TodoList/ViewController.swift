//
//  ViewController.swift
//  TodoList
//
//  Created by Lucas Lubasinski on 17/02/2022.
//

import UIKit

protocol ViewControllerDelegate: NSObject {
    func didCreateList(list: List)
    func didDeleteList(list: List)
}

class ViewController: UIViewController, UITableViewDelegate, ViewControllerDelegate, UITableViewDataSource {
    
    @IBOutlet weak var tableView: UITableView!
    var lists: [List] = []
    var selectedList: List?
    
    

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "addSegue" {
            let controller = segue.destination as! AddViewController
            controller.delegate = self
        }
    }
    func documentsDirectory() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return paths[0]
    }
    
    func dataFilePath() -> URL {
        return documentsDirectory().appendingPathComponent("Lists.plist")
    }
    
    func saveLists() {
        let encoder = PropertyListEncoder()
        do {
            let data = try encoder.encode(lists)
            try data.write(to: dataFilePath(), options: Data.WritingOptions.atomic)
        } catch {
            print("Error encoding lists: \(error.localizedDescription)")
        }
    }
    
    func loadLists() {
        let path = dataFilePath()
        if let data = try? Data(contentsOf: path) {
            let decoder = PropertyListDecoder()
            do {
                lists = try decoder.decode([List].self, from: data)
            } catch {
                print("Error decoding plist: \(error.localizedDescription)")
            }
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return lists.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "listCell", for: indexPath)
        let list = lists[indexPath.row]
        cell.textLabel?.text = list.name
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            lists.remove(at: indexPath.row)
            saveLists()
            tableView.deleteRows(at: [indexPath], with: .automatic)
        }
    }
    
    func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath? {
        self.selectedList = lists[indexPath.row]
        return indexPath
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func didCreateList(list: List) {
        lists.append(list)
        saveLists()
        tableView.reloadData()
        // reload table view
    }
    
    func didDeleteList(list: List) {
        if let index = lists.firstIndex(of:list) {
            lists.remove(at: index)
            saveLists()
            tableView.reloadData()
        }
        
    }
   
    
}

