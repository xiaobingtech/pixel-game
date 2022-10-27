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
    
    private var count: some View {
        EmptyView()
    }
    private var map: some View {
        EmptyView()
    }
    private var map3d: some View {
        Button {
            guard let url = URL(string: "https://apps.apple.com/cn/app/id6443961966"), UIApplication.shared.canOpenURL(url) else { return }
            UIApplication.shared.open(url)
        } label: {
            HStack {
                Text("下载免广告版")
                Spacer()
                Image(systemName: "chevron.right")
            }
            .font(.system(size: 20))
            .foregroundColor(Color(uiColor: .label))
            .frame(height: 50)
        }
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
            .font(.custom("PingFangSC-Regular", size: 140))
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
