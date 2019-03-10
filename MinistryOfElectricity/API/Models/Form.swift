//
//  Form.swift
//  MinistryOfElectricity
//
//  Created by Esslam Emad on 2/1/19.
//  Copyright © 2019 Alyom Apps. All rights reserved.
//

import Foundation

struct Form: Codable {
    var userID: Int!
    var name: String!
    var message: String!
    var subject: String!
    var photos: [String]!
    var longitude: Double!
    var latitude: Double!
    
    enum CodingKeys: String, CodingKey{
        case userID = "user_id"
        case name
        case message
        case subject
        case photos
        case longitude
        case latitude
    }
}
