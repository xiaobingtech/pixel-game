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
    
    private func offsetBtn(_ direction: DirectionType) -> some View {
        Button {
            let offset = CGFloat(options.count/2)
            switch direction {
            case .up: options.offset.y += offset
            case .down: options.offset.y -= offset
            case .left: options.offset.x -= offset
            case .right: options.offset.x += offset
            }
        } label: {
            Image(systemName: "chevron." + direction.rawValue + ".circle")
                .font(.largeTitle)
                .foregroundColor(Color(uiColor: .label))
                .opacity(0.4)
        }
    }
    private var content: some View {
        GeometryReader { proxy in
            ZStack {
                offsetBtn(.up)
                    .frame(maxHeight: .infinity, alignment: .top)
                offsetBtn(.down)
                    .frame(maxHeight: .infinity, alignment: .bottom)
                offsetBtn(.left)
                    .frame(maxWidth: .infinity, alignment: .leading)
                offsetBtn(.right)
                    .frame(maxWidth: .infinity, alignment: .trailing)
                ZStack {
                    let size = proxy.size.width/Double(options.count)
                    
                    
                    
                }
            }
        }
    }
    
    var body: some View {
        GeometryReader { proxy in
            let size = min(proxy.size.width, proxy.size.height)
            content
                .padding()
                .frame(width: size, height: size)
                .frame(maxWidth: .infinity, maxHeight: .infinity)
        }
    }
}
