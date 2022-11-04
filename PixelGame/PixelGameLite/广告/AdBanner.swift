//
//  AdBanner.swift
//  PixelGameLite
//
//  Created by 韩云智 on 2022/10/17.
//

import SwiftUI
import GoogleMobileAds

struct AdBanner: UIViewControllerRepresentable {
    static var size: CGSize {
        GADCurrentOrientationAnchoredAdaptiveBannerAdSizeWithWidth(UIScreen.main.bounds.size.width).size
    }
    
    func makeUIViewController(context: Context) -> XS_AdBannerVC {
//        let uiViewController = UIViewController()
//        let bannerView = context.coordinator.bannerView
//        bannerView.translatesAutoresizingMaskIntoConstraints = false
//        bannerView.adUnitID = adBannerKey
//        bannerView.rootViewController = uiViewController
//        bannerView.isAutoloadEnabled = true
//        uiViewController.view = bannerView
//        return uiViewController
        XS_AdBannerVC()
    }
    func updateUIViewController(_ uiViewController: XS_AdBannerVC, context: Context) {
//        context.coordinator.bannerView.adSize = GADCurrentOrientationAnchoredAdaptiveBannerAdSizeWithWidth(UIScreen.main.bounds.size.width)
        uiViewController.adSize = GADCurrentOrientationAnchoredAdaptiveBannerAdSizeWithWidth(UIScreen.main.bounds.size.width)
    }
    
//    func makeCoordinator() -> Coordinator {
//        Coordinator(self)
//    }
//    class Coordinator: NSObject {
//        private let parent: AdBanner
//
//        lazy var bannerView = GADBannerView()
//
//        init(_ parent: AdBanner) {
//            self.parent = parent
//        }
//    }
}

class XS_AdBannerVC: UIViewController {
    lazy var adSize = GADCurrentOrientationAnchoredAdaptiveBannerAdSizeWithWidth(UIScreen.main.bounds.size.width) {
        didSet {
            for subView in view.subviews {
                if let subView = subView as? GADBannerView {
                    subView.adSize = adSize
                }
            }
        }
    }
    private var time: Int {
        1 + Int(arc4random()%5)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.clipsToBounds = true
        run()
    }
    
    private func run() {
        let banner = getBannerView()
        view.addSubview(banner)
        
        
    }
    private func getBannerView() -> GADBannerView {
        let bannerView = GADBannerView(adSize: adSize)
        bannerView.translatesAutoresizingMaskIntoConstraints = false
        bannerView.adUnitID = adBannerKey
        bannerView.rootViewController = self
        bannerView.isAutoloadEnabled = true
        bannerView.delegate = self
        return bannerView
    }
}

extension XS_AdBannerVC: GADBannerViewDelegate {
    func bannerView(_ bannerView: GADBannerView, didFailToReceiveAdWithError error: Error) {
        DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(time) + .seconds(20)) {
            self.run()
        }
    }
    func bannerViewDidReceiveAd(_ bannerView: GADBannerView) {
        let ani = CAKeyframeAnimation(keyPath: "transform.translation.y")
        ani.values = [-bannerView.bounds.size.height, 0]
        ani.duration = 0.25
        bannerView.layer.add(ani, forKey: nil)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(250)) {
            for subView in self.view.subviews {
                if subView !== bannerView {
                    subView.removeFromSuperview()
                }
            }
        }
    }
    func bannerViewDidRecordImpression(_ bannerView: GADBannerView) {
        DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(time)) {
            self.run()
        }
    }
}
