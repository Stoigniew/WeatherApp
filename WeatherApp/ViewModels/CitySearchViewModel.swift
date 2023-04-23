//
//  CitySearchViewModel.swift
//  WeatherApp
//
//  Created by Maciek on 16/04/2023.
//

import Foundation

class CitySearchViewModel {
    var onDownloadCompleted: ((Bool, Error?) -> Void)?

    private let regex = NSRegularExpression("^\\p{Lu}\\p{L}*(?:[\\s-]\\p{Lu}\\p{L}*)*$")
    
    private var networkService: NetworkService?
    private var searchedCitiesStorage: SearchedCitiesStorage
    private(set) var citiesList: Cities = []
    
    private var searchedCities: Cities? {
        get {
            searchedCitiesStorage.retrieveCities()
        }
    }

    init(searchedCitiesStorage: SearchedCitiesStorage) {
        self.searchedCitiesStorage = searchedCitiesStorage
        resetCitiesList()
    }
    
    func storeSearchedCity(_ city: City) {
        if !(searchedCities?.contains(where: { $0 == city }) ?? false) {
            searchedCitiesStorage.store(city: city)
        }
    }
    
    func resetCitiesList() {
        citiesList = []
        searchedCities?.forEach { city in
            citiesList.append(city)
        }
    }
    
    func downloadCities(matching name: String) {
        if !isSearchedCityNameValid(for: name) {
            return
        }
        
        downloadCities(matching: name) { [weak self] cities, error in
            guard let cities = cities else {
                self?.onDownloadCompleted?(false, error)
                return
            }
            self?.citiesList.removeAll()
            cities.forEach { city in
                self?.citiesList.append(city)
            }
            self?.onDownloadCompleted?(true, error)
        }
    }
    
    private func isSearchedCityNameValid(for name: String) -> Bool {
        return regex.matches(name)
    }
    
    private func downloadCities(matching name: String, _ completion: @escaping (Cities?, Error?) -> Void) {
        networkService = NetworkManager()
        networkService?.getCities(matching: name) { result in
            switch result {
            case .success(let cities):
                completion(cities, nil)
            case .failure(let error):
                completion(nil, error)
            }
        }
    }
}

extension NSRegularExpression {
    convenience init(_ pattern: String) {
        do {
            try self.init(pattern: pattern)
        } catch {
            preconditionFailure("Illegal regular expression: \(pattern).")
        }
    }
    
    func matches(_ string: String) -> Bool {
        let range = NSRange(location: 0, length: string.utf16.count)
        return firstMatch(in: string, options: [], range: range) != nil
    }
}
