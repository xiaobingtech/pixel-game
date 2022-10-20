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

struct XS_Tools {
    static func save(_ points: [[XS_Point]]) {
        print(points)
        let points = points.map { $0.sorted { $0.position.x > $1.position.x && $0.position.y > $1.position.y } }
        print(points)
    }
}
//产生公/私钥
//
//// 私钥
//let privateKey = Curve25519.Signing.PrivateKey()
//// 公钥
//let publicKey = privateKey.publicKey
//// 发布公钥
//let publicKeyData = publicKey.rawRepresentation
//
//私钥签名
//
//let str = "Hello CryptoKit"
//let data = str.data(using: .utf8)!
//
//let signature = try? privateKey.signature(for: data)
//
//公钥验证
//
//if let signature = signature {
//    if publicKey.isValidSignature(NSData(data: signature) , for: data) {
//        print("签名有效")
//    }
//}
