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
    
    var viewModel : WeatherViewModel = WeatherViewModel()
    
    var forecastList: [WeatherModel] = []
    
    var headerView: WeatherForecastHeaderView?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureTableView()
    }
    
    private func configureTableView() {
        weatherForecastTableView.delegate = self
        weatherForecastTableView.dataSource = self
        
        weatherForecastTableView.rowHeight = UITableView.automaticDimension
        weatherForecastTableView.estimatedRowHeight = 44
        
        weatherForecastTableView.register(UINib.init(nibName: "WeatherForecastTableViewCell", bundle: nil), forCellReuseIdentifier: "WeatherForecastTableViewCell")
        
        let headerView = (Bundle.main.loadNibNamed("WeatherForecastHeaderView", owner: self, options: nil)![0] as? WeatherForecastHeaderView)
        self.headerView = headerView
        weatherForecastTableView.tableHeaderView = headerView

    }

}

extension HomeWeatherViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.numberOfRows
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "WeatherForecastTableViewCell", for: indexPath) as! WeatherForecastTableViewCell
        if forecastList.count > 0 {
            cell.weatherDetails =  forecastList[indexPath.row]
        }
        cell.selectionStyle = .none
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 80
    }
    
}


extension HomeWeatherViewController: UITableViewDelegate {
    
}
