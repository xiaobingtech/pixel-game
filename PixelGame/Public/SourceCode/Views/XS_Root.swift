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
    @State private var color: CGColor = UIColor.systemBackground.cgColor
    @State private var bgColor: CGColor = UIColor.systemBackground.cgColor
    
    private var open: some View {
        Button {
            
        } label: {
            Text("Open")
            Image(systemName: "folder.circle.fill")
        }
    }
    private var save: some View {
        Button {
            
        } label: {
            Text("Save")
            Image(systemName: "arrow.down.to.line.circle.fill")
        }
    }
    private var share: some View {
        Button {
            
        } label: {
            Text("Share")
            Image(systemName: "paperplane.circle.fill")
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
            Text("About us")
            Image(systemName: "exclamationmark.circle.fill")
        }
    }
    
    private var menu: some View {
        HStack {
            ColorPicker("", selection: isPreview ? $bgColor : $color, supportsOpacity: true)
                .labelsHidden()
            if !isPreview {
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
                share
                save
                open
                delete
                about
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
                XS_Preview(color: bgColor, points: points)
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
            }
            VStack {
                menu.shadow(color: Color(uiColor: .systemBackground), radius: 1)
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
