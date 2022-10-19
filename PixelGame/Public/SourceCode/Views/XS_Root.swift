//
//  XS_Root.swift
//  PixelGame
//
//  Created by 韩云智 on 2022/10/17.
//

import SwiftUI

struct XS_Root: View {
    @Environment(\.xs_hud) private var xs_hud
    
    @State private var isPreview: Bool = false
    @State private var points: [[XS_Point]] = [[
        XS_Point(position: .init(x: 5, y: 5), color: UIColor.black.cgColor)
    ]]
    @State private var options: XS_Options = .init()
    @State private var color: CGColor = UIColor.black.cgColor
    
    private var menu: some View {
        HStack {
            ColorPicker("", selection: $color, supportsOpacity: true)
                .labelsHidden()
            Spacer()
            Button {
                isPreview.toggle()
            } label: {
                Image(
                    systemName: isPreview
                    ? "arrow.uturn.backward.circle"
                    : "play.circle"
                )
            }
            Menu {
                Text("123")
                    .onTapGesture {
                        
                    }
                Button {
                    
                } label: {
                    Text("456")
                }
            } label: {
                Image(systemName: "ellipsis.circle")
            }

        }
        .font(.title2)
        .foregroundColor(Color(uiColor: .label))
        .padding(.horizontal)
        .padding(.vertical, 5)
    }
    
    var body: some View {
        VStack {
            menu
            Group {
                if isPreview {
                    XS_Preview(points: points)
                } else {
                    XS_Grid(color: color, points: $points, options: $options)
                }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
        }
    }
}

struct XS_Point: Equatable {
    let position: CGPoint
    var color: CGColor
}

struct XS_Options: Equatable {
    var current: Int = 0
    var count: Int = 10
    var offset: CGPoint = .zero
}

struct XS_Root_Previews: PreviewProvider {
    static var previews: some View {
        XS_Hud {
            XS_Root()
        }
    }
}
