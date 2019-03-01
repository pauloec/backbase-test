//
//  CityListViewModel.swift
//  Backbase
//
//  Created by Paulo Correa on 01/03/19.
//  Copyright © 2019 Paulo Correa. All rights reserved.
//

import Foundation

class CityListViewModel {
    let cityList: [City]
    
    init(cities: [City]) {
        self.cityList = cities.sorted {
            ($0.name, $0.country) < ($1.name, $0.country)
        }
    }

}
