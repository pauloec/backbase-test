//
//  Parser.swift
//  Backbase
//
//  Created by Paulo Correa on 28/02/19.
//  Copyright © 2019 Paulo Correa. All rights reserved.
//

import Foundation

enum MyError: Error {
    case runtimeError(String)
}

struct Parser {
    
    static func parseCities() -> (List: [City]?, Error: MyError?) {
        if let path = Bundle.main.path(forResource: "cities", ofType: "json") {
            do {
                let data = try Data(contentsOf: URL(fileURLWithPath: path), options: .alwaysMapped)
                let cities = try JSONDecoder().decode([City].self, from: data)
                
                return (cities, nil)
            } catch let error {
                return (nil, MyError.runtimeError("Error Decoding Json:\(error)"))
            }
        } else {
            return (nil, MyError.runtimeError("File Not Found!"))
        }
    }
    
}
