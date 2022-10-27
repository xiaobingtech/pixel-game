//
//  XS_Others.swift
//  PixelGame
//
//  Created by 韩云智 on 2022/10/27.
//

import SwiftUI

struct XS_Others: View {
    @Binding var isOthers: Bool
    @Binding var options: XS_Options
    
    @State private var sl: Double = 0
    
    private var count: some View {
        Slider(value: $sl) {
            Text("\(sl)")
        } minimumValueLabel: {
            Text("1")
        } maximumValueLabel: {
            Text("5")
        }

    }
    private var map: some View {
        Toggle("当前平面预览", isOn: $options.hasMap)
            .foregroundColor(Color(uiColor: .label))
            .frame(height: 50)
    }
    private var map3d: some View {
        Toggle("整体三维预览", isOn: $options.has3DMap)
            .foregroundColor(Color(uiColor: .label))
            .frame(height: 50)
    }
#if isLite
    private var jump: some View {
        Button {
            guard let url = URL(string: "https://apps.apple.com/cn/app/id6443961966"), UIApplication.shared.canOpenURL(url) else { return }
            UIApplication.shared.open(url)
        } label: {
            HStack {
                Text("下载免广告版")
                Spacer()
                Image(systemName: "chevron.right")
            }
            .foregroundColor(Color(uiColor: .label))
            .frame(height: 50)
        }
    }
#endif
    
    var body: some View {
        ZStack(alignment: .topTrailing) {
            ScrollView(.vertical, showsIndicators: false) {
                VStack {
                    if let version = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String {
                        (
                            Text("v").font(.body)
                            +
                            Text(version).font(.title)
                        )
                        .padding(50)
                    }
                    VStack(spacing: 0) {
                        count
                        Divider()
                        map
                        Divider()
                        map3d
#if isLite
                        Divider()
                        jump
#endif
                    }
                    .padding(.horizontal)
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
            }
            Button {
                isOthers = false
            } label: {
                Image(systemName: "xmark.circle.fill")
                    .font(.largeTitle)
                    .foregroundColor(Color(uiColor: .label))
                    .padding()
                    .opacity(0.6)
            }
        }
    }
}
