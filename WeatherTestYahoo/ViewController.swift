//
//  ViewController.swift
//  WeatherTestYahoo
//
//  Created by punit on 4/11/17.
//  Copyright © 2017 punit. All rights reserved.
//

import UIKit
import CoreLocation
import SwiftyJSON
import Alamofire

class ViewController: UIViewController {
    
    //top part
    var temp: Int!
    var cityName: String!
    
    //daily part
    var dailyIconNames: [String] = []
    var dailyHighs: [Int] = []
    var dailyLows:  [Int] = []
    var dailyImages: [UIImage] = []
    var dailyDayNames: [String] = []
    
    var tempView: UIView!
    var dailyWeatherTableView: UITableView!
    
    var tempLabel: UILabel!
    var cityLabel: UILabel!
    
    let tempHeight: CGFloat = 0.5
    let descHeight: CGFloat = 0.25
    
    let myNotificationKey = "com.devs.notificationKey"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.catchNotification(_:)), name: NSNotification.Name(rawValue: self.myNotificationKey), object: nil)
        
        view.backgroundColor = UIColor(hex: "85BB38")
    }
    
    func catchNotification(_ notification: NSNotification) {
        
        let userInfo = JSON(notification.userInfo!)
        temp = Int(userInfo["query"]["results"]["channel"]["item"]["condition"]["temp"].doubleValue)
        cityName = userInfo["query"]["results"]["channel"]["location"]["city"].stringValue
        
        print(temp)
        
        for day in userInfo["query"]["results"]["channel"]["item"]["forecast"].arrayValue {
            dailyHighs.append(Int(day["high"].doubleValue))
            dailyLows.append(Int(day["low"].doubleValue))
            let iconName = day["text"].stringValue
            dailyIconNames.append(iconName)
            
            let localDate = day["date"].stringValue
            dailyDayNames.append(localDate)
            
            if iconName == "Partly Cloudy" {
                dailyImages.append(#imageLiteral(resourceName: "partly-cloudy-day"))
            } else if iconName == "Breezy" {
                dailyImages.append(#imageLiteral(resourceName: "partly-cloudy-night"))
            } else if iconName == "clear-day" {
                dailyImages.append(#imageLiteral(resourceName: "clear-day"))
            } else if iconName == "Scattered Showers" {
                dailyImages.append(#imageLiteral(resourceName: "rain"))
            } else if iconName == "Showers" {
                dailyImages.append(#imageLiteral(resourceName: "rain"))
            } else if iconName == "Mostly Cloudy" {
                dailyImages.append(#imageLiteral(resourceName: "cloudy"))
            } else {
                dailyImages.append(#imageLiteral(resourceName: "clear-day"))
            }
        }
        
        setUpLayout()
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func setUpLayout() {
        
        setupMainView()
        setupDailyWeatherTableView()
    }
    
    func setupMainView() {
        tempView = UIView(frame: CGRect(x: 0, y: 0, width: view.frame.width, height: view.frame.height * 0.3))
        
        tempLabel = UILabel(frame: CGRect(x: 0, y: 40, width: tempView.frame.width, height: tempView.frame.height * tempHeight))
        let font: UIFont? = UIFont(name: "Helvetica", size: 75)
        tempLabel.font = font
        tempLabel.textColor = UIColor.white
        tempLabel.textAlignment = .center
        tempLabel.numberOfLines = 1
        tempLabel.layer.shadowOffset = CGSize(width: 0, height: 0)
        tempLabel.layer.shadowOpacity = 0.5
        tempLabel.layer.shadowRadius = 20
        tempLabel.text = String(temp) + "°"
        
        cityLabel = UILabel(frame: CGRect(x: 0, y: tempLabel.frame.maxY, width: tempView.frame.width, height: tempView.frame.height * descHeight))
        cityLabel.text = cityName
        cityLabel.numberOfLines = 0
        cityLabel.textAlignment = .center
        cityLabel.textColor = UIColor.white
        cityLabel.font = UIFont.systemFont(ofSize: 18.0)
        
        tempView.addSubview(tempLabel)
        tempView.addSubview(cityLabel)
        view.addSubview(tempView)
    }
    
    func setupDailyWeatherTableView() {
        //Initialize TableView Object here
        dailyWeatherTableView = UITableView(frame: CGRect(x: 0, y: view.frame.height/3, width: view.frame.width, height: view.frame.height/1.65))
        
        //Register the tableViewCell you are using
        dailyWeatherTableView.register(DailyWeatherTableViewCell.self, forCellReuseIdentifier: "dailyWeatherCell")
        
        //Set properties of TableView
        dailyWeatherTableView.delegate = self
        dailyWeatherTableView.dataSource = self
        dailyWeatherTableView.rowHeight = 50
        //dailyWeatherTableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 50/2, right: 0)
        
        //Add tableView to view
        view.addSubview(dailyWeatherTableView)
        
    }
    
}

extension ViewController: UITableViewDataSource, UITableViewDelegate{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 7
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "dailyWeatherCell") as! DailyWeatherTableViewCell
        
        for subview in cell.contentView.subviews {
            subview.removeFromSuperview()
        }
        
        cell.awakeFromNib()
        cell.dayLabel.text = dailyDayNames[indexPath.row]
        cell.icon.image = dailyImages[indexPath.row]
        cell.highTemp.text = "H: " + String(dailyHighs[indexPath.row]) + "°"
        cell.lowTemp.text = "L: " + String(dailyLows[indexPath.row]) + "°"
        return cell
    }
    
}


extension UIColor {
    convenience init(hex: String) {
        let scanner = Scanner(string: hex)
        scanner.scanLocation = 0
        
        var rgbValue: UInt64 = 0
        
        scanner.scanHexInt64(&rgbValue)
        
        let r = (rgbValue & 0xff0000) >> 16
        let g = (rgbValue & 0xff00) >> 8
        let b = rgbValue & 0xff
        
        self.init(
            red: CGFloat(r) / 0xff,
            green: CGFloat(g) / 0xff,
            blue: CGFloat(b) / 0xff, alpha: 1
        )
    }
}

