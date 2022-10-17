//
//  AdBanner.swift
//  PixelGameLite
//
//  Created by 韩云智 on 2022/10/17.
//

import SwiftUI
import GoogleMobileAds

extension UIView {
    func currentViewController() -> UIViewController? {
        var n = next
        while n != nil {
            if n is UIViewController {
                return n as? UIViewController
            }
            n = n?.next
        }
        return nil
    }
}

struct AdBanner: UIViewRepresentable {
    func makeUIView(context: Context) -> GADBannerView {
        let uiView = GADBannerView()
        uiView.translatesAutoresizingMaskIntoConstraints = false
        uiView.adUnitID = "ca-app-pub-3940256099942544/2934735716"
        return uiView
    }
    func updateUIView(_ uiView: GADBannerView, context: Context) {
        uiView.rootViewController = uiView.currentViewController()
        uiView.adSize = GADCurrentOrientationAnchoredAdaptiveBannerAdSizeWithWidth(UIScreen.main.bounds.size.width)
        uiView.load(GADRequest())
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    class Coordinator: NSObject {
        private let parent: AdBanner
        
        init(_ parent: AdBanner) {
            self.parent = parent
        }
    }
}
