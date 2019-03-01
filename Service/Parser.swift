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
    static func parseCities(completion: ([City]) -> Void, failure: (MyError) -> Void) {
        if let path = Bundle.main.path(forResource: "cities", ofType: "json") {
            do {
                let data = try Data(contentsOf: URL(fileURLWithPath: path), options: .alwaysMapped)
                let cities = try JSONDecoder().decode([City].self, from: data)
                
                completion(cities)
            } catch let error {
                failure(MyError.runtimeError("Error Decoding Json:\(error)"))
            }
        } else {
            failure(MyError.runtimeError("File Not Found!"))
        }
    }
}
