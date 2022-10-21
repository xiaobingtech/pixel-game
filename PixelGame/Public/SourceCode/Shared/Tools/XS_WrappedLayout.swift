//
//  XS_WrappedLayout.swift
//  EKLWisdom2022
//
//  Created by 韩云智 on 2022/7/22.
//

import SwiftUI

struct XS_WrappedLayout<T: Hashable & Equatable, Content: View>: View {
    let data: [T]
    var gWidth: CGFloat?
    var itemSpacing: CGFloat = 4
    var lineSpacing: CGFloat = 4
    @ViewBuilder let content: (T) -> Content
    
    var body: some View {
        if let gWidth = gWidth {
            generateContent(in: gWidth + itemSpacing)
        } else {
            GeometryReader { geometry in
                generateContent(in: geometry.size.width + itemSpacing)
            }
        }
    }
    
    private func generateContent(in gWidth: CGFloat) -> some View {
        var width: CGFloat = 0
        var height: CGFloat = 0
        
        return ZStack(alignment: .topLeading) {
            ForEach(data, id: \.self) { item in
                content(item)
                    .alignmentGuide(.leading) { d in
                        if abs(width - d.width - itemSpacing) > gWidth {
                            width = 0
                            height -= (d.height + lineSpacing)
                        }
                        let result = width
                        if item == data.last {
                            width = 0
                        } else {
                            width -= (d.width + itemSpacing)
                        }
                        return result
                    }
                    .alignmentGuide(.top) { _ in
                        let result = height
                        if item == data.last {
                            height = 0
                        }
                        return result
                    }
            }
        }
        .fixedSize()
    }
}

struct XS_WrappedLayout_Previews: PreviewProvider {
    static var previews: some View {
        let platforms: [String] = ["Ninetendo", "XBox", "PlayStation 2", "PlayStation 3", "PlayStation 4"]
//        return XS_WrappedLayout(data: platforms, itemSpacing: 4, lineSpacing: 20) { text in
//            Text(text)
//                .padding(5)
//                .font(.body)
//                .background(Color.blue)
//                .foregroundColor(Color.white)
//                .cornerRadius(5)
//        }
        return XS_WrappedLayout(data: [Int](0..<platforms.count), itemSpacing: 4, lineSpacing: 20) { index in
            let text: String = platforms[index]
            Text(text)
                .padding(5)
                .font(.body)
                .background(Color.blue)
                .foregroundColor(Color.white)
                .cornerRadius(5)
        }
    }
}
