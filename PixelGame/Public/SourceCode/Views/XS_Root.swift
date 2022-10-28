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
    @State private var isOthers: Bool = false
    
//    @SceneStorage("points") private var data: Data?
    @AppStorage("xs_points") private var data: Data?
    @AppStorage("xs_options") private var optionsData: Data?
    
#if isLite
    @State private var canSave: Bool = false
    @State private var canShare: Bool = false
    
    private var save: some View {
        Button {
            if points == [[]] {
                xs_hud.showToast("没有保存内容!")
                return
            }
            if canSave {
                if let _ = XS_Tools.save(points) {
                    canSave = false
                    xs_hud.showToast("保存成功!")
                } else {
                    xs_hud.showToast("保存失败!")
                }
            } else {
                RewardedAdManager.shared.showAdIfAvailable { success in
                    if success {
                        if let _ = XS_Tools.save(points) {
                            canSave = false
                            xs_hud.showToast("保存成功!")
                        } else {
                            canSave = true
                            xs_hud.showToast("保存失败!")
                        }
                    } else {
                        xs_hud.showToast("调取错误!")
                    }
                }
            }
        } label: {
            Text(canSave ? "Save" : "Save (AD)")
            Image(systemName: "arrow.down.to.line.circle.fill")
        }
    }
    private var share: some View {
        Button {
            if points == [[]] {
                xs_hud.showToast("没有分享内容!")
                return
            }
            if canShare {
                if XS_Tools.share(points) {
                    canShare = false
                } else {
                    xs_hud.showToast("分享失败!")
                }
            } else {
                RewardedAdManager.shared.showAdIfAvailable { success in
                    if success {
                        if !XS_Tools.share(points) {
                            canSave = true
                            xs_hud.showToast("分享失败!")
                        }
                    } else {
                        xs_hud.showToast("调取错误!")
                    }
                }
            }
        } label: {
            Text(canShare ? "Share": "Share (AD)")
            Image(systemName: "paperplane.circle.fill")
        }
    }
#else
    private var save: some View {
        Button {
            if points == [[]] {
                xs_hud.showToast("没有保存内容!")
                return
            }
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
            if points == [[]] {
                xs_hud.showToast("没有分享内容!")
                return
            }
            if XS_Tools.share(points) {
                
            } else {
                xs_hud.showToast("分享失败!")
            }
        } label: {
            Text("Share")
            Image(systemName: "paperplane.circle.fill")
        }
    }
#endif
    
    private var open: some View {
        Button {
            isOpen = true
        } label: {
            Text("Open")
            Image(systemName: "folder.circle.fill")
        }
    }
    private var delete: some View {
        Button {
            XS_Tools.delete {
                points = [[]]
                options.current = 0
                options.offset = .zero
                options.isClear = false
            } current: {
                if points.count > options.current {
                    points[options.current] = []
                }
            }
        } label: {
            Text("Delete")
            Image(systemName: "trash.circle.fill")
        }
    }
    private var others: some View {
        Button {
            isOthers = true
        } label: {
            Text("Others")
            Image(systemName: "exclamationmark.circle.fill")
        }
    }
    
    private var menu: some View {
        HStack {
            ColorPicker("", selection: isPreview ? $bgColor : $color, supportsOpacity: true)
                .labelsHidden()
                .scaleEffect(1.35)
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
                others
            } label: {
                Image(systemName: "ellipsis.circle")
            }
        }
        .font(.largeTitle)
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
                XS_Open(color: bgColor, isOpen: $isOpen, handle: openFile(_:))
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .background(Color(uiColor: .systemBackground).ignoresSafeArea())
                    .transition(.opacity.animation(.easeInOut))
            }
            if isOthers {
                XS_Others(isOthers: $isOthers, options: $options)
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .background(Color(uiColor: .systemBackground).ignoresSafeArea())
                    .transition(.opacity.animation(.easeInOut))
            }
        }
        .onOpenURL { url in
            debugPrint(url)
            if let vc = UIApplication.keyWindow?.rootViewController?.presentedViewController, vc is UIActivityViewController {
                vc.dismiss(animated: true) {
                    openShareFile(url)
                }
            } else {
                openShareFile(url)
            }
        }
        .task {
            do {
                if let data = data {
                    points = try JSONDecoder().decode([[XS_Point]].self, from: data)
                }
                if let data = optionsData {
                    options = try JSONDecoder().decode(XS_Options.self, from: data)
                }
            } catch let error {
                debugPrint(error.localizedDescription)
            }
        }
        .onChange(of: points) { newValue in
            do {
                data = try JSONEncoder().encode(newValue)
            } catch let error {
                debugPrint(error.localizedDescription)
            }
        }
        .onChange(of: options) { newValue in
            do {
                optionsData = try JSONEncoder().encode(newValue)
            } catch let error {
                debugPrint(error.localizedDescription)
            }
        }
    }
    private func openShareFile(_ url: URL) {
        if !XS_Tools.openShareFile(url, handle: openFile(_:)) {
            xs_hud.showToast("文件无法识别!")
        }
    }
    private func openFile(_ file: XS_File) {
        points = file.points
        options.current = 0
        options.offset = .zero
        options.isClear = false
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

struct XS_Options: Codable, Equatable {
    var current: Int = 0
    var offset: CGPoint = .zero
    var hasMap: Bool = true
    var has3DMap: Bool = true
    
    enum CodingKeys: String, CodingKey {
    case current, count, offset, hasMap, has3DMap
    }
    
    var isClear: Bool = false
    
    var count: Int = 10
    var countSlider: Double {
        get {
            switch count {
            case 5: return 0
            case 20: return 2
            case 30: return 3
            case 50: return 4
            case 70: return 5
            default: return 1
            }
        }
        set {
            offset = .zero
            switch newValue {
            case 0: count = 5
            case 2: count = 20
            case 3: count = 30
            case 4: count = 50
            case 5: count = 70
            default: count = 10
            }
        }
    }
}

struct XS_Root_Previews: PreviewProvider {
    static var previews: some View {
        XS_Hud {
            XS_Root()
        }
    }
}
