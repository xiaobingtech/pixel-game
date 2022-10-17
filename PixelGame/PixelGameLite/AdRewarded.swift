//
//  AdRewarded.swift
//  PixelGameLite
//
//  Created by 韩云智 on 2022/10/17.
//

import GoogleMobileAds

struct AdRewarded {
    static func load(_ handler: @escaping () -> Void) {
        GADRewardedAd.load(
            withAdUnitID: adRewardedKey,
            request: GADRequest()
        ) { (ad, error) in
            if let error = error {
                debugPrint("Rewarded ad failed to load with error: \(error.localizedDescription)")
                return
            }
            debugPrint("Loading Succeeded")
            if let ad = ad, let rootViewController = UIApplication.shared.windows.first(where: { $0.isKeyWindow })?.rootViewController {
                ad.present(fromRootViewController: rootViewController) {
                    debugPrint("观看成功")
                    DispatchQueue.main.async {
                        handler()
                    }
                }
            }
        }
    }
}
