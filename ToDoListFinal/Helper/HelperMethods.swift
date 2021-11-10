//
//  HelperMethods.swift
//  ToDoList
//
//  Created by Sarthak Taneja on 09/11/21.
//

import Foundation

func convertDateToString(date: Date) -> String {
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "dd-MM-yyyy"
    
    return dateFormatter.string(from: date)
}

func convertStringToDate(dateString: String) -> Date? {
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "dd-MM-yyyy"
    
    return dateFormatter.date(from: dateString)
}
