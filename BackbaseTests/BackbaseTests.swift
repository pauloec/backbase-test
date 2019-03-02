//
//  BackbaseTests.swift
//  BackbaseTests
//
//  Created by Paulo Correa on 01/03/19.
//  Copyright © 2019 Paulo Correa. All rights reserved.
//

import XCTest
@testable import Backbase

class BackbaseTests: XCTestCase {
    var cityListViewModel: CityListViewModel!
    
    override func setUp() {
        super.setUp()
        
        let coordinatePortAlegre = Coordinates(lon: -51.23, lat: -30.03306)
        let cityPortoAlegre = City(_id: 3452925, name: "Porto Alegre", country: "BR", coord: coordinatePortAlegre)
        
        let coordinateBenque = Coordinates(lon: 89.139168, lat: 17.075001)
        let cityBenque = City(_id: 3582662, name: "Benque Viejo del Carmen", country: "BZ", coord: coordinateBenque)
        
        let coordinateAndoy = Coordinates(lon: 4.92669, lat: 50.435249)
        let cityAndoy = City(_id: 2803195, name: "Andoy", country: "BE", coord: coordinateAndoy)
        
        let coordinateAuPont = Coordinates(lon: 4.13333, lat: 50.599998)
        let cityAuPont = City(_id: 2802922, name: "Au Pont", country: "BE", coord: coordinateAuPont)
        
        cityListViewModel = CityListViewModel(cities: [cityPortoAlegre, cityBenque, cityAndoy, cityAuPont])
    }
    
    override func tearDown() {
        cityListViewModel = nil
    }
    
    func testCityViewModel() {
        XCTAssertEqual("Au Pont, BE", cityListViewModel.cityList[1].title)
        XCTAssertEqual("Latitude: 50.599998, Longitude: 4.13333", cityListViewModel.cityList[1].subtitle)
    }
    
    func testSearch() {
        let expectation = XCTestExpectation(description: "Filtered Cities")
        
        cityListViewModel.searchCity(input: "A", completion: {
            expectation.fulfill()
        })
        
        wait(for: [expectation], timeout: 2)
        
        XCTAssertEqual(2, cityListViewModel.filteredList.count)
        XCTAssertEqual("Andoy, BE", cityListViewModel.filteredList[0].title)
    }
    
    func testSearchNoRecord() {
        let expectation = XCTestExpectation(description: "Filtered Cities")
        
        cityListViewModel.searchCity(input: "😱!", completion: {
            expectation.fulfill()
        })
        
        wait(for: [expectation], timeout: 2)
        
        XCTAssertEqual(cityListViewModel.filteredList.count, 0)
    }
    
    func testResetSearch() {
        let expectation = XCTestExpectation(description: "Filtered Cities")
        
        cityListViewModel.searchCity(input: "", completion: {
            expectation.fulfill()
        })
        
        wait(for: [expectation], timeout: 2)
        
        XCTAssertEqual(cityListViewModel.filteredList.count, 0)
    }
    
}
