//
//  CDUser+CoreDataProperties.swift
//  Smart Study Planner
//
//  Created by Nisila on 2025-04-22.
//
//

import Foundation
import CoreData


extension CDUser {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<CDUser> {
        return NSFetchRequest<CDUser>(entityName: "CDUser")
    }

    @NSManaged public var id: String?
    @NSManaged public var email: String?
    @NSManaged public var password: String?
    @NSManaged public var name: String?
    @NSManaged public var notificationEnabled: Bool
    @NSManaged public var theme: String?
    @NSManaged public var defaultStudyDuration: Double

}

extension CDUser : Identifiable {

}
