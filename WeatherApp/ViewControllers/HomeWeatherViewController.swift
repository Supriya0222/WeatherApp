//
//  HomeWeatherViewController.swift
//  WeatherApp
//
//  Created by Supriya Rajkoomar on 08/12/2023.
//

import UIKit

class HomeWeatherViewController: UIViewController {
    
    var viewModel : WeatherViewModel = WeatherViewModel()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        viewModel.apiService.requestForecastWeatherFor(latitude: -26.2041028, longitude: 28.0473051) { forecastList in
            print(forecastList.list)
            print(forecastList.list?.count)

        } failureHandler: { errorMessage in
            print(errorMessage)
        }


    }

}
