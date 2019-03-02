//
//  CityListViewModel.swift
//  Backbase
//
//  Created by Paulo Correa on 01/03/19.
//  Copyright © 2019 Paulo Correa. All rights reserved.
//

import Foundation

class CityListViewModel {
    let cityList: [CityViewModel]
    var filteredList: [CityViewModel] = []
    var isSearching: Bool = false
    private var querySearch: String = ""
    private var searchWorkItem: DispatchWorkItem?

    init(cities: [City]) {
        self.cityList = cities
            .sorted {
                ($0.name.lowercased(), $0.country) < ($1.name.lowercased(), $1.country)
            }
            .map({
                return CityViewModel(city: $0)
            })
    }

    func searchCity(input: String, completion: @escaping () -> Void) {
        // Reset search in case of empty request
        if input == "" {
            self.isSearching = false
            self.querySearch = ""
            self.filteredList.removeAll(keepingCapacity: false)
            completion()
        } else {
            let searchWork = DispatchWorkItem { [unowned self] in
                self.isSearching = true
                // If we're narrowing down the search, we reuse the already filtered result
                self.filter(input: input, list: input.contains(self.querySearch) ? self.filteredList : self.cityList)
                
                DispatchQueue.main.async {
                    completion()
                }
                
                self.searchWorkItem = nil
            }
            
            searchWorkItem = searchWork
            let dispatchQueue = DispatchQueue(label: "Filter.array")
            
            // We filter valid search requests
            dispatchQueue.async(execute: searchWork)
        }
    }
    
    private func filter(input: String, list: [CityViewModel]) {
        if list.count == 0 { return }

        let start = DispatchTime.now()
        querySearch = input
        
        var lowerBound = 0
        var upperBound = list.count - 1
        let middleIndex: Int = lowerBound + (upperBound - lowerBound) / 2
        
        var hasFoundLower: Bool = false
        var hasFoundUpper: Bool = false
        
        // 0.10 milliseconds
        // This "binary" search isn't incomplete but it already saves 50% - 70% of the time compared to Swift's filter
        if (input.lowercased() > list[middleIndex].title.lowercased()) {
            for index in (middleIndex...list.endIndex - 1) {
                if list[index].title.lowercased().hasPrefix(input.lowercased()) {
                    lowerBound = index
                    hasFoundLower = true
                    break
                }
            }
            for index in (lowerBound...list.endIndex - 1) {
                if list[index].title.lowercased().hasPrefix(input.lowercased()) {
                    upperBound = index
                    hasFoundUpper = true
                } else {
                    break
                }
            }
        } else {
            for index in (0...middleIndex).reversed() {
                if list[index].title.lowercased().hasPrefix(input.lowercased()) {
                    upperBound = index
                    hasFoundUpper = true
                    break
                }
            }
            for index in (0...upperBound).reversed() {
                if list[index].title.lowercased().hasPrefix(input.lowercased()) {
                    lowerBound = index
                    hasFoundLower = true
                } else {
                    break
                }
            }
        }

        filteredList.removeAll(keepingCapacity: false)
        
        if hasFoundLower && hasFoundUpper {
            filteredList.append(contentsOf: list[lowerBound...upperBound])
        }

//        0.33 milliseconds
//        filteredList.removeAll(keepingCapacity: false)
//        filteredList.append(contentsOf: list.filter({
//            $0.title.lowercased().hasPrefix(input.lowercased())
//        }))
        
        let end = DispatchTime.now()
        
        let nanoTime = end.uptimeNanoseconds - start.uptimeNanoseconds
        let timeInterval = Double(nanoTime) / 1000000000
        print("Search in: \(timeInterval) milliseconds")
        print("Cities: \(filteredList.count)")
    }
}
