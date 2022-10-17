//
//  XS_Hud.swift
//  PixelGame
//
//  Created by 韩云智 on 2022/10/17.
//

import SwiftUI

struct XS_Hud<Content: View>: View {
    let content: () -> Content
    @ObservedObject private var xs_hud: XS_HudModel = .init()
    
    var body: some View {
        ZStack {
            content()
                .environment(\.xs_hud, xs_hud)
            
            if xs_hud.isActivity {
                Color.black.opacity(0.1)
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .edgesIgnoringSafeArea(.all)
                    .transition(.opacity.animation(.easeInOut))
            }
        }
    }
}

class XS_HudModel: ObservableObject {
    @Published var isActivity: Bool = false
    @Published var toast: String?
    var toastID: UUID!
    
    func showToast(_ msg: String) {
        if msg.isEmpty { return }
        let id = UUID()
        toastID = id
        toast = msg
        DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(2)) {
            self.hideToast(id)
        }
    }
    func hideToast(_ id: UUID) {
        guard id == toastID else { return }
        toast = nil
    }
}

private struct XS_HudModelKey: EnvironmentKey {
    static let defaultValue: XS_HudModel = .init()
}
extension EnvironmentValues {
    var xs_hud: XS_HudModel {
        get { self[XS_HudModelKey.self] }
        set { self[XS_HudModelKey.self] = newValue }
    }
}
