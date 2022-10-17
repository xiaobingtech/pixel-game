//
//  PixelGameLiteApp.swift
//  PixelGameLite
//
//  Created by 韩云智 on 2022/10/17.
//

import SwiftUI

extension UIApplication {
    static var keyWindow: UIWindow? {
        (UIApplication.shared.connectedScenes
            .filter { $0.activationState == .foregroundActive }
            .first { $0 is UIWindowScene } as? UIWindowScene)?.windows
            .first { $0.isKeyWindow }
    }
}

@main
struct PixelGameLiteApp: App {
    @UIApplicationDelegateAdaptor private var appDelegate: AppDelegate
    @Environment(\.scenePhase) var scenePhase
    
    var body: some Scene {
        WindowGroup {
            VStack(spacing: 0) {
                ContentView()
                    .frame(maxHeight: .infinity)
                let size = AdBanner.size
//                AdBanner()
//                    .frame(width: size.width, height: size.height)
            }
        }
        .onChange(of: scenePhase) { newValue in
            switch newValue {
            case .active: // 进入前台
                let rootViewController = UIApplication.keyWindow?.rootViewController
                if let rootViewController = rootViewController {
                    AppOpenAdManager.shared.showAdIfAvailable(viewController: rootViewController)
                }
            default:
                break
            }
        }
    }
}
