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
    
    @Environment(\.xs_hud) private var xs_hud
    @Environment(\.colorScheme) private var colorScheme
    
    @State private var oldCurrent: Int?
    
    private func onDrag(_ value: DragGesture.Value, size: Double) {
        guard points.count > options.current else { return }
        let count = options.count*2 + 1
        let x = Int(value.location.x/size)
        guard x >= 0, x < count  else { return }
        let y = Int(value.location.y/size)
        guard y >= 0, y < count else { return }
        let position = CGPoint(
            x: x - options.count + Int(options.offset.x),
            y: y - options.count + Int(options.offset.y)
        )
        if options.isClear {
            points[options.current].removeAll { $0.position == position }
        } else if let index = points[options.current].firstIndex(where: { $0.position == position }) {
            points[options.current][index].color = color
        } else {
            let point = XS_Point(position: position, color: color)
            points[options.current].append(point)
        }
    }
    private func currentBtn(_ direction: DirectionType) -> some View {
        Button {
            guard points.contains(where: { !$0.isEmpty }) else {
                xs_hud.showToast("当前没有内容!")
                return
            }
            switch direction {
            case .left:
                if let item = points.last, item.isEmpty {
                    points.removeLast()
                    oldCurrent = nil
                    options.current = points.count - 1
                } else {
                    if options.current > 0 {
                        options.current -= 1
                    } else {
                        points.insert([], at: 0)
                    }
                    oldCurrent = options.current + 1
                }
            case .right:
                if let item = points.first, item.isEmpty {
                    points.removeFirst()
                    oldCurrent = nil
                    options.current = 0
                } else {
                    if points.count <= options.current + 1 {
                        points.append([])
                    }
                    options.current += 1
                    oldCurrent = options.current - 1
                }
            default: break
            }
        } label: {
            Image(systemName: "arrowtriangle." + direction.rawValue + ".fill")
                .foregroundColor(Color(uiColor: .label))
        }
    }
    private func offsetBtn(_ direction: DirectionType) -> some View {
        Button {
            let offset = CGFloat(options.count)
            switch direction {
            case .up: options.offset.y -= offset
            case .down: options.offset.y += offset
            case .left: options.offset.x -= offset
            case .right: options.offset.x += offset
            }
        } label: {
            Image(systemName: "chevron." + direction.rawValue + ".circle")
                .font(.largeTitle)
                .foregroundColor(Color(uiColor: .label).opacity(0.4))
        }
    }
    private func pointPosition(_ position: CGPoint, size: Double) -> CGPoint {
        let count = Double(options.count)
        let x = position.x + count - options.offset.x
        let y = position.y + count - options.offset.y
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
                ZStack {
                    Color(point.color)
                    Image(systemName: "xmark")
                        .resizable()
                        .opacity(0.5)
                }
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
                                .opacity(0.4)
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
    
    private func mapSize(_ points: [XS_Point]) -> (CGSize, CGPoint) {
        if points.isEmpty { return (.zero, .zero) }
        var minPoint = points.first!.position
        var maxPoint = minPoint
        for point in points {
            minPoint.x = min(minPoint.x, point.position.x)
            maxPoint.x = max(maxPoint.x, point.position.x)
            minPoint.y = min(minPoint.y, point.position.y)
            maxPoint.y = max(maxPoint.y, point.position.y)
        }
        return (
            CGSize(width: maxPoint.x - minPoint.x, height: maxPoint.y - minPoint.y),
            CGPoint(x: (maxPoint.x + minPoint.x)/2, y: (maxPoint.y + minPoint.y)/2)
        )
    }
    private var map: some View {
        GeometryReader { proxy in
            if points.count > options.current {
                let points = points[options.current]
                let (size, center) = mapSize(points)
                let scale = min(proxy.size.width/size.width, proxy.size.height/size.height)
                ZStack {
                    ForEach(0..<points.count, id: \.self) { index in
                        let point = points[index]
                        Color(cgColor: point.color)
                            .frame(width: 1, height: 1)
                            .position(point.position)
                    }
                }
                .frame(width: size.width, height: size.height)
                .offset(x: center.x, y: center.y)
                .scaleEffect(scale)
//                .offset(x: proxy.size.width/2, y: proxy.size.height/2)
                .frame(maxWidth: .infinity, maxHeight: .infinity)
            }
        }
    }
    
    var body: some View {
        GeometryReader { proxy in
            let size = min(proxy.size.width, proxy.size.height)
            VStack {
                HStack {
                    currentBtn(.left)
                    Text("\(options.current+1)/\(points.count)")
                    currentBtn(.right)
                }
                .font(.title)
                GeometryReader { mapProxy in
                    ZStack {
                        let bgColor = (colorScheme == .dark ? UIColor.black : UIColor.white).cgColor
                        if options.hasMap {
                            map.modifier(PositionModifier(size: mapProxy.size, width: size, isFirst: true))
                        }
                        if options.has3DMap {
                            XS_Preview(color: bgColor, points: points)
                                .modifier(PositionModifier(size: mapProxy.size, width: size, isFirst: !options.hasMap))
                        }
                        content
                            .padding()
                            .frame(width: size, height: size)
                    }
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                }
            }
        }
    }
    
    private struct PositionModifier: ViewModifier {
        let size: CGSize
        let width: CGFloat
        let isFirst: Bool
        func body(content: Content) -> some View {
            let s: CGFloat
            let point: CGPoint
            if size.width > size.height {
                s = floor((size.width - width)/2)
                if isFirst {
                    point = CGPoint(x: s/2 + 5, y: s/2)
                } else {
                    point = CGPoint(x: s/2 + 5, y: s/2 + s + 5)
                }
            } else {
                s = floor((size.height - width)/2)
                if isFirst {
                    point = CGPoint(x: s/2 + 5, y: s/2)
                } else {
                    point = CGPoint(x: s/2 + s + 10, y: s/2)
                }
            }
            return content
                .frame(width: s, height: s)
                .border(Color(uiColor: .label))
                .position(point)
        }
    }
}
