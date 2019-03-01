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
    var isSearching: Bool = false
    var willSearch: (() -> ())?
    var didSearch: (() -> ())?
    var filteredList: [CityViewModel] = []
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

    func searchCity(input: String) {
        if input == "" {
            isSearching = false
            querySearch = ""
            filteredList.removeAll(keepingCapacity: false)
            if let didSearch = self.didSearch {
                didSearch()
            }
        } else {
            if let willSearch = willSearch {
                willSearch()
            }
            
            isSearching = true
            filter(input: input, list: input.contains(querySearch) ? filteredList : cityList)
        }
    }
    
    private func filter(input: String, list: [CityViewModel]) {
        querySearch = input
        let dispatchQueue = DispatchQueue(label: "Filter.array", qos: .background)
        dispatchQueue.async { [weak self] in
            let firstIndex = list.firstIndex(where: {
                $0.title.lowercased().hasPrefix(input.lowercased())
            })
            
            let lastIndex = list.lastIndex(where: {
                $0.title.lowercased().hasPrefix(input.lowercased())
            })
            
            if let firstIndex = firstIndex, let lastIndex = lastIndex {
                self?.filteredList.removeAll(keepingCapacity: false)
                self?.filteredList.append(contentsOf: list[firstIndex...lastIndex])
                
                print("First Index: \(firstIndex) Last Index: \(lastIndex)")
            } else {
                print("No Record")
                self?.filteredList = []
            }
            
            if let didSearch = self?.didSearch {
                DispatchQueue.main.async {
                    didSearch()
                }
            }
        }
    }
    
}
