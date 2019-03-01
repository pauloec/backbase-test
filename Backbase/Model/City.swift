//
//  City.swift
//  Backbase
//
//  Created by Paulo Correa on 28/02/19.
//  Copyright © 2019 Paulo Correa. All rights reserved.
//

import Foundation

struct City: Decodable, Equatable {
    let _id: Int
    let name: String
    let country: String
    let coord: Coordinates
    
    static func ==(lhs:City, rhs:City) -> Bool {
        return lhs._id == rhs._id
    }
}

struct Coordinates: Decodable {
    let lon: Double
    let lat: Double
}
