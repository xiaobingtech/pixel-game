//
//  AppDelegate.swift
//  PixelGameLite
//
//  Created by 韩云智 on 2022/10/17.
//

import UIKit
import GoogleMobileAds

#if DEBUG
let adOpenKey: String = "ca-app-pub-3940256099942544/5662855259"
let adBannerKey: String = "ca-app-pub-3940256099942544/2934735716"
let adRewardedKey: String = "ca-app-pub-3940256099942544/1712485313"
#else
let adOpenKey: String = "ca-app-pub-4004775535101264/7725948447"
let adBannerKey: String = "ca-app-pub-3940256099942544/2934735716"
let adRewardedKey: String = "ca-app-pub-3940256099942544/1712485313"
#endif

class AppDelegate: UIResponder, UIApplicationDelegate {
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        
        GADMobileAds.sharedInstance().start(completionHandler: nil)
        AppOpenAdManager.shared.loadAd()
        
        return true
    }
}
