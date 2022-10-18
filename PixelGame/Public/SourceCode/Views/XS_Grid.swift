//
//  XS_Grid.swift
//  PixelGame
//
//  Created by 韩云智 on 2022/10/18.
//

import SwiftUI

struct XS_Grid: View {
    enum DirectionType: String {
        case up
        case down
        case left
        case right
    }
    
    let color: CGColor
    @Binding var points: [[XS_Point]]
    @Binding var options: XS_Options
    
    private func offsetBtn(_ type) -> some View {
        
    }
    private var content: some View {
        VStack {
            HStack {
                
            }
        }
    }
    
    var body: some View {
        GeometryReader { proxy in
            let size = min(proxy.size.width, proxy.size.height)
            content
                .frame(width: size, height: size)
                .frame(maxWidth: .infinity, maxHeight: .infinity)
        }
    }
}
