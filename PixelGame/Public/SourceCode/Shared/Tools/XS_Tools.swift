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
    static let suffix = "xspg"
    static func safe<T>(_ data: T?) throws -> T {
        guard let data = data else { throw NSError() }
        return data
    }
    static private func key() throws -> SymmetricKey {
        let data = try safe(MD5(email).data(using: .utf8))
        let hash = SHA256.hash(data: data)
        return SymmetricKey(data: hash)
    }
    static func save(_ points: [[XS_Point]], name: String) -> Bool {
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
            let encoder = JSONEncoder()
            let data = try encoder.encode(points)
            let str = try safe(String(data: data, encoding: .utf8))
            let md5 = MD5(str+email)
            let file = XS_File(points: points, md5: md5, name: name, date: Date())
            let fileData = try encoder.encode(file)
            let encryptedContent = try ChaChaPoly.seal(fileData, using: key()).combined
            debugPrint(encryptedContent)
            
            let fileURL = URL(fileURLWithPath: filePath).appendingPathComponent(md5 + "." + suffix)
            try encryptedContent.write(to: fileURL)
            return true
        } catch let error {
            debugPrint(error.localizedDescription)
            return false
        }
    }
    static var getFiles: [XS_File]? {
        do {
            let fm = FileManager.default
            if fm.fileExists(atPath: filePath) {
                try fm.createDirectory(at: URL(fileURLWithPath: filePath), withIntermediateDirectories: true)
            }
            let arr = try fm.contentsOfDirectory(atPath: filePath)
            let key = try key()
            let decoder = JSONDecoder()
            let encoder = JSONEncoder()
            return arr.compactMap { str in
                guard str.hasSuffix("." + suffix), let encryptedContent = fm.contents(atPath: str) else { return nil }
                do {
                    let sealedBox = try ChaChaPoly.SealedBox(combined: encryptedContent)
                    let decryptedContent = try ChaChaPoly.open(sealedBox, using: key)
                    let file = try decoder.decode(XS_File.self, from: decryptedContent)
                    let data = try encoder.encode(file.points)
                    let str = try safe(String(data: data, encoding: .utf8))
                    let md5 = MD5(str+email)
                    if md5 == file.md5 {
                        return file
                    } else {
                        return nil
                    }
                } catch let error {
                    debugPrint(error.localizedDescription)
                    return nil
                }
            }
        } catch let error {
            debugPrint(error.localizedDescription)
            return nil
        }
    }
    
//    let newKey = try SymmetricKey(data: SHA256.hash(data: safe((email + md5).data(using: .utf8))))
//    let sealedBox = try ChaChaPoly.SealedBox(combined: encryptedContent)
//    let decryptedContent = try ChaChaPoly.open(sealedBox, using: newKey)
//    debugPrint(String(data: decryptedContent, encoding: .utf8))
//    // SealedBox的3个属性
//    let nonce = sealedBox.nonce
//    let ciphertext = sealedBox.ciphertext
//    let tag = sealedBox.tag
//
//    debugPrint(sealedBox.combined == nonce + ciphertext + tag)
}

struct XS_File: Equatable, Codable {
    let points: [[XS_Point]]
    let md5: String
    let name: String
    let date: Date
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
