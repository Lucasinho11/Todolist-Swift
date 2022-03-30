//
//  AddTaskViewController.swift
//  TodoList
//
//  Created by Lucas Lubasinski on 17/02/2022.
//

import UIKit

class AddTaskViewController: UIViewController {

    @IBOutlet weak var taskTextField: UITextField!
    weak var delegate: ViewControllerDelegate2?
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    @IBAction func validate(_ sender: Any) {
        if let name = taskTextField.text {
            let list = Task(name: name)
            delegate?.didEditList(task: list)
            self.navigationController?.popViewController(animated: true)
        }
    }
    


}
