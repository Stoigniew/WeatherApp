//
//  SearchCityViewController.swift
//  WeatherApp
//
//  Created by Maciek on 16/04/2023.
//

import UIKit

class SearchCityViewController: UIViewController, Storyboarded {

    weak var coordinator: MainCoordinator?
    var viewModel: CitySearchViewModel?
    
    @IBOutlet private weak var citiesTableView: UITableView!
    
    private let reuseCellIdentifier = "ReusableTableCell"
    private let spinner = SpinnerViewController()
    
    private var textField: UITextField!
    private var searchTimer: Timer?

    override func viewDidLoad() {
        super.viewDidLoad()

        setupUI()
        hideKeyboardWhenTappedAround()
        
        viewModel?.onDownloadCompleted = { downloaded, error in
            if downloaded {
                DispatchQueue.main.async {
                    self.removeSpinner()
                    self.citiesTableView.reloadData()
                }
            } else {
                let alert = UIAlertController(title: "Error", message: NSLocalizedString("download_error_message", comment: ""), preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { _ in
                    alert.dismiss(animated: true)
                }))
                self.present(alert, animated: true)
            }
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        resetUI()
    }
    
    private func resetUI() {
        textField.resignFirstResponder()
        textField.text = ""
        viewModel?.resetCitiesList()
        citiesTableView.reloadData()
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
    
    private func setupUI() {
        
        citiesTableView.register(UITableViewCell.self, forCellReuseIdentifier: reuseCellIdentifier)
        citiesTableView.dataSource = self
        citiesTableView.delegate = self
        
        textField = UITextField()
        textField.delegate = self
        textField.borderStyle = .roundedRect
        textField.clearButtonMode = .whileEditing
        textField.placeholder = "Enter city name"
        
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: 5, height: 20))
        textField.sizeToFit()
        textField.leftView = paddingView
        textField.leftViewMode = .always
        textField.addTarget(self, action: #selector(textFieldDidEditingChanged(_:)), for: .editingChanged)
        
        citiesTableView.tableHeaderView = textField
        definesPresentationContext = true
    }
}

// MARK: - UITextField extension

extension SearchCityViewController: UITextFieldDelegate {
    func textFieldDidEndEditing(_ textField: UITextField) {
        guard let text = textField.text else {
            return
        }
        setupSpinner()
        viewModel?.downloadCities(matching: text)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        hideKeyboard()
        return true
    }
    
    @objc func textFieldDidEditingChanged(_ textField: UITextField) {
         if searchTimer != nil {
             searchTimer?.invalidate()
             searchTimer = nil
         }

         searchTimer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(searchForKeyword(_:)), userInfo: textField.text!, repeats: false)
     }
    
    @objc func searchForKeyword(_ timer: Timer) {
        let text = timer.userInfo as! String
        setupSpinner()
        viewModel?.downloadCities(matching: text)
    }
}

// MARK: - UITableView extension

extension SearchCityViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel?.citiesList.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseCellIdentifier)!
        cell.selectionStyle = .none
        cell.textLabel?.text = "\(viewModel?.citiesList[indexPath.row].name ?? "") (\( viewModel?.citiesList[indexPath.row].country.id ?? ""))"
        return cell
    }
}

extension SearchCityViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let city = viewModel?.citiesList[indexPath.row] else {
            return
        }
        viewModel?.storeSearchedCity(city)
        coordinator?.showWeather(for: city)
    }
}

// MARK: - UIViewController extension

extension UIViewController {
    func hideKeyboardWhenTappedAround() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(hideKeyboard))
        tapGesture.cancelsTouchesInView = false
        view.addGestureRecognizer(tapGesture)
    }
    
    @objc
    func hideKeyboard() {
        view.endEditing(true)
    }
}
