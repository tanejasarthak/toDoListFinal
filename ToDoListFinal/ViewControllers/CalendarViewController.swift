//
//  CalendarViewController.swift
//  ToDoList
//
//  Created by Sarthak Taneja on 09/11/21.
//

import UIKit
import FSCalendar

class CalendarViewController: UIViewController {

    // MARK: - IBOutlets
    @IBOutlet weak var calendar: FSCalendar!
    @IBOutlet weak var hideShowLabel: UILabel!
    @IBOutlet weak var hideShowCalView: UIView!
    @IBOutlet weak var tableView: UITableView!
    
    // Public Properties
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    var items: [Records]?
    var currentMonthItems: [Records]?
    var itemsDict: Dictionary<Date?, Records>?
    
    var isCalHidden: Bool? {
        didSet {
            calendar.isHidden = isCalHidden ?? true
            hideShowLabel.text = isCalHidden ?? true ? "Show Calendar" : "Hide Calendar"
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
     //   isCalHidden = true
        let gestureRecogniser = UITapGestureRecognizer(target: self, action: #selector(hideShowCalendar))
        hideShowCalView.addGestureRecognizer(gestureRecogniser)
        configureTableViewCell()
        fetchRecords()
    }
    
    func fetchRecords() {
        do {
            items = try context.fetch(Records.fetchRequest())
            getCurrentMonthRecords()
            reloadTableView()
        } catch(let error) {
            debugPrint(error.localizedDescription)
        }
    }
    
    func getCurrentMonthRecords() {
        let currentPageDate = calendar.currentPage
        let month = Calendar.current.component(.month, from: currentPageDate)
        
        currentMonthItems = items?.filter({ record in
            return record.date?.get(.month) == month
        })
        if let currentMonthItems = currentMonthItems {
            itemsDict = Dictionary(uniqueKeysWithValues: currentMonthItems.map{ ($0.date, $0) })
        }
        reloadTableView()
    }
    
    func reloadTableView() {
        DispatchQueue.main.async {
            self.tableView.reloadData()
            self.calendar.reloadData()
        }
    }
    
    func configureTableViewCell() {
        tableView.register(UINib(nibName: "RecordsTableViewCell", bundle: nil), forCellReuseIdentifier: "RecordsTableViewCell")
    }
    
    @objc func hideShowCalendar() {
        isCalHidden = !(isCalHidden ?? true)
    }
    
    func pushToAddTasksVC(for date: Date?) {
        let addTasksVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "AddTasksViewController") as! AddTasksViewController
        addTasksVC.currentDate = date
        addTasksVC.delegate = self
        self.present(addTasksVC, animated: true, completion: nil)
    }
    
    @IBAction func addTasksTapped() {
        pushToAddTasksVC(for: nil)
    }
}

// MARK: - FSCalendar Delegate
extension CalendarViewController: FSCalendarDelegate, FSCalendarDataSource {
    func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) {
        if date < Date() {
            return
        }
        pushToAddTasksVC(for: date)
    }
    
    // Created with help from: https://github.com/WenchaoD/FSCalendar/issues/943#issuecomment-634757095
    func calendar(_ calendar: FSCalendar, willDisplay cell: FSCalendarCell, for date: Date, at monthPosition: FSCalendarMonthPosition) {
        let toDoTextLabel = UILabel(frame: CGRect(x: 10, y: 50, width: cell.bounds.width, height: 20))
        toDoTextLabel.font = UIFont(name: "Henderson BCG Sans", size: 10)
        toDoTextLabel.layer.cornerRadius = cell.bounds.width/2
        toDoTextLabel.textColor = UIColor.black
        toDoTextLabel.removeFromSuperview()
        if let data = itemsDict?[date] {
            debugPrint(data)
            toDoTextLabel.text = data.title
            cell.addSubview(toDoTextLabel)
            itemsDict?.removeValue(forKey: date)
        }
        
    }
    
    func calendarCurrentPageDidChange(_ calendar: FSCalendar) {
       getCurrentMonthRecords()
    }
}

// MARK: - UITableViewDelegate and Datasource
extension CalendarViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "RecordsTableViewCell", for: indexPath) as! RecordsTableViewCell
        cell.delegate = self
        cell.configureView(data: currentMonthItems?[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return currentMonthItems?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}

// MARK: - AddTasksVC Delegate
extension CalendarViewController: AddTasksVCProtocol {
    func reloadTableViewCell() {
        fetchRecords()
    }
}

// MARK: - RecordsTableViewCell Delegate
extension CalendarViewController: RecordsTableViewCellProtocol {
    func deleteRecord(for record: Records) {
        context.delete(record)
        do {
            try context.save()
            fetchRecords()
        } catch(let error) {
            debugPrint(error.localizedDescription)
        }
    }
}
