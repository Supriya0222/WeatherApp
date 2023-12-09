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
    
    
    func updateHeaderViewWith(weatherDetails: ForecastEntity) {
        backgroundColor = .clear
        minimumTemperatureView.valueLabel.text = String(format: "%.1f°", weatherDetails.temp_min)
        minimumTemperatureView.descriptionLabel.text = "min"
        minimumTemperatureView.descriptionLabel.font = StyleGuide.forecastFont
        minimumTemperatureView.valueLabel.font = StyleGuide.forecastFont
        minimumTemperatureView.descriptionLabel.textColor = StyleGuide.labelTextColor
        minimumTemperatureView.valueLabel.textColor = StyleGuide.labelTextColor

        currentTemperatureView.valueLabel.text = String(format: "%.1f°", weatherDetails.temp_current)
        currentTemperatureView.descriptionLabel.text = "Current"
        currentTemperatureView.descriptionLabel.font = StyleGuide.forecastFont
        currentTemperatureView.valueLabel.font = StyleGuide.forecastFont
        currentTemperatureView.descriptionLabel.textColor = StyleGuide.labelTextColor
        currentTemperatureView.valueLabel.textColor = StyleGuide.labelTextColor


        maximumTemperatureView.valueLabel.text = String(format: "%.1f°",weatherDetails.temp_max)
        maximumTemperatureView.descriptionLabel.text = "max"
        maximumTemperatureView.descriptionLabel.font = StyleGuide.forecastFont
        maximumTemperatureView.valueLabel.font = StyleGuide.forecastFont
        maximumTemperatureView.descriptionLabel.textColor = StyleGuide.labelTextColor
        maximumTemperatureView.valueLabel.textColor = StyleGuide.labelTextColor

    }

    
}
