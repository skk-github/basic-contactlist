//
//  Contact+CoreDataProperties.swift
//  BasicContactLIst
//
//  Created by Krishna on 26/05/23.
//
//

import Foundation
import CoreData


extension Contact {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Contact> {
        return NSFetchRequest<Contact>(entityName: "Contact")
    }

    @NSManaged public var name: String?
    @NSManaged public var primaryNumber: Int64
    @NSManaged public var secondaryNumber: Int64
    @NSManaged public var email: String?
    @NSManaged public var id: UUID

}

extension Contact : Identifiable {

}
