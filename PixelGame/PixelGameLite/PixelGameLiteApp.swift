//
//  PixelGameLiteApp.swift
//  PixelGameLite
//
//  Created by 韩云智 on 2022/10/17.
//

import SwiftUI

@main
struct PixelGameLiteApp: App {
    @UIApplicationDelegateAdaptor private var appDelegate: AppDelegate
    @Environment(\.scenePhase) var scenePhase
    
    var body: some Scene {
        WindowGroup {
            VStack(spacing: 0) {
                let size = AdBanner.size
                AdBanner()
                    .frame(minWidth: size.width, minHeight: size.height)
                    .background(Color.yellow)
                ContentView()
                    .frame(maxHeight: .infinity)
                    .background(Color.red)
            }
        }
        .onChange(of: scenePhase) { newValue in
            switch newValue {
            case .active: // 进入前台
                let rootViewController = UIApplication.shared.windows.first(where: { $0.isKeyWindow })?.rootViewController
                if let rootViewController = rootViewController {
                    AppOpenAdManager.shared.showAdIfAvailable(viewController: rootViewController)
                }
            default:
                break
            }
        }
    }
}
