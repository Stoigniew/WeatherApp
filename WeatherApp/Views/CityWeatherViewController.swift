//
//  CityWeatherViewController.swift
//  WeatherApp
//
//  Created by Maciek on 19/04/2023.
//

import Foundation
import UIKit

class CityWeatherViewController: UIViewController, Storyboarded {
    
    weak var coordinator: MainCoordinator?
    var viewModel: CityWeatherViewModel?
    
    private let reuseCellIdentifier = "ReusableWeatherTableCell"
    
    @IBOutlet private weak var temperatureLabel: UILabel!
    @IBOutlet private weak var conditionsLabel: UILabel!
    @IBOutlet private weak var precipitationLabel: UILabel!
    @IBOutlet private weak var forecastTableView: UITableView!
    
    private let spinner = SpinnerViewController()
        
    override func viewDidLoad() {
        super.viewDidLoad()

        setupSpinner()
        
        title = viewModel?.city.name ?? NSLocalizedString("city_weather_default_title", comment: "")
        viewModel?.onDownloadCompleted = { downloaded, error in
            if downloaded {
                DispatchQueue.main.async {
                    self.removeSpinner()
                    guard let weather = self.viewModel?.weather else {
                        return
                    }
                    self.temperatureLabel.text = String(format: NSLocalizedString("weather_current_value", comment: ""), Int(weather.currentTemperature.metric.value))
                    self.conditionsLabel.text = weather.conditions
                    self.precipitationLabel.text = weather.precipitation ? NSLocalizedString("weather_current_precipitation", comment: "") : NSLocalizedString("weather_current_no_precipitation", comment: "")
                    self.temperatureLabel.textColor = self.viewModel?.currentTemperatureColor().value
                    self.viewModel?.downloadHourlyForecast()
                }
            } else {
                let alert = UIAlertController(title: "Error", message: NSLocalizedString("download_error_message", comment: ""), preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { _ in
                    alert.dismiss(animated: true)
                }))
                self.present(alert, animated: true)
            }
        }
        
        viewModel?.onAdditionalDownloadCompleted = { downloaded, _ in
            if downloaded {
                DispatchQueue.main.async {
                    self.forecastTableView.reloadData()
                }
            }
        }
        
        let forecastTableHeaderLabel = UILabel()
        forecastTableHeaderLabel.text = "12-hour forecast"
        
        forecastTableView.register(UITableViewCell.self, forCellReuseIdentifier: reuseCellIdentifier)
        forecastTableView.dataSource = self
        forecastTableView.tableHeaderView = forecastTableHeaderLabel
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        viewModel?.downloadWeather()
    }
    
    private func setupSpinner() {
        addChild(spinner)
        spinner.view.frame = view.frame
        view.addSubview(spinner.view)
        spinner.didMove(toParent: self)
    }
    
    private func removeSpinner() {
        spinner.willMove(toParent: nil)
        spinner.view.removeFromSuperview()
        spinner.removeFromParent()
    }
}

// MARK: - UITableView extension

extension CityWeatherViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel?.forecastWeather?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseCellIdentifier)!
        cell.selectionStyle = .none
        cell.textLabel?.text = String(format: NSLocalizedString("forecast_weather", comment: ""), (viewModel?.forecastWeather?[indexPath.row].forecastHour())!, Int((viewModel?.forecastWeather?[indexPath.row].temperature.value)!))
        cell.textLabel?.textColor = viewModel?.textColor(for: (viewModel?.forecastWeather?[indexPath.row].temperature.value)!).value
        return cell
    }
}
