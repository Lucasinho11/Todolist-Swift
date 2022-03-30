//
//  ListViewController.swift
//  TodoList
//
//  Created by Lucas Lubasinski on 17/02/2022.
//

import UIKit
protocol ViewControllerDelegate2: NSObject {
    func didEditList(task: Task)
    func didDeleteList(task: Task)
}

class ListViewController: UIViewController, UITableViewDelegate, ViewControllerDelegate2, UITableViewDataSource {

    

    

    
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var LabelTask: UILabel!
    
    var tasks: [List] = []
    var task2: [Task] = []
    var selectedList: List?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        if let todoName = selectedList?.name {
            LabelTask.text = todoName
        }
    }

    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "addTaskSegue" {
            let controller = segue.destination as! AddTaskViewController
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
            let data = try encoder.encode(task2)
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
                task2 = try decoder.decode([Task].self, from: data)
            } catch {
                print("Error decoding plist: \(error.localizedDescription)")
            }
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return task2.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "taskCell", for: indexPath)
        let task = task2[indexPath.row]
        cell.textLabel?.text = task.name
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            task2.remove(at: indexPath.row)
            saveLists()
            tableView.deleteRows(at: [indexPath], with: .automatic)
        }
    }
    

    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func didEditList(task: Task) {
        task2.append(task)
        saveLists()
        tableView.reloadData()
        // reload table view
    }
    
    func didDeleteList(task: Task) {
        if let index = task2.firstIndex(of:task) {
            task2.remove(at: index)
            saveLists()
            tableView.reloadData()
        }
        
    }

}
