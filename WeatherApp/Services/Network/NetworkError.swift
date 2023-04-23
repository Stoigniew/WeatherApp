//
//  NetworkError.swift
//  WeatherApp
//
//  Created by Maciek on 23/04/2023.
//

import Foundation

enum NetworkError: Error {
    case notAvailable
    case requestsExceeded
    case notFound
}
