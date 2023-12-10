//
//  StyleGuide.swift
//  WeatherApp
//
//  Created by Supriya Rajkoomar on 09/12/2023.
//

import Foundation
import UIKit

struct StyleGuide {
    
    //Fonts
    static let currentTempFont =  UIFont.init(name: ".Helvetica-Neue", size: 40) ?? UIFont.init(name: ".SFUI-Regular", size: 40)
    static let currentTempDescFont =  UIFont.init(name: "Helvetica-Neue", size: 34) ?? UIFont.init(name: ".SFUI-Regular", size: 34)
    static let forecastFont =  UIFont.init(name: "Helvetica-Neue", size: 21) ?? UIFont.init(name: ".SFUI-Regular", size: 21)
    static let smallLabelFont = UIFont.init(name: "Helvetica-Neue", size: 15) ?? UIFont.init(name: ".SFUI-Regular", size: 15)


    
    //Colours
    static let sunnyColor = UIColor.init(red: 71/255, green: 171/255, blue: 47/255, alpha: 1.0)
    static let cloudyColor = UIColor.init(red: 84/255, green: 113/255, blue: 122/255, alpha: 1.0)
    static let rainyColor = UIColor.init(red: 87/255, green: 87/255, blue: 93/255, alpha: 1.0)
    static let labelTextColor = UIColor.white

}
