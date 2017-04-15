//
//  AppDelegate.swift
//  WeatherTestYahoo
//
//  Created by punit on 4/11/17.
//  Copyright © 2017 punit. All rights reserved.
//

import UIKit
import CoreLocation
import Alamofire

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    let myNotificationKey = "com.devs.notificationKey"


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        
        let todoEndpoint: String = "https://query.yahooapis.com/v1/public/yql?q=select%20*%20from%20weather.forecast%20where%20woeid%20in%20(select%20woeid%20from%20geo.places(1)%20where%20text%3D%22chicago%22)&format=json&env=store%3A%2F%2Fdatatables.org%2Falltableswithkeys"
        
        Alamofire.request(todoEndpoint)
            .responseString { response in
                
                let data: NSData = response.result.value!.data(using: String.Encoding.utf8)! as NSData
                var json: [String: Any]? = nil
                
                do {
                    json = try (JSONSerialization.jsonObject(with: data as Data) as? [String: Any])!
                    
                    
                }catch let error as NSError {
                    print(error)
                }
                
                NotificationCenter.default.post(name: NSNotification.Name(rawValue: self.myNotificationKey), object: nil, userInfo: json)
        }
        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }


}

