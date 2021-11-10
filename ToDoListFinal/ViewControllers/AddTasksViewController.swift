//
//  AddTasksViewController.swift
//  ToDoList
//
//  Created by Sarthak Taneja on 09/11/21.
//

import UIKit

protocol AddTasksVCProtocol {
    func reloadTableViewCell()
}

class AddTasksViewController: UIViewController {
    
    // MARK: - IBOutlets
    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var dateTextField: UITextField!
    @IBOutlet weak var backgroundView: UIView!
    
    // Public Properties
    var currentDate: Date?
    var delegate: AddTasksVCProtocol?
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        setupView()
    }
    
    func setupView() {
        backgroundView.layer.borderWidth = 2
        backgroundView.layer.borderColor = UIColor.black.cgColor
        
        if let currentDate = currentDate {
            dateTextField.text = convertDateToString(date: currentDate)
            dateTextField.isUserInteractionEnabled = false
        }
    }
    
    // MARK: - IBActions
    
    @IBAction func closeBtnTapped() {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func doneBtnTapped() {
        let newRecord = Records(context: context)
        newRecord.date = convertStringToDate(dateString: dateTextField.text ?? "")
        newRecord.title = titleTextField.text ?? ""
        
        do {
            try context.save()
            delegate?.reloadTableViewCell()
            self.dismiss(animated: true, completion: nil)
        } catch(let error) {
            debugPrint(error)
        }
    }
}
