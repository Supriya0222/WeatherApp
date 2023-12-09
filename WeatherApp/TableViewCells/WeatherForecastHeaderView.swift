//
//  WeatherForecastHeaderView.swift
//  WeatherApp
//
//  Created by Supriya Rajkoomar on 09/12/2023.
//

import UIKit

class WeatherForecastHeaderView: UIView {

    @IBOutlet weak var minimumTemperatureView: TopAndBottomLabelsView!
    
    @IBOutlet weak var currentTemperatureView: TopAndBottomLabelsView!
    
    @IBOutlet weak var maximumTemperatureView: TopAndBottomLabelsView!
    
    
    func updateHeaderViewWith(model: WeatherModel) {
        minimumTemperatureView.valueLabel.text = String(describing: model.main?.tempMin)
        minimumTemperatureView.descriptionLabel.text = "min"

        currentTemperatureView.valueLabel.text = String(describing: model.main?.temp)
        currentTemperatureView.descriptionLabel.text = "Current"

        maximumTemperatureView.valueLabel.text = String(describing: model.main?.tempMax)
        maximumTemperatureView.descriptionLabel.text = "max"
    }

    
}
