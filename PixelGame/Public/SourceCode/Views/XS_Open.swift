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
    var body: some View {
        VStack {
            Button {
                isOpen = false
            } label: {
                Text("返回")
            }
            if let files = XS_Tools.getFiles {
                ForEach(files, id: \.md5) { file in
                    Button {
                        points = file.points
                        isOpen = false
                    } label: {
                        Text(file.name)
                    }
                }
            } else {
                Text("加载失败")
            }
        }
    }
}
