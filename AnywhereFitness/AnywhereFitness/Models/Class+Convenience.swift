//
//  Class+Convenience.swift
//  AnywhereFitness
//
//  Created by Niranjan Kumar on 11/19/19.
//  Copyright © 2019 NarJesse. All rights reserved.
//

import Foundation
import CoreData

extension Class {
    
    var classRepresentation: ClassRepresentation? {
        
        guard let name = name,
            let instructorName = instructorName,
            let type = type,
            let duration = duration,
            let intensityLevel = intensityLevel,
            let location = location,
//            let masClassSize = masClassSize,
            let classDetail = classDetail,
            let date = date,

            let id = id else { return nil }
        return ClassRepresentation(name: name, instructorName: instructorName, type: type, duration: duration, intensityLevel: intensityLevel, location: location, maxClassSize: Int16(), classDetail: classDetail, date: date, isAttending: isAttending, id: id)
    }
    
    @discardableResult convenience init(name: String,
                                        instructorName: String,
                                        type: String,
                                        duration: String,
                                        intensityLevel: String,
                                        location: String,
                                        maxClassSize: Int16,
                                        classDetail: String,
                                        date: Date = Date.init(timeIntervalSinceNow: 0),
                                        isAttending: Bool = false,
                                        id: UUID = UUID(),
                                        context: NSManagedObjectContext) {
        self.init(context: context)
        
        self.name = name
        self.instructorName = instructorName
        self.type = type
        self.duration = duration
        self.intensityLevel = intensityLevel
        self.location = location
        self.maxClassSize = maxClassSize
        self.classDetail = classDetail
        self.date = date
        self.isAttending = isAttending
        self.id = id
    }
    
    @discardableResult convenience init?(classRepresentation: ClassRepresentation, context: NSManagedObjectContext) {
        self.init(name: classRepresentation.name,
                  instructorName: classRepresentation.instructorName,
                  type: classRepresentation.type,
                  duration: classRepresentation.duration,
                  intensityLevel: classRepresentation.intensityLevel,
                  location: classRepresentation.location,
                  maxClassSize: classRepresentation.maxClassSize,
                  classDetail: classRepresentation.classDetail,
                  date: classRepresentation.date,
                  isAttending: classRepresentation.isAttending ?? false,
                  id: classRepresentation.id,
                  context: context)
    }
}
