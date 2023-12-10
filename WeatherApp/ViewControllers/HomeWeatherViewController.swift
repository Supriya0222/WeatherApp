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

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setBackgroundFor(nil)
        
        configureTableView()
        
        setupHandlers()
        
        viewModel.checkLocationPermission()

    }
    
    private func setupHandlers() {
        viewModel.locationUpdateHandler = { [weak self] location in
            self?.viewModel.saveLocationToUserDefaults(location)
            self?.handleLocationUpdate(location)
            
            }
        
        viewModel.offlineHandler = {
             let cachedForecast = self.viewModel.getCachedForecastWeather(latitude: nil, longitude: nil)
            let cachedWeather = self.viewModel.getCachedCurrentWeather(latitude: nil, longitude: nil)

            if !cachedForecast.isEmpty && cachedWeather != nil {
                self.weatherForecastTableView.reloadData()
            }
            
        }
    }
    
    private func configureTableView() {
        weatherForecastTableView.delegate = self
        weatherForecastTableView.dataSource = self
        
        weatherForecastTableView.rowHeight = UITableView.automaticDimension
        weatherForecastTableView.estimatedRowHeight = 44
        
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
            self.view.backgroundColor = StyleGuide.sunnyColor
            backgroundImageView.image = nil
            weatherForecastTableView.backgroundColor = StyleGuide.sunnyColor

        }
    }
    
    func handleLocationUpdate(_ location: CLLocation) {
        let latitude = location.coordinate.latitude
        let longitude = location.coordinate.longitude
        
        viewModel.getCurrentWeatherFor(latitude: latitude, longitude: longitude) { currentWeather in
            //Set region and date labels
            self.viewModel.getRegion(location) { region in
                if let region = region {
                    self.updateLabel(self.regionLabel, value: "Region: \(region)")
                }
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
            
            self.viewModel.getForecastListFor(latitude: latitude, longitude: longitude) { list in
                self.weatherForecastTableView.reloadData()
            } failureHandler: { message in
                
            }

        } failureHandler: { errorMessage in
            
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
