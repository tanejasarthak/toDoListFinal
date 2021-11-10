//
//  Records+CoreDataProperties.swift
//  ToDoListFinal
//
//  Created by Sarthak Taneja on 10/11/21.
//
//

import Foundation
import CoreData


extension Records {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Records> {
        return NSFetchRequest<Records>(entityName: "Records")
    }

    @NSManaged public var date: Date?
    @NSManaged public var title: String?

}

extension Records : Identifiable {

}
