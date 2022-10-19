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
    @State private var points: [[XS_Point]] = [[]]
    @State private var options: XS_Options = .init()
    @State private var color: CGColor = UIColor.black.cgColor
    
    private var save: some View {
        Button {
            
        } label: {
            Text("Delete")
            Image(systemName: "trash.circle.fill")
        }
    }
    private var share: some View {
        Button {
            
        } label: {
            Text("Delete")
            Image(systemName: "trash.circle.fill")
        }
    }
    private var delete: some View {
        Button {
            
        } label: {
            Text("Delete")
            Image(systemName: "trash.circle.fill")
        }
    }
    private var about: some View {
        Button {
            
        } label: {
            Text("Delete")
            Image(systemName: "trash.circle.fill")
        }
    }
    
    private var menu: some View {
        HStack {
            Group {
                ColorPicker("", selection: $color, supportsOpacity: true)
                    .labelsHidden()
                Button {
                    options.isClear.toggle()
                } label: {
                    Image(
                        systemName: options.isClear
                        ? "pencil.slash"
                        : "pencil.circle"
                    )
                }
            }
            .opacity(isPreview ? 0 : 1)
            
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
                //paperplane
                //exclamationmark.circle
                // tray.and.arrow.down.fill
                //arrow.down.to.line.circle
                Button {
                    
                } label: {
                    Text("Delete")
                    Image(systemName: "trash.circle.fill")
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
        ZStack(alignment: .top) {
            if isPreview {
                XS_Preview(points: points)
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
            }
            VStack {
                menu
                if !isPreview {
                    XS_Grid(color: color, points: $points, options: $options)
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                }
            }
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
    var isClear: Bool = false
}

struct XS_Root_Previews: PreviewProvider {
    static var previews: some View {
        XS_Hud {
            XS_Root()
        }
    }
}
