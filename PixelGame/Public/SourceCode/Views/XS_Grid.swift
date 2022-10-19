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
    
    @State private var oldCurrent: Int?
    
    private func onDrag(_ value: DragGesture.Value, size: Double) {
        
    }
    private func offsetBtn(_ direction: DirectionType) -> some View {
        Button {
            let offset = CGFloat(options.count)
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
    private func pointPosition(_ position: CGPoint, size: Double) -> CGPoint {
        let count = Double(options.count)
        let x = position.x + count - options.offset.x
        let y = position.y + count + options.offset.y
        return CGPoint(x: x*size, y: y*size)
    }
    private func filter(point: XS_Point) -> Bool {
        let count = Double(options.count)
        guard point.position.x >= options.offset.x - count,
              point.position.x <= options.offset.x + count,
              point.position.y >= options.offset.y - count,
              point.position.y <= options.offset.y + count else { return false }
        return true
    }
    private func contentPoints(_ num: Int, size: Double) -> some View {
        let arr = points[num].filter(filter(point:))
        return
            ForEach(0..<arr.count, id: \.self) { index in
                let point = arr[index]
                Color(point.color)
                    .frame(width: size, height: size)
                    .position(pointPosition(point.position, size: size))
            }
            .padding(size/2)
    }
    private var content: some View {
        GeometryReader { proxy in
            ZStack {
                let count = options.count*2+1
                let size = proxy.size.width/Double(count)
                ZStack {
                    Group {
                        if let oldCurrent = oldCurrent, points.count > oldCurrent {
                            contentPoints(oldCurrent, size: size)
                                .opacity(0.2)
                        }
                        if points.count > options.current {
                            contentPoints(options.current, size: size)
                        }
                    }
                    .frame(width: proxy.size.width, height: proxy.size.height)
                    
                    VStack(spacing: 0) {
                        ForEach(0..<count+1, id: \.self) { index in
                            Divider()
                                .frame(height: 1)
                                .overlay {
                                    Color(uiColor: .label).opacity(0.5)
                                }
                                .frame(height: size)
                        }
                    }
                    HStack(spacing: 0) {
                        ForEach(0..<count+1, id: \.self) { index in
                            Divider()
                                .frame(width: 1)
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
                
                offsetBtn(.up)
                    .frame(maxHeight: .infinity, alignment: .top)
                offsetBtn(.down)
                    .frame(maxHeight: .infinity, alignment: .bottom)
                offsetBtn(.left)
                    .frame(maxWidth: .infinity, alignment: .leading)
                offsetBtn(.right)
                    .frame(maxWidth: .infinity, alignment: .trailing)
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
