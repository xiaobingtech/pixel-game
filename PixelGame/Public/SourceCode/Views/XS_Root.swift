//
//  XS_Root.swift
//  PixelGame
//
//  Created by 韩云智 on 2022/10/17.
//

import SwiftUI

struct XS_Root: View {
    @Environment(\.xs_hud) private var xs_hud
    var body: some View {
        VStack {
            HStack {
                Spacer()
                Image(systemName: "play.circle")
                
                Image(systemName: "ellipsis.circle")
            }
            .font(.title2)
            .padding()
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
        XS_Root()
    }
}
