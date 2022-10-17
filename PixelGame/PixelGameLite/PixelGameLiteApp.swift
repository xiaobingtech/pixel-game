//
//  PixelGameLiteApp.swift
//  PixelGameLite
//
//  Created by 韩云智 on 2022/10/17.
//

import SwiftUI

var rootVC: UIViewController?

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
                AdBanner()
                    .frame(width: size.width, height: size.height)
            }
            .background(MyView())
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

struct MyView: UIViewRepresentable {
    func makeUIView(context: Context) -> some UIView {
        UIView()
    }
    func updateUIView(_ uiView: UIViewType, context: Context) {
        if uiView.superview != nil {
            var n = uiView.next
            while n != nil {
                if let n = n, n.isKind(of: UIViewController.self) {
                    rootVC = n as? UIViewController
                    return
                }
                n = n?.next
            }
        }
    }
}
