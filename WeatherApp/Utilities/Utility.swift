//
//  Utility.swift
//  WeatherApp
//
//  Created by Supriya Rajkoomar on 10/12/2023.
//

import Foundation
import UIKit

//Adding activity indicator to a given view
public func addLoader(ToMainView view : UIView) -> UIActivityIndicatorView{
    
    let activityIndicator = UIActivityIndicatorView()
    activityIndicator.center = CGPoint.init(x: view.center.x, y: view.center.y - 64)
    activityIndicator.startAnimating()
    view.addSubview(activityIndicator)
    
    return activityIndicator
}

class AlertViewUtility{
    
    open class func showAlertWithTitle(_ container:UIViewController, tintColor:UIColor?,title:String , message:String , cancelButtonTitle:String , completion :@escaping (_ completion:Bool) ->Void){
        let alert =  UIAlertController.init(title: title, message: message, preferredStyle: .alert)
        
        let alertAction = UIAlertAction.init(title: cancelButtonTitle, style: .cancel) { (action :UIAlertAction) in
            
            alert.dismiss(animated: true, completion: {
                
            })
            completion(true)
        }
        
        alert.addAction(alertAction)
        container.present(alert, animated: true, completion: nil)
    }
    
    open class func showLocationAccessDeniedAlert(_ viewController: UIViewController) {
        let alert = UIAlertController(
            title: "Location Access Denied",
            message: "Please enable location access in Settings to use this feature.",
            preferredStyle: .alert
        )

        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        alert.addAction(cancelAction)

        let settingsAction = UIAlertAction(title: "Settings", style: .default) { _ in
            if let settingsURL = URL(string: UIApplication.openSettingsURLString) {
                UIApplication.shared.open(settingsURL, options: [:], completionHandler: nil)
            }
        }
        alert.addAction(settingsAction)

        viewController.present(alert, animated: true, completion: nil)
    }

}
