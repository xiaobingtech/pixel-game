//
//  XS_Open.swift
//  PixelGame
//
//  Created by 韩云智 on 2022/10/21.
//

import SwiftUI

struct XS_Open: View {
    let color: CGColor
    @Binding var isOpen: Bool
    @Binding var points: [[XS_Point]]
    
    @Environment(\.xs_hud) private var xs_hud
    
    @State private var files: [XS_File]? = XS_Tools.getFiles
    
    private func cell(_ item: XS_File) -> some View {
        ZStack(alignment: .topLeading) {
            VStack {
                Button {
                    points = item.points
                    isOpen = false
                } label: {
                    XS_Preview(color: color, points: item.points)
                        .frame(width: 150, height: 150)
                        .cornerRadius(5)
                        .disabled(true)
                }
                Button {
                    XS_Tools.editName(item) {
                        files = XS_Tools.getFiles
                    }
                } label: {
                    HStack {
                        Text(item.name)
                            .lineLimit(1)
                        Image(systemName: "highlighter")
                    }
                    .font(.body)
                    .foregroundColor(Color(uiColor: .label))
                    
                }
                .frame(width: 150)
            }
            .padding(10)
            .background(Color.gray.opacity(0.2))
            .cornerRadius(10)
            HStack {
                Button {
                    
                } label: {
                    Image(systemName: "trash.circle.fill")
                        .font(.title2)
                        .foregroundColor(Color.red)
                        .background(Color.white)
                        .clipShape(Circle())
                }
                Button {
                    if XS_Tools.share(file: item) {
                        
                    } else {
                        xs_hud.showToast("分享失败!")
                    }
                } label: {
                    Image(systemName: "paperplane.circle.fill")
                        .font(.title2)
                        .foregroundColor(Color.blue)
                        .background(Color.white)
                        .clipShape(Circle())
                }
            }
            .padding(5)
        }
    }
    
    var body: some View {
        ZStack(alignment: .topTrailing) {
            if let files = files?.sorted(by: { $0.date > $1.date }) {
                GeometryReader { proxy in
                    ScrollView(.vertical, showsIndicators: false) {
                        XS_WrappedLayout(data: files, gWidth: proxy.size.width - 30, itemSpacing: 20, lineSpacing: 20, content: cell(_:))
                            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
                            .padding(.vertical, 20)
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
