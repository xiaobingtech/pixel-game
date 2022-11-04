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
    
    func makeUIViewController(context: Context) -> XS_AdBanner {
//        let uiViewController = UIViewController()
//        let bannerView = context.coordinator.bannerView
//        bannerView.translatesAutoresizingMaskIntoConstraints = false
//        bannerView.adUnitID = adBannerKey
//        bannerView.rootViewController = uiViewController
//        bannerView.isAutoloadEnabled = true
//        uiViewController.view = bannerView
//        return uiViewController
        XS_AdBanner()
    }
    func updateUIViewController(_ uiViewController: XS_AdBanner, context: Context) {
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

class XS_AdBanner: UIViewController {
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
        5 + Int(arc4random()%10)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.clipsToBounds = true
        run()
    }
    
    private func run() {
        let banner = getBannerView()
        view.addSubview(banner)
        let ani = CAKeyframeAnimation(keyPath: "transform.translation.y")
        ani.values = [-banner.bounds.size.height, 0]
        ani.duration = 0.25
        banner.layer.add(ani, forKey: nil)
        
        let deadline: DispatchTime = .now() + .milliseconds(250)
        DispatchQueue.main.asyncAfter(deadline: deadline) {
            for subView in self.view.subviews {
                if subView !== banner {
                    subView.removeFromSuperview()
                }
            }
        }
        DispatchQueue.main.asyncAfter(deadline: deadline + .seconds(time)) {
            self.run()
        }
    }
    private func getBannerView() -> GADBannerView {
        let bannerView = GADBannerView(adSize: adSize)
        bannerView.translatesAutoresizingMaskIntoConstraints = false
        bannerView.adUnitID = adBannerKey
        bannerView.rootViewController = self
        bannerView.isAutoloadEnabled = true
        return bannerView
    }
}
