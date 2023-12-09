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
    static let currentTempFont =  UIFont.init(name: "Helvetica-Neue", size: 40) ?? UIFont.init(name: "System-Bold", size: 40)
    static let currentTempDescFont =  UIFont.init(name: "Helvetica-Neue", size: 34) ?? UIFont.init(name: "System-Bold", size: 34)
    static let forecastFont =  UIFont.init(name: "Helvetica-Neue", size: 21) ?? UIFont.init(name: "System-Bold", size: 21)

    
    //Colours
    static let sunnyColor = UIColor(hex: "47AB2F")
    static let cloudyColor = UIColor(hex: "54717A")
    static let rainyColor = UIColor(hex: "57575D")
    static let labelTextColor = UIColor.white

}
