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
    var weatherDetails: WeatherModel? =  nil {
        didSet {
            if let weatherDetails = weatherDetails {
                weekDayLabel.text = "Tuesday"
                weatherIconImageView.image = UIImage.init(named: "clear")
                temperatureLabel.text = String(describing: weatherDetails.main?.temp)
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
        weekDayLabel.font = StyleGuide.forecastFont
        weekDayLabel.textColor = StyleGuide.labelTextColor
        
        temperatureLabel.font = StyleGuide.forecastFont
        temperatureLabel.textColor = StyleGuide.labelTextColor
        
        weatherIconImageView.contentMode = .scaleAspectFit
    }
    
}
