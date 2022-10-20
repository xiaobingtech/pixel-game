//
//  XS_Tools.swift
//  PixelGame
//
//  Created by 韩云智 on 2022/10/19.
//

import UIKit
import SwiftHash
import CryptoKit

extension UIApplication {
    static var keyWindow: UIWindow? {
        (UIApplication.shared.connectedScenes
            .filter { $0.activationState == .foregroundActive }
            .first { $0 is UIWindowScene } as? UIWindowScene)?.windows
            .first { $0.isKeyWindow }
    }
}

struct XS_Tools {
    static let filePath = NSHomeDirectory() + "/Library/XSSaves"
    static let email = "hanyzjob@163.com"
    static func safe<T>(_ data: T?) throws -> T {
        guard let data = data else { throw NSError() }
        return data
    }
    static func save(_ points: [[XS_Point]], handle: (Bool) -> Void) {
        let points = points.map {
            $0.sorted {
                if $0.position.x == $1.position.x {
                    return $0.position.y < $1.position.y
                } else {
                    return $0.position.x < $1.position.x
                }
            }
        }
        do {
            let data = try JSONEncoder().encode(points)
            let str = try safe(String(data: data, encoding: .utf8))
            let md5 = MD5(str)
            var myData = data
            myData.count = 256
            let key = SymmetricKey(data: myData)
            
            
            let encryptedContent = try ChaChaPoly.seal(data, using: key).combined
            debugPrint(encryptedContent)
            
            
            let sealedBox = try ChaChaPoly.SealedBox(combined: encryptedContent)
            let decryptedContent = try ChaChaPoly.open(sealedBox, using: key)
            debugPrint(String(data: decryptedContent, encoding: .utf8))
            // SealedBox的3个属性
            let nonce = sealedBox.nonce
            let ciphertext = sealedBox.ciphertext
            let tag = sealedBox.tag
            
            debugPrint(sealedBox.combined == nonce + ciphertext + tag)
                    

        } catch let error {
            debugPrint(error.localizedDescription)
            handle(false)
        }
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
