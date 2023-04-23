//
//  Coordinator.swift
//  WeatherApp
//
//  Created by Maciek on 15/04/2023.
//

import Foundation
import UIKit

protocol Coordinator {
    var navigationController: UINavigationController { get set }
    
    func start()
}
