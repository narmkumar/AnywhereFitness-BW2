//
//  ClientController.swift
//  AnywhereFitness
//
//  Created by Niranjan Kumar on 11/21/19.
//  Copyright © 2019 NarJesse. All rights reserved.
//

import Foundation
import CoreData

class ClientController {
    
    var clientClassesAdded: [Class] = []
    
    func clientAddClass(classes: Class, context : NSManagedObjectContext) {
        clientClassesAdded.append(classes)
        CoreDataStack.shared.save(context: context)
    }
    
    func clientDeleteClass(classes: Class, context : NSManagedObjectContext) {
        guard let specificClass = clientClassesAdded.firstIndex(of: classes) else { return }
        clientClassesAdded.remove(at: specificClass)
        CoreDataStack.shared.save(context: context)
    }
    
}
