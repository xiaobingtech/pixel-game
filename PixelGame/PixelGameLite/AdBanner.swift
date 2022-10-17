//
//  AdBanner.swift
//  PixelGameLite
//
//  Created by 韩云智 on 2022/10/17.
//

import SwiftUI
import GoogleMobileAds

struct AdBanner: UIViewControllerRepresentable {
    func makeUIViewController(context: Context) -> some UIViewController {
        let uiViewController = UIViewController()
        let view = uiViewController.view!
        let bannerView = context.coordinator.bannerView
        bannerView.translatesAutoresizingMaskIntoConstraints = false
        bannerView.adUnitID = "ca-app-pub-3940256099942544/2934735716"
        bannerView.rootViewController = uiViewController
        view.addSubview(bannerView)
        let adSize = GADCurrentOrientationAnchoredAdaptiveBannerAdSizeWithWidth(UIScreen.main.bounds.size.width)
        uiViewController.view.frame = CGRect(origin: .zero, size: adSize.size)
        context.coordinator.bannerView.adSize = adSize
        return uiViewController
    }
    func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) {
        
        context.coordinator.bannerView.load(GADRequest())
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    class Coordinator: NSObject {
        private let parent: AdBanner
        
        lazy var bannerView = GADBannerView(adSize: GADAdSizeBanner)
        
        init(_ parent: AdBanner) {
            self.parent = parent
        }
    }
}
