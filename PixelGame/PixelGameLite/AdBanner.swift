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
    
    func makeUIViewController(context: Context) -> some UIViewController {
        let uiViewController = UIViewController()
        let bannerView = context.coordinator.bannerView
        bannerView.translatesAutoresizingMaskIntoConstraints = false
        bannerView.adUnitID = adBannerKey
        bannerView.rootViewController = UIApplication.keyWindow?.rootViewController
        uiViewController.view = bannerView
        return uiViewController
    }
    func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) {
        context.coordinator.bannerView.adSize = GADCurrentOrientationAnchoredAdaptiveBannerAdSizeWithWidth(UIScreen.main.bounds.size.width)
        context.coordinator.bannerView.load(GADRequest())
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    class Coordinator: NSObject {
        private let parent: AdBanner
        
        lazy var bannerView = GADBannerView()
        
        init(_ parent: AdBanner) {
            self.parent = parent
        }
    }
}
