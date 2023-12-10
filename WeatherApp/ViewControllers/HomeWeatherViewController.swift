//
//  HomeWeatherViewController.swift
//  WeatherApp
//
//  Created by Supriya Rajkoomar on 08/12/2023.
//

import UIKit
import CoreLocation

class HomeWeatherViewController: UIViewController {
    
    @IBOutlet weak var weatherForecastTableView: UITableView!
    @IBOutlet weak var backgroundImageView: UIImageView!
    @IBOutlet weak var currentDetailsView: TopAndBottomLabelsView!
    
    @IBOutlet weak var regionLabel: UILabel!
    @IBOutlet weak var dateUpdatedLabel: UILabel!
    
    var headerView: WeatherForecastHeaderView?
    var viewModel : WeatherViewModel = WeatherViewModel()
    
    var loader : UIActivityIndicatorView?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setBackgroundFor(nil)
        
        configureTableView()
        
        setupHandlers()
        
        viewModel.checkLocationPermission()
    }
    
    private func setupHandlers() {
        viewModel.locationUpdateHandler = { [weak self] (location,regionName) in
            
            self?.viewModel.saveLocationToUserDefaults(regionName ?? "UnknownRegion")
            self?.handleLocationUpdate(location, regionName: regionName)
            
            }

        viewModel.locationAccessDeniedHandler = {
            AlertViewUtility.showLocationAccessDeniedAlert(self)
        }
        
        viewModel.offlineHandler = {
            self.displayWeatherFromDatabase()
        }
    }
    
    private func configureTableView() {
        weatherForecastTableView.delegate = self
        weatherForecastTableView.dataSource = self
        
        weatherForecastTableView.rowHeight = UITableView.automaticDimension
        weatherForecastTableView.estimatedRowHeight = 44
        weatherForecastTableView.separatorStyle = .none
        
        weatherForecastTableView.register(UINib.init(nibName: "WeatherForecastTableViewCell", bundle: nil), forCellReuseIdentifier: "WeatherForecastTableViewCell")
        
        let headerView = (Bundle.main.loadNibNamed("WeatherForecastHeaderView", owner: self, options: nil)![0] as? WeatherForecastHeaderView)
        self.headerView = headerView

    }
    
    private func setBackgroundFor(_ weatherType: String?) {
        if let _ = weatherType {
            self.view.backgroundColor = WeatherViewModel.getWeatherTypeDetailsFor(weatherType!).backgroundColor
            weatherForecastTableView.backgroundColor = WeatherViewModel.getWeatherTypeDetailsFor(weatherType!).backgroundColor
            backgroundImageView.image =  WeatherViewModel.getWeatherTypeDetailsFor(weatherType!).backgroundImage
        } else {
            self.view.backgroundColor = StyleGuide.placeholderColor
            backgroundImageView.image = nil
            weatherForecastTableView.backgroundColor = nil

        }
    }
    
    func handleLocationUpdate(_ location: CLLocation, regionName: String?) {
        let latitude = location.coordinate.latitude
        let longitude = location.coordinate.longitude
        
        //Add activity indicator to view while loading content
        loader = addLoader(ToMainView: view)
        
        viewModel.getCurrentWeatherFor(region: regionName, latitude: latitude, longitude: longitude) { currentWeather in
            
            self.removeLoader()
            self.updateUIWith(currentWeather: currentWeather)
            print("timestamp: \(currentWeather.timestamp)")
            self.viewModel.getForecastListFor(region: regionName, latitude: latitude, longitude: longitude) { list in
                self.weatherForecastTableView.reloadData()
                
            } failureHandler: { message in
                DispatchQueue.main.async {
                    self.removeLoader()
                    AlertViewUtility.showAlertWithTitle(self, tintColor: nil, title: "Error", message: message ?? "An error has occurred. Please try again later.", cancelButtonTitle: "Okay") { completion in
                        
                        self.displayWeatherFromDatabase()

                    }
                }
            }

        } failureHandler: { errorMessage in
            DispatchQueue.main.async {
                self.removeLoader()
                AlertViewUtility.showAlertWithTitle(self, tintColor: nil, title: "Error", message: errorMessage ?? "An error has occurred. Please try again later.", cancelButtonTitle: "Okay") { completion in
                    
                    self.displayWeatherFromDatabase()

                }
            }
        }
        
      }
    
    //Method to remove activity indicator
    private func removeLoader(){
        if let loader = loader{
            loader.removeFromSuperview()
        }
    }
    
    private func updateUIWith(currentWeather: ForecastEntity) {
        let region = currentWeather.region
        
        //Set region and date labels
        if let _ = region {
            self.updateLabel(self.regionLabel, value: "Region: \(String(describing: region!))")
        }
        
        if let dateUpdated = self.viewModel.getDateUpdated(currentWeather.timestamp) {
            self.updateLabel(self.dateUpdatedLabel, value: "Last Updated: \(dateUpdated)")
        }
        
        self.setBackgroundFor(currentWeather.weather_type)
        self.setCurrentWeatherDetailsFor(currentWeather)
        if let _ = self.headerView {
            self.weatherForecastTableView.tableHeaderView = self.headerView
            self.headerView?.updateHeaderViewWith(weatherDetails: currentWeather)
        }
    }
    
    private func displayWeatherFromDatabase() {
        let cachedForecast = self.viewModel.getCachedForecastWeather(region: nil)
        
        let cachedWeather = self.viewModel.getCachedCurrentWeather(region: nil)
        
        if !cachedForecast.isEmpty && cachedWeather != nil {
            
            self.updateUIWith(currentWeather: cachedWeather!)

            self.weatherForecastTableView.reloadData()
        }
    }
    
    private func setCurrentWeatherDetailsFor(_ weatherDetails: ForecastEntity) {
        currentDetailsView.valueLabel.font = StyleGuide.currentTempFont
        currentDetailsView.descriptionLabel.font = StyleGuide.currentTempDescFont
        currentDetailsView.valueLabel.textColor = StyleGuide.labelTextColor
        currentDetailsView.descriptionLabel.textColor = StyleGuide.labelTextColor

        currentDetailsView.valueLabel.text = String(format: "%.1f°", weatherDetails.temp_current)
        currentDetailsView.descriptionLabel.text = WeatherViewModel.getWeatherTypeDetailsFor(weatherDetails.weather_type ?? "").weatherType.uppercased()

    }
    
    private func updateLabel(_ label: UILabel, value: String) {
        label.text = value
        label.font = StyleGuide.smallLabelFont
        label.textColor = StyleGuide.labelTextColor
    }

}

extension HomeWeatherViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.forecastList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "WeatherForecastTableViewCell", for: indexPath) as! WeatherForecastTableViewCell
        if viewModel.forecastList.count > 0 {
            cell.weatherDetails =  viewModel.forecastList[indexPath.row]
        }
        cell.selectionStyle = .none
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 60
    }
    
}


extension HomeWeatherViewController: UITableViewDelegate {
    
}
