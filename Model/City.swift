//
//  City.swift
//  Backbase
//
//  Created by Paulo Correa on 28/02/19.
//  Copyright © 2019 Paulo Correa. All rights reserved.
//

import Foundation

struct City: Decodable {
    let _id: Int
    let name: String
    let country: String
    let coord: Coordinates
}

struct Coordinates: Decodable {
    let lon: Double
    let lat: Double
}
