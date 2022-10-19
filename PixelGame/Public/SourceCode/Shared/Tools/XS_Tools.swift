//
//  XS_Tools.swift
//  PixelGame
//
//  Created by 韩云智 on 2022/10/19.
//

import UIKit
import CommonCrypto

extension UIApplication {
    static var keyWindow: UIWindow? {
        (UIApplication.shared.connectedScenes
            .filter { $0.activationState == .foregroundActive }
            .first { $0 is UIWindowScene } as? UIWindowScene)?.windows
            .first { $0.isKeyWindow }
    }
}

extension String {
    var md5: String {
        const char *cStr = [str UTF8String];
            unsigned char result[16];
            CC_MD5(cStr, strlen(cStr), result); // This is the md5 call
            return [NSString stringWithFormat:
                    @"%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x",
                    result[0], result[1], result[2], result[3],
                    result[4], result[5], result[6], result[7],
                    result[8], result[9], result[10], result[11],
                    result[12], result[13], result[14], result[15]
                    ];
    }
}
