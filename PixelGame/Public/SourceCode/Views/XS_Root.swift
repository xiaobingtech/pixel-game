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
        Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
            .onTapGesture {
                xs_hud.isActivity.toggle()
            }
    }
}

struct XS_Root_Previews: PreviewProvider {
    static var previews: some View {
        XS_Root()
    }
}
