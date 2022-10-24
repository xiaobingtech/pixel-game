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
//            .filter { $0.activationState == .foregroundActive }
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
    static private func sorted(points: [[XS_Point]]) -> [[XS_Point]] {
        points.map {
            $0.sorted {
                if $0.position.x == $1.position.x {
                    return $0.position.y < $1.position.y
                } else {
                    return $0.position.x < $1.position.x
                }
            }
        }
//        let position = points.reduce(CGPoint.zero) { result, points in
//            let point = points.reduce(CGPoint.zero) { result, point in
//                CGPoint(x: min(result.x, point.position.x), y: min(result.y, point.position.y))
//            }
//            return CGPoint(x: min(result.x, point.x), y: min(result.y, point.y))
//        }
//        return points.map {
//            $0.map { point in
//                XS_Point(
//                    position: CGPoint(
//                        x: point.position.x - position.x,
//                        y: point.position.y - position.y
//                    ),
//                    color: point.color
//                )
//            }
//            .sorted {
//                if $0.position.x == $1.position.x {
//                    return $0.position.y < $1.position.y
//                } else {
//                    return $0.position.x < $1.position.x
//                }
//            }
//        }
    }
    static func save(_ points: [[XS_Point]], name: String? = nil) -> String? {
//        if points.first(where: { !$0.isEmpty }) == nil { return nil }
        if points == [[]] { return nil }
        let points = sorted(points: points)
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
//            let encoder = JSONEncoder()
            return arr.compactMap { str in
                guard str.hasSuffix("." + suffix), let encryptedContent = fm.contents(atPath: filePath + "/" + str) else { return nil }
                do {
                    let sealedBox = try ChaChaPoly.SealedBox(combined: encryptedContent)
                    let decryptedContent = try ChaChaPoly.open(sealedBox, using: key)
                    let file = try decoder.decode(XS_File.self, from: decryptedContent)
                    return file
//                    let data = try encoder.encode(file.points)
//                    let str = try safe(String(data: data, encoding: .utf8))
//                    let md5 = MD5(str+email)
//                    if md5 == file.md5 {
//                        return file
//                    } else {
//                        return nil
//                    }
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
        let points = sorted(points: points)
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
    static func openShareFile(_ url: URL, handle: @escaping (XS_File) -> Void) -> Bool {
        guard url.lastPathComponent.hasSuffix("." + suffix), let encryptedContent = FileManager.default.contents(atPath: url.path) else { return false }
        do {
            let sealedBox = try ChaChaPoly.SealedBox(combined: encryptedContent)
            let decryptedContent = try ChaChaPoly.open(sealedBox, using: key())
            let file = try JSONDecoder().decode(XS_File.self, from: decryptedContent)
            let data = try JSONEncoder().encode(file.points)
            let str = try safe(String(data: data, encoding: .utf8))
            let md5 = MD5(str+email)
            if md5 == file.md5 {
                let vc = UIAlertController(title: "来自分享", message: "是否打开「\(file.name)」", preferredStyle: .alert)
                vc.addAction(UIAlertAction(title: "Cancel", style: .cancel))
                vc.addAction(
                    UIAlertAction(title: "Open", style: .destructive) { action in
                        handle(file)
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
    
    static func editName(_ file: XS_File, finish: @escaping () -> Void) {
        let vc = UIAlertController(title: "编辑名称", message: nil, preferredStyle: .alert)
        
        vc.addTextField { textField in
            textField.placeholder = file.name
        }
        vc.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        vc.addAction(
            UIAlertAction(title: "Save", style: .destructive) { [weak vc] action in
                guard let name = vc?.textFields?.first?.text, !name.isEmpty else { return }
                var file = file
                file.name = name
                
                do {
                    let fileURL = URL(fileURLWithPath: filePath)
                    let fileName = file.md5 + "." + suffix
                    let fm = FileManager.default
                    if !fm.fileExists(atPath: filePath) {
                        try fm.createDirectory(at: fileURL, withIntermediateDirectories: true)
                    }
                    
                    let fileData = try JSONEncoder().encode(file)
                    let encryptedContent = try ChaChaPoly.seal(fileData, using: key()).combined
                    debugPrint(encryptedContent)
                    try encryptedContent.write(to: fileURL.appendingPathComponent(fileName))
                    
                    finish()
                } catch let error {
                    debugPrint(error.localizedDescription)
                }
            }
        )
        UIApplication.keyWindow?.rootViewController?.present(vc, animated: true)
    }
    
    static func delete(file: XS_File, finish: @escaping () -> Void) {
        let vc = UIAlertController(title: "删除模型", message: "删除后将无法恢复!", preferredStyle: .alert)
        
        vc.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        vc.addAction(
            UIAlertAction(title: "Delete", style: .destructive) { action in
                do {
                    let fileURL = URL(fileURLWithPath: filePath)
                    let fileName = file.md5 + "." + suffix
                    try FileManager.default.removeItem(at: fileURL.appendingPathComponent(fileName))
                    finish()
                } catch let error {
                    debugPrint(error.localizedDescription)
                }
            }
        )
        UIApplication.keyWindow?.rootViewController?.present(vc, animated: true)
    }
    static func delete(all: @escaping () -> Void, current: @escaping () -> Void) {
        let vc = UIAlertController(title: "清除", message: "「All」清除全部\n「Current」清除当前层", preferredStyle: .alert)
        
        vc.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        vc.addAction(
            UIAlertAction(title: "All", style: .destructive) { action in
                all()
            }
        )
        vc.addAction(
            UIAlertAction(title: "Current", style: .destructive) { action in
                current()
            }
        )
        UIApplication.keyWindow?.rootViewController?.present(vc, animated: true)
    }
}

struct XS_File: Equatable, Codable, Hashable {
    let points: [[XS_Point]]
    let md5: String
    var name: String
    let date: Date
    func hash(into hasher: inout Hasher) {
        hasher.combine(md5)
        hasher.combine(name)
    }
}
