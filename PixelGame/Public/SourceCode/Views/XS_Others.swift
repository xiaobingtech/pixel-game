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
                    Image("AppIcon1024")
                        .resizable()
                        .frame(width: 80, height: 80)
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
