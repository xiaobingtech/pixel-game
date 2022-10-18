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
    private var menu: some View {
        HStack {
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
        .padding()
    }
    
    var body: some View {
        VStack {
            menu
            Group {
                Text("123")
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
        }
    }
}

struct XS_Point: Equatable {
    let position: CGPoint
    var color: CGColor
}

struct XS_Root_Previews: PreviewProvider {
    static var previews: some View {
        XS_Hud {
            XS_Root()
        }
    }
}
