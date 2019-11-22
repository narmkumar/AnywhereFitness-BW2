//
//  Client+Convenience.swift
//  AnywhereFitness
//
//  Created by Niranjan Kumar on 11/19/19.
//  Copyright © 2019 NarJesse. All rights reserved.
//

import Foundation
import CoreData

extension Client {
    var clientRepresentation: ClientRepresentation? {
        guard let email = email,
            let password = password else { return nil }
        return ClientRepresentation(email: email, password: password)
    }
    @discardableResult convenience init(email: String,
                                        password: String,
                                        context: NSManagedObjectContext) {
        self.init(context: context)
        self.email = email
        self.password = password
    }
    @discardableResult convenience init?(clientRepresentation: ClientRepresentation, context: NSManagedObjectContext) {
        
        self.init(email: clientRepresentation.email,
                  password: clientRepresentation.password,
                  context: context)
    }
}

