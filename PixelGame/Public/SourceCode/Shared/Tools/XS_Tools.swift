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
    static func save(_ points: [[XS_Point]], name: String? = nil) -> String? {
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
            
            let fileURL = URL(fileURLWithPath: filePath)
            let fileName = md5 + "." + suffix
            let fm = FileManager.default
            if !fm.fileExists(atPath: filePath) {
                try fm.createDirectory(at: fileURL, withIntermediateDirectories: true)
            }
            
            let arr = try fm.contentsOfDirectory(atPath: filePath)
            if arr.contains(fileName) {
                return md5
            }
            
            let name = name ?? {
                let df = DateFormatter()
                df.dateFormat = "yyyy-MM-dd HH:mm"
                return df.string(from: Date())
            }()
            let file = XS_File(points: points, md5: md5, name: name, date: Date())
            let fileData = try encoder.encode(file)
            let encryptedContent = try ChaChaPoly.seal(fileData, using: key()).combined
            debugPrint(encryptedContent)
            try encryptedContent.write(to: fileURL.appendingPathComponent(fileName))
            return md5
        } catch let error {
            debugPrint(error.localizedDescription)
            return nil
        }
    }
    static var getFiles: [XS_File]? {
        do {
            let fm = FileManager.default
            if !fm.fileExists(atPath: filePath) {
                try fm.createDirectory(at: URL(fileURLWithPath: filePath), withIntermediateDirectories: true)
            }
            let arr = try fm.contentsOfDirectory(atPath: filePath)
            let key = try key()
            let decoder = JSONDecoder()
            let encoder = JSONEncoder()
            return arr.compactMap { str in
                guard str.hasSuffix("." + suffix), let encryptedContent = fm.contents(atPath: filePath + "/" + str) else { return nil }
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
    
    static func share(_ points: [[XS_Point]]) -> Bool {
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
            
            let df = DateFormatter()
            df.dateFormat = "yyyy-MM-dd HH:mm"
            let name = df.string(from: Date())
            let file = XS_File(points: points, md5: md5, name: name, date: Date())
            
            return share(file: file)
        } catch let error {
            debugPrint(error.localizedDescription)
            return false
        }
    }
    static func share(file: XS_File) -> Bool {
        do {
            let fileName = file.name + "." + suffix
            let fileURL = URL(fileURLWithPath: NSTemporaryDirectory()).appendingPathComponent(fileName)
            let fileData = try JSONEncoder().encode(file)
            let encryptedContent = try ChaChaPoly.seal(fileData, using: key()).combined
            debugPrint(encryptedContent)
            try encryptedContent.write(to: fileURL)
            
            let activityVC = UIActivityViewController(activityItems: [fileURL], applicationActivities: nil)
//            activityVC.completionWithItemsHandler = { type, completed, item, error in
//
//            }
            UIApplication.keyWindow?.rootViewController?.present(activityVC, animated: true)
            return true
        } catch let error {
            debugPrint(error.localizedDescription)
            return false
        }
    }
    static func showShareFile(_ url: URL, toast: @escaping (String?) -> Void) -> Bool {
        guard url.lastPathComponent.hasSuffix("." + suffix), let encryptedContent = FileManager.default.contents(atPath: url.path) else { return false }
        do {
            let sealedBox = try ChaChaPoly.SealedBox(combined: encryptedContent)
            let decryptedContent = try ChaChaPoly.open(sealedBox, using: key())
            let file = try JSONDecoder().decode(XS_File.self, from: decryptedContent)
            let data = try JSONEncoder().encode(file.points)
            let str = try safe(String(data: data, encoding: .utf8))
            let md5 = MD5(str+email)
            if md5 == file.md5 {
                let vc = UIAlertController(title: "保存像素模型文件", message: "接收到来自分享的「\(file.name), 是否保存」", preferredStyle: .alert)
                vc.addAction(UIAlertAction(title: "Cancel", style: .cancel))
                vc.addAction(
                    UIAlertAction(title: "Save", style: .default) { action in
                        toast(save(file.points, name: file.name))
                    }
                )
                UIApplication.keyWindow?.rootViewController?.present(vc, animated: true)
                return true
            } else {
                return false
            }
        } catch let error {
            debugPrint(error.localizedDescription)
            return false
        }
    }
}

struct XS_File: Equatable, Codable, Hashable {
    let points: [[XS_Point]]
    let md5: String
    let name: String
    let date: Date
    func hash(into hasher: inout Hasher) {
        hasher.combine(md5)
        hasher.combine(name)
    }
}
