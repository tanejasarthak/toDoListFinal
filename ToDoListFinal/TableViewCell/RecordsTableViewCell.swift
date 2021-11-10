//
//  RecordsTableViewCell.swift
//  ToDoList
//
//  Created by Sarthak Taneja on 09/11/21.
//

import UIKit

protocol RecordsTableViewCellProtocol {
    func deleteRecord(for record: Records)
}

class RecordsTableViewCell: UITableViewCell {

    // MARK: - IBOutlets
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    
    var currentRecord: Records?
    var delegate: RecordsTableViewCellProtocol?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func configureView(data: Records?) {
        guard let data = data else {
            return
        }
        currentRecord = data
        dateLabel.text = convertDateToString(date: data.date ?? Date())
        titleLabel.text = data.title
    }
    
    @IBAction func deleteButtonTap() {
        guard let currentRecord = currentRecord else {
            return
        }
        delegate?.deleteRecord(for: currentRecord)
    }
}
