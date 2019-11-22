//
//  Instructor+Convenience.swift
//  AnywhereFitness
//
//  Created by Niranjan Kumar on 11/19/19.
//  Copyright © 2019 NarJesse. All rights reserved.
//

import Foundation
import CoreData

extension Instructor {
    
    var instructorRepresentation: InstructorRepresentation? {
        guard let name = name,
            let email = email,
            let password = password,
            let id = id else { return nil }
        return InstructorRepresentation(name: name, email: email, password: password, id: id)
    }
    @discardableResult convenience init(name: String,
                                        email: String,
                                        password: String,
                                        id: UUID = UUID(),
                                        context: NSManagedObjectContext) {
        self.init(context: context)
        self.name = name
        self.email = email
        self.password = password
        self.id = id
    }
    
    @discardableResult convenience init?(instructorRepresentation: InstructorRepresentation, context: NSManagedObjectContext) {
        self.init(name: instructorRepresentation.name,
                  email: instructorRepresentation.email,
                  password: instructorRepresentation.password,
                  id: instructorRepresentation.id,
                  context: context)
    }
    
    @discardableResult convenience init(name: String,
                                        email: String,
                                        password: String,
                                        context: NSManagedObjectContext) {
        self.init(context: context)
        self.name = name
        self.email = email
        self.password = password
    }
}
