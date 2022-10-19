//
//  XS_Tools.swift
//  PixelGame
//
//  Created by 韩云智 on 2022/10/19.
//

import UIKit

extension UIApplication {
    static var keyWindow: UIWindow? {
        (UIApplication.shared.connectedScenes
            .filter { $0.activationState == .foregroundActive }
            .first { $0 is UIWindowScene } as? UIWindowScene)?.windows
            .first { $0.isKeyWindow }
    }
}
