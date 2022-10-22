//
//  XS_Root.swift
//  PixelGame
//
//  Created by 韩云智 on 2022/10/17.
//

import SwiftUI

struct XS_Root: View {
    @Environment(\.xs_hud) private var xs_hud
    
    @State private var isPreview: Bool = false
    @State private var points: [[XS_Point]] = [[]]
    @State private var options: XS_Options = .init()
    @State private var color: CGColor = UIColor.black.cgColor
    @State private var bgColor: CGColor = UIColor.white.cgColor
    
    @State private var isOpen: Bool = false
    
    private var open: some View {
        Button {
            isOpen = true
        } label: {
            Text("Open")
            Image(systemName: "folder.circle.fill")
        }
    }
    private var save: some View {
        Button {
            if let _ = XS_Tools.save(points) {
                xs_hud.showToast("保存成功!")
            } else {
                xs_hud.showToast("保存失败!")
            }
        } label: {
            Text("Save")
            Image(systemName: "arrow.down.to.line.circle.fill")
        }
    }
    private var share: some View {
        Button {
            if XS_Tools.share(points) {
                
            } else {
                xs_hud.showToast("分享失败!")
            }
        } label: {
            Text("Share")
            Image(systemName: "paperplane.circle.fill")
        }
    }
    private var delete: some View {
        Button {
            
        } label: {
            Text("Delete")
            Image(systemName: "trash.circle.fill")
        }
    }
    private var about: some View {
        Button {
            
        } label: {
            Text("Others")
            Image(systemName: "exclamationmark.circle.fill")
        }
    }
    
    private var menu: some View {
        HStack {
            ColorPicker("", selection: isPreview ? $bgColor : $color, supportsOpacity: true)
                .labelsHidden()
            if !isPreview {
                Button {
                    options.isClear.toggle()
                } label: {
                    Image(
                        systemName: options.isClear
                        ? "pencil.slash"
                        : "pencil.circle"
                    )
                }
            }
            
            Spacer()
            Button {
                isPreview.toggle()
            } label: {
                Image(
                    systemName: isPreview
                    ? "arrow.uturn.backward.circle"
                    : "play.circle"
                )
            }
            Menu {
                share
                save
                open
                delete
                about
            } label: {
                Image(systemName: "ellipsis.circle")
            }
        }
        .font(.title2)
        .foregroundColor(Color(uiColor: .label))
        .padding(.horizontal)
        .padding(.vertical, 5)
    }
    
    var body: some View {
        ZStack(alignment: .top) {
            if isPreview {
                XS_Preview(color: bgColor, points: points)
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
            }
            VStack {
                menu.shadow(color: Color(uiColor: .systemBackground), radius: 1)
                if !isPreview {
                    XS_Grid(color: color, points: $points, options: $options)
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                }
            }
            if isOpen {
                XS_Open(color: bgColor, isOpen: $isOpen, points: $points)
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .background(Color(uiColor: .systemBackground).ignoresSafeArea())
                    .transition(.opacity.animation(.easeInOut))
            }
        }
        .onOpenURL { url in
            debugPrint(url)
            if let vc = UIApplication.keyWindow?.rootViewController?.presentedViewController, vc is UIActivityViewController {
                vc.dismiss(animated: true) {
                    showShareFile(url)
                }
            } else {
                showShareFile(url)
            }
        }
    }
    private func showShareFile(_ url: URL) {
        let set = XS_Tools.showShareFile(url) { md5 in
            if let _ = md5 {
                xs_hud.showToast("保存成功!")
            } else {
                xs_hud.showToast("保存失败!")
            }
        }
        if !set {
            xs_hud.showToast("文件无法识别!")
        }
    }
}

struct XS_Point: Equatable, Codable {
    let position: CGPoint
    var color: CGColor
    
    init(position: CGPoint, color: CGColor) {
        self.position = position
        self.color = color
    }
    
    enum CodingKeys: String, CodingKey {
    case position, color
    }
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        position = try container.decode(CGPoint.self, forKey: .position)
        let colorData = try container.decode(Data.self, forKey: .color)
        color = try NSKeyedUnarchiver.unarchivedObject(ofClass: UIColor.self, from: colorData)!.cgColor
    }
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(position, forKey: .position)
        let colorData = try NSKeyedArchiver.archivedData(withRootObject: UIColor(cgColor: color), requiringSecureCoding: false)
        try container.encode(colorData, forKey: .color)
    }
}

struct XS_Options: Equatable {
    var current: Int = 0
    var count: Int = 10
    var offset: CGPoint = .zero
    var isClear: Bool = false
}

struct XS_Root_Previews: PreviewProvider {
    static var previews: some View {
        XS_Hud {
            XS_Root()
        }
    }
}
