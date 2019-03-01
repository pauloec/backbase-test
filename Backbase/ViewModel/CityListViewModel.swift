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
        let dispatchQueue = DispatchQueue(label: "Filter.array", qos: .background)
        dispatchQueue.async { [unowned self] in
            // Reset search in case of empty request
            if input == "" {
                self.isSearching = false
                self.querySearch = ""
                self.filteredList.removeAll(keepingCapacity: false)
            } else {
                self.isSearching = true
                // If we're narrowing down the search, we reuse the already filtered result
                self.filter(input: input, list: input.contains(self.querySearch) ? self.filteredList : self.cityList)
            }
            
            DispatchQueue.main.async {
                completion()
            }
        }
    }
    
    private func filter(input: String, list: [CityViewModel]) {
        querySearch = input
        // Cities area already sorted, so finding the range is faster than filtering
        let firstIndex = list.firstIndex(where: {
            $0.title.lowercased().hasPrefix(input.lowercased())
        })
        
        let lastIndex = list.lastIndex(where: {
            $0.title.lowercased().hasPrefix(input.lowercased())
        })
        
        if let firstIndex = firstIndex, let lastIndex = lastIndex {
            filteredList.removeAll(keepingCapacity: false)
            filteredList.append(contentsOf: list[firstIndex...lastIndex])
            print("First Index: \(firstIndex) Last Index: \(lastIndex)")
        } else {
            print("No Record")
            filteredList = []
        }
    }
    
}
