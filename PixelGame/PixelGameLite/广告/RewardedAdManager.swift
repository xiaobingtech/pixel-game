//
//  AppRewardedAdManager.swift
//  PixelGameLite
//
//  Created by 韩云智 on 2022/10/17.
//

import GoogleMobileAds

class RewardedAdManager: NSObject {
    var rewardedAd: GADRewardedAd?
    var handler: ((Bool) -> Void)?
    var canShare: ((Bool) -> Void)?
    
    let timeoutInterval: TimeInterval = 4 * 3_600
    var isLoadingAd = false
    var isShowingAd = false
    var loadTime: Date?
    
    static let shared = RewardedAdManager()
    
    private func wasLoadTimeLessThanNHoursAgo(timeoutInterval: TimeInterval) -> Bool {
        // Check if ad was loaded more than n hours ago.
        if let loadTime = loadTime {
            return Date().timeIntervalSince(loadTime) < timeoutInterval
        }
        return false
    }
    
    private func isAdAvailable() -> Bool {
        // Check if ad exists and can be shown.
        return rewardedAd != nil && wasLoadTimeLessThanNHoursAgo(timeoutInterval: timeoutInterval)
    }
    
    func loadAd() {
        // Do not load ad if there is an unused ad or one is already loading.
        if isLoadingAd || isAdAvailable() {
            return
        }
        isLoadingAd = true
        debugPrint("Start loading app open ad.")
        GADRewardedAd.load(
            withAdUnitID: adRewardedKey,
            request: GADRequest()
        ) { (ad, error) in
            self.isLoadingAd = false
            if let error = error {
                self.rewardedAd = nil
                self.loadTime = nil
                debugPrint("Rewarded ad failed to load with error: \(error.localizedDescription)")
                if let handler = self.handler {
                    self.handler = nil
                    if (error as NSError).code == 5 {
                        self.canShare = handler
                    } else {
                        handler(false)
                    }
                }
                return
            }
            debugPrint("Loading Succeeded")
            self.rewardedAd = ad
            self.rewardedAd?.fullScreenContentDelegate = self
            self.loadTime = Date()
            if let handler = self.handler {
                self.handler = nil
                self.showAdIfAvailable(handler)
            }
        }
    }
    
    func showAdIfAvailable(_ handler: @escaping (Bool) -> Void) {
        // If the app open ad is already showing, do not show the ad again.
        if isShowingAd {
            debugPrint("App open ad is already showing.")
            return
        }
        // If the app open ad is not available yet but it is supposed to show,
        // it is considered to be complete in this example. Call the appOpenAdManagerAdDidComplete
        // method and load a new ad.
        if !isAdAvailable() {
            debugPrint("App open ad is not ready yet.")
            self.handler = handler
            loadAd()
            return
        }
        if let ad = rewardedAd, let rootViewController = UIApplication.keyWindow?.rootViewController {
            debugPrint("App open ad will be displayed.")
            isShowingAd = true
            ad.present(fromRootViewController: rootViewController) {
                self.canShare = handler
            }
        }
    }
}

extension RewardedAdManager: GADFullScreenContentDelegate {
    func adWillPresentFullScreenContent(_ ad: GADFullScreenPresentingAd) {
        debugPrint("App open ad is will be presented.")
    }
    
    func adDidDismissFullScreenContent(_ ad: GADFullScreenPresentingAd) {
        rewardedAd = nil
        isShowingAd = false
        debugPrint("App open ad was dismissed.")
        loadAd()
        if let handler = canShare {
            canShare = nil
            DispatchQueue.main.async {
                handler(true)
            }
        }
    }
    
    func ad(
        _ ad: GADFullScreenPresentingAd,
        didFailToPresentFullScreenContentWithError error: Error
    ) {
        rewardedAd = nil
        isShowingAd = false
        debugPrint("App open ad failed to present with error: \(error.localizedDescription).")
        loadAd()
    }
}
