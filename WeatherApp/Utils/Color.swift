//
//  Color.swift
//  WeatherApp
//
//  Created by Maciek on 23/04/2023.
//

import Foundation
import UIKit

enum Color {
    case coldTemperature
    case normalTemperature
    case warmTemperature
}

extension Color {
    var value: UIColor {
        switch self {
        case .coldTemperature:
            return UIColor(named: "cold_temperature") ?? .black
        case .normalTemperature:
            return UIColor(named: "normal_temperature") ?? .black
        case .warmTemperature:
            return UIColor(named: "warm_temperature") ?? .black
        }
    }
}
