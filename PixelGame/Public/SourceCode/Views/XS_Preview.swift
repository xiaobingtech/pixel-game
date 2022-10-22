//
//  XS_Preview.swift
//  PixelGame
//
//  Created by 韩云智 on 2022/10/18.
//

import SwiftUI
import SceneKit

struct XS_Preview: View {
    let color: CGColor
    let points: [[XS_Point]]
    
    @Environment(\.isEnabled) private var isEnabled
    
    private var theScene: SCNScene {
        let scene = SCNScene()
        scene.background.contents = color
        
        for (index, arr) in points.enumerated() {
            for point in arr {
                let box = SCNBox(width: 1, height: 1, length: 1, chamferRadius: 0)
                box.firstMaterial?.diffuse.contents = point.color
                let node = SCNNode(geometry: box)
                node.position = SCNVector3(
                    x: Float(point.position.x),
                    y: Float(index),
                    z: Float(point.position.y)
                )
                scene.rootNode.addChildNode(node)
            }
        }
        
        let camera = SCNCamera()
        let cameraNode = SCNNode()
        cameraNode.camera = camera
        cameraNode.position = SCNVector3(0, 0, 50)
        scene.rootNode.addChildNode(cameraNode)
        
        return scene
    }
    
    var body: some View {
        SceneView(scene: theScene, options: isEnabled ? [.autoenablesDefaultLighting, .allowsCameraControl] : [.autoenablesDefaultLighting])
            .ignoresSafeArea()
    }
}
