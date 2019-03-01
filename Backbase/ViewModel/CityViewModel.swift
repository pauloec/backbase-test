//
//  CityViewModel.swift
//  Backbase
//
//  Created by Paulo Correa on 01/03/19.
//  Copyright © 2019 Paulo Correa. All rights reserved.
//

import Foundation

struct CityViewModel {
    
    let title: String
    let subtitle: String
    let latitude: Double
    let longitude: Double
    
    init(city: City) {
        self.title = "\(city.name), \(city.country)"
        self.subtitle = "Latitude: \(city.coord.lat), Longitude: \(city.coord.lon)"
        self.latitude = city.coord.lat
        self.longitude = city.coord.lon
    }
}
