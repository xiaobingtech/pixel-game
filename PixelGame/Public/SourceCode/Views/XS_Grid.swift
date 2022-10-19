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
    
    private func onDrag(_ value: DragGesture.Value, size: Double) {
        
    }
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
                let size = proxy.size.width/Double(options.count)
                ZStack {
                    if points.count > options.current {
                        let arr = points[options.current].filter { point in
                            return true
                        }
                        ForEach(0..<arr.count, id: \.self) { index in
                            let point = arr[index]
                            Color(point.color)
                                .frame(width: size, height: size)
                                .position(x: (point.position.x + 0.5)*size, y: (point.position.y + 0.5)*size)
                        }
                        .frame(width: proxy.size.width, height: proxy.size.height)
                    }
                    VStack(spacing: 0) {
                        ForEach(0..<options.count+1, id: \.self) { index in
                            Divider()
                                .overlay {
                                    Color(uiColor: .label).opacity(0.5)
                                }
                                .frame(height: size)
                        }
                    }
                    HStack(spacing: 0) {
                        ForEach(0..<options.count+1, id: \.self) { index in
                            Divider()
                                .overlay {
                                    Color(uiColor: .label).opacity(0.5)
                                }
                                .frame(width: size)
                        }
                    }
                    
                }
                .frame(width: proxy.size.width, height: proxy.size.height)
                .mask {
                    Color.black
                        .shadow(color: .black, radius: 30)
                        .padding(30)
                }
                .gesture(
                    DragGesture(minimumDistance: 0)
                        .onChanged { onDrag($0, size: size) }
                        .onEnded { onDrag($0, size: size) }
                )
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
