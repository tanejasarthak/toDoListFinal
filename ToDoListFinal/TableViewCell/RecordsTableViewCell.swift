//
//  RecordsTableViewCell.swift
//  ToDoList
//
//  Created by Sarthak Taneja on 09/11/21.
//

import UIKit

class RecordsTableViewCell: UITableViewCell {

    // MARK: - IBOutlets
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    
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
        dateLabel.text = convertDateToString(date: data.date ?? Date())
        titleLabel.text = data.title
    }
}
