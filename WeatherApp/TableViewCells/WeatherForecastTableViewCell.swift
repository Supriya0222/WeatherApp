//
//  WeatherForecastTableViewCell.swift
//  WeatherApp
//
//  Created by Supriya Rajkoomar on 08/12/2023.
//

import UIKit

class WeatherForecastTableViewCell: UITableViewCell {
    
    @IBOutlet weak var weatherIconImageView: UIImageView!
    @IBOutlet weak var temperatureLabel: UILabel!
    @IBOutlet weak var weekDayLabel: UILabel!
    var weatherDetails: ForecastEntity? =  nil {
        didSet {
            if let weatherDetails = weatherDetails {
                weekDayLabel.text = DateUtility.getDayOfWeek(timestamp: Double(weatherDetails.timestamp))
                weatherIconImageView.image = WeatherViewModel.getWeatherTypeDetailsFor(weatherDetails.weather_type ?? "").iconImage
                temperatureLabel.text = String(format: "%.1f°", weatherDetails.temp_current)
            }
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setUpUI()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }
    
    private func setUpUI() {
        backgroundColor = .clear
        weekDayLabel.font = StyleGuide.forecastFont
        weekDayLabel.textColor = StyleGuide.labelTextColor
        
        temperatureLabel.font = StyleGuide.forecastFont
        temperatureLabel.textColor = StyleGuide.labelTextColor
        
        weatherIconImageView.contentMode = .scaleAspectFit
    }
    
}
