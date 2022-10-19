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
            XS_Hud {
                VStack(spacing: 0) {
                    XS_Root()
                    let size = AdBanner.size
                    AdBanner()
                        .frame(width: size.width, height: size.height)
                }
            }
        }
        .onChange(of: scenePhase) { newValue in
            switch newValue {
            case .active: // 进入前台
                if let rootViewController = UIApplication.keyWindow?.rootViewController {
                    AppOpenAdManager.shared.showAdIfAvailable(viewController: rootViewController)
                }
            default:
                break
            }
        }
    }
}
