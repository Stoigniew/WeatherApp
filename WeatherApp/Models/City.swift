//
//  City.swift
//  WeatherApp
//
//  Created by Maciek on 18/04/2023.
//

import Foundation

typealias Cities = [City]

struct City: Codable, Identifiable {
    let id: String
    let name: String
    let country: Country
    
    enum CodingKeys: String, CodingKey {
        case id = "Key"
        case name = "LocalizedName"
        case country = "Country"
    }
}

struct Country: Codable {
    let id: String
    
    enum CodingKeys: String, CodingKey {
        case id = "ID"
    }
}

// MARK: - City extension

extension City: Comparable {
    static func < (lhs: City, rhs: City) -> Bool {
        return lhs.name < rhs.name
    }
    
    static func == (lhs: City, rhs: City) -> Bool {
        return lhs.id == rhs.id
    }
    
    
}
