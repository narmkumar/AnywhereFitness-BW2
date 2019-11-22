//
//  ClassRepresentation.swift
//  AnywhereFitness
//
//  Created by Niranjan Kumar on 11/19/19.
//  Copyright © 2019 NarJesse. All rights reserved.
//

import Foundation

struct ClassRepresentation: Codable {
    let name: String
    let instructorName: String
    let type: String
    let duration: String
    let intensityLevel: String
    let location: String
    let maxClassSize: Int16
    let classDetail: String
    let date: Date
    let isAttending: Bool?
    let id: UUID
}
