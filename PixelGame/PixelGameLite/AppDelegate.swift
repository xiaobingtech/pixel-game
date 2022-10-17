//
//  AppDelegate.swift
//  PixelGameLite
//
//  Created by 韩云智 on 2022/10/17.
//

import UIKit
import GoogleMobileAds

let adOpenKey: String = "ca-app-pub-3940256099942544/5662855259"
let adBannerKey: String = "ca-app-pub-3940256099942544/2934735716"
let adRewardedKey: String = "ca-app-pub-3940256099942544/1712485313"

class AppDelegate: UIResponder, UIApplicationDelegate {
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        
        DispatchQueue(label: "gad").async {
            GADMobileAds.sharedInstance().start(completionHandler: nil)
            AppOpenAdManager.shared.loadAd()
        }
        
        
        return true
    }
}
