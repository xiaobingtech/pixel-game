//
//  XS_Grid.swift
//  PixelGame
//
//  Created by 韩云智 on 2022/10/18.
//

import SwiftUI

struct XS_Grid: View {
    let color: CGColor
    @Binding var points: [[XS_Point]]
    @Binding var options: XS_Options
    
    var body: some View {
        Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
    }
}

struct XS_Grid_Previews: PreviewProvider {
    static var previews: some View {
        XS_Grid(co)
    }
}
