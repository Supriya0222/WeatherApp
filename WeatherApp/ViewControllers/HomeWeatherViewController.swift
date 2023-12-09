//
//  HomeWeatherViewController.swift
//  WeatherApp
//
//  Created by Supriya Rajkoomar on 08/12/2023.
//

import UIKit

class HomeWeatherViewController: UIViewController {
    
    @IBOutlet weak var weatherForecastTableView: UITableView!
    @IBOutlet weak var backgroundImageView: UIImageView!
    @IBOutlet weak var currentDetailsView: TopAndBottomLabelsView!
    
    var headerView: WeatherForecastHeaderView?
    var viewModel : WeatherViewModel = WeatherViewModel()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setBackgroundFor(nil)
        
        configureTableView()
        
        viewModel.getCurrentWeatherFor(latitude: -26.2041028, longitude: 28.0473051) { currentWeather in
            
            self.setBackgroundFor(currentWeather.weather_type)
            self.setCurrentWeatherDetailsFor(currentWeather)
            if let _ = self.headerView {
                self.weatherForecastTableView.tableHeaderView = self.headerView
                self.headerView?.updateHeaderViewWith(weatherDetails: currentWeather)
            }
            
            self.viewModel.getForecastListFor(latitude: -26.2041028, longitude: 28.0473051) { list in
                print(list.count)
                self.weatherForecastTableView.reloadData()
            } failureHandler: { message in
                
            }

        } failureHandler: { errorMessage in
            
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
    
    private func setCurrentWeatherDetailsFor(_ weatherDetails: ForecastEntity) {
        currentDetailsView.valueLabel.font = StyleGuide.currentTempFont
        print(currentDetailsView.valueLabel.font)
        currentDetailsView.descriptionLabel.font = StyleGuide.currentTempDescFont
        currentDetailsView.valueLabel.textColor = StyleGuide.labelTextColor
        currentDetailsView.descriptionLabel.textColor = StyleGuide.labelTextColor

        currentDetailsView.valueLabel.text = String(format: "%.1f°", weatherDetails.temp_current)
        currentDetailsView.descriptionLabel.text = WeatherViewModel.getWeatherTypeDetailsFor(weatherDetails.weather_type ?? "").weatherType.uppercased()

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
