//
//  XS_Open.swift
//  PixelGame
//
//  Created by 韩云智 on 2022/10/21.
//

import SwiftUI

struct XS_Open: View {
    @Binding var isOpen: Bool
    @Binding var points: [[XS_Point]]
    
    private func cell(_ item: XS_File) -> some View {
        Button {
            points = item.points
            isOpen = false
        } label: {
            VStack {
                XS_Preview(color: UIColor.white.cgColor, points: item.points)
                    .frame(width: 100, height: 100)
                    .cornerRadius(5)
                Text(item.name)
                    .font(.body)
            }
            .padding(10)
            .background(Color.gray.opacity(0.2))
            .cornerRadius(10)
        }
    }
    
    var body: some View {
        ZStack(alignment: .topTrailing) {
            if let files = XS_Tools.getFiles {
                GeometryReader { proxy in
                    ScrollView(.vertical, showsIndicators: false) {
                        XS_WrappedLayout(data: files, gWidth: proxy.size.width - 30, itemSpacing: 20, lineSpacing: 20, content: cell(_:))
                            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
                    }
                }
            } else {
                Text("加载失败!")
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
            }
            Button {
                isOpen = false
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
