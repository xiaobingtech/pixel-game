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
    
    var body: some View {
        ZStack(alignment: .topTrailing) {
            ScrollView(.vertical, showsIndicators: false) {
                VStack {
                    
                    if let infoDict = Bundle.main.infoDictionary {
                        if let bundleIcons = infoDict["CFBundleIcons"] as? [String:Any],
                           let bundlePrimaryIcon = bundleIcons["CFBundlePrimaryIcon"] as? [String:Any],
                           let bundleIconFiles = bundlePrimaryIcon["CFBundleIconFiles"] as? [String],
                           let iconName = bundleIconFiles.last {
                            Image(iconName)
                                .resizable()
                                .frame(width: 80, height: 80)
                        }
                        if let version = infoDict["CFBundleShortVersionString"] as? String {
                            (
                                Text("v").font(.body)
                                +
                                Text(version).font(.title)
                            )
                            .padding()
                        }
                    }
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
