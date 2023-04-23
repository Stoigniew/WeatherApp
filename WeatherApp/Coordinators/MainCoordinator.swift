//
//  MainCoordinator.swift
//  WeatherApp
//
//  Created by Maciek on 15/04/2023.
//

import Foundation
import UIKit

class MainCoordinator: Coordinator {
    var navigationController: UINavigationController
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func start() {
        let viewController = SearchCityViewController.instantiate()
        viewController.coordinator = self
        viewController.viewModel = CitySearchViewModel(searchedCitiesStorage: SearchedCitiesStorage())
        navigationController.pushViewController(viewController, animated: true)
    }
    
    func showWeather(for city: City) {
        let viewController = CityWeatherViewController.instantiate()
        viewController.coordinator = self
        viewController.viewModel = CityWeatherViewModel(city: city)
        navigationController.pushViewController(viewController, animated: true)
    }
}
