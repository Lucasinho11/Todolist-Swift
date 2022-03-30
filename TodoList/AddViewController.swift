//
//  AddViewController.swift
//  TodoList
//
//  Created by Lucas Lubasinski on 17/02/2022.
//

import UIKit

class AddViewController: UIViewController {
    @IBOutlet weak var nameTextField: UITextField!
    weak var delegate: ViewControllerDelegate?
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func validate(_ sender: Any) {
        if let name = nameTextField.text {
            let list = List(name: name)
            delegate?.didCreateList(list: list)
            self.navigationController?.popViewController(animated: true)
        }
    }
    }
