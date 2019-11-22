//
//  ClassController.swift
//  AnywhereFitness
//
//  Created by Jesse Ruiz on 11/19/19.
//  Copyright © 2019 NarJesse. All rights reserved.
//

import UIKit
import CoreData

enum HTTPMethod: String {
    case get = "GET"
    case put = "PUT"
    case post = "POST"
    case delete = "DELETE"
}

class ClassController {
    
    let baseURL = URL(string: "https://anywhere-fitness-ffa28.firebaseio.com/")!
    
    init() {
        fetchClassesFromServer()
    }
    
    func fetchClassesFromServer(completion: @escaping () -> Void = { }) {
        
        let requestURL = baseURL.appendingPathExtension("json")
        
        let request = URLRequest(url: requestURL)
        
        URLSession.shared.dataTask(with: request) { (data, _, error) in
            
            if let error = error {
                NSLog("Error fetching classes: \(error)")
                completion()
                return
            }
            
            guard let data = data else {
                NSLog("No data return from class fetch data task")
                completion()
                return
            }
            
            let decoder = JSONDecoder()
            
            do {
                try decoder.decode([String: ClassRepresentation].self, from: data).map({ $0.value })
//                try self.updateClasses(with: classes)
            } catch {
                NSLog("Error decoding ClassRepresentations: \(error)")
            }
            completion()
        }.resume()
    }
    
    func updateClasses(with representations: [ClassRepresentation]) {

        let identifiersToFetch = representations.map({ $0.id })

        let representationsByID = Dictionary(uniqueKeysWithValues: zip(identifiersToFetch, representations))

        var classesToCreate = representationsByID

        let context = CoreDataStack.shared.container.newBackgroundContext()
        
        let fetchRequest: NSFetchRequest<Class> = Class.fetchRequest()
        
        fetchRequest.predicate = NSPredicate(format: "identifier IN %@", identifiersToFetch)

        context.perform {

            do {

                let existingClasses = try context.fetch(fetchRequest)
                for classes in existingClasses {

                    guard let identifier = classes.id,
                    let representation = representationsByID[identifier] else { continue }

                    classes.name = representation.name
                    classes.instructorName = representation.instructorName
                    classes.type = representation.type
                    classes.duration = representation.duration
                    classes.intensityLevel = representation.intensityLevel
                    classes.location = representation.location
                    classes.maxClassSize = Int16(representation.maxClassSize)
                    classes.classDetail = representation.classDetail
                    classes.date = representation.date
                    classes.isAttending = representation.isAttending!

                    classesToCreate.removeValue(forKey: identifier)
                }

                for representation in classesToCreate.values {
                    Class(classRepresentation: representation, context: context)
                }

                CoreDataStack.shared.save(context: context)

            } catch {
                NSLog("Error fetching classes from persistent store: \(error)")
            }
        }
    }
    
    func put(classes: Class, completion: @escaping () -> Void = { }) {
        
        let identifier = classes.id ?? UUID()
        classes.id = identifier
        
        let requestURL = baseURL
            .appendingPathComponent(identifier.uuidString)
            .appendingPathExtension("json")
        
        var request = URLRequest(url: requestURL)
        request.httpMethod = HTTPMethod.put.rawValue
        
        guard let classRepresentation = classes.classRepresentation else {
            NSLog("Class Representation is nil")
            completion()
            return
        }
        
        do {
            request.httpBody = try JSONEncoder().encode(classRepresentation)
        } catch {
            NSLog("Error encoding class representation: \(error)")
            completion()
            return
        }
        
        URLSession.shared.dataTask(with: request) { (_, _, error) in
            if let error = error {
                NSLog("Error PUTing class to server: \(error)")
                completion()
                return
            }
            completion()
        }.resume()
    }
    
    func deleteClassFromServer(classes: Class, completion: @escaping () -> Void = { }) {
        
        let identifier = classes.id ?? UUID()
        classes.id = identifier
        
        let requestURL = baseURL
            .appendingPathComponent(identifier.uuidString)
            .appendingPathExtension("json")
        
        var request = URLRequest(url: requestURL)
        request.httpMethod = HTTPMethod.delete.rawValue
        
        URLSession.shared.dataTask(with: request) { (_, _, error) in
            
            if let error = error {
                NSLog("Error DELETEing class: \(error)")
                completion()
                return
            }
            completion()
        }.resume()
    }
    
    func createClass(name: String, instructorName: String, type: String, duration: String, intensityLevel: String, location: String, maxClassSize: Int16, classDetail: String, date: Date, isAttending: Bool, context: NSManagedObjectContext) {
        
        let classes = Class(name: name, instructorName: instructorName, type: type, duration: duration, intensityLevel: intensityLevel, location: location, maxClassSize: maxClassSize, classDetail: classDetail, date: date, isAttending: isAttending, context: context)
        CoreDataStack.shared.save(context: context)
        put(classes: classes)
    }
    
    func updateClass(classes: Class, name: String, instructorName: String, type: String, duration: String, intensityLevel: String, location: String, maxClassSize: Int16, classDetail: String, date: Date, context: NSManagedObjectContext) {
        
        classes.name = name
        classes.instructorName = instructorName
        classes.type = type
        classes.duration = duration
        classes.intensityLevel = intensityLevel
        classes.location = location
        classes.maxClassSize = Int16(maxClassSize)
        classes.classDetail = classDetail
        classes.date = date
        
        CoreDataStack.shared.save(context: context)
        put(classes: classes)
    }
    
    func updateClassAttending(classes: Class, context: NSManagedObjectContext) {
        if classes.isAttending == false {
            classes.isAttending.toggle()
        }
        CoreDataStack.shared.save(context: context)
        put(classes: classes)
    }
    
    
    func deleteClass(classes: Class, context: NSManagedObjectContext) {
        
        CoreDataStack.shared.mainContext.delete(classes)
        deleteClassFromServer(classes: classes)
        CoreDataStack.shared.save(context: context)
    }

    
    
}
