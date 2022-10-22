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
        if points.isEmpty {
            return scene
        }
        
        var minPoint: CGPoint!
        var maxPoint: CGPoint!
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
                
                if minPoint == nil {
                    minPoint = point.position
                } else {
                    minPoint.x = min(minPoint.x, point.position.x)
                    minPoint.y = min(minPoint.y, point.position.y)
                }
                if maxPoint == nil {
                    maxPoint = point.position
                } else {
                    maxPoint.x = max(maxPoint.x, point.position.x)
                    maxPoint.y = max(maxPoint.y, point.position.y)
                }
            }
        }
        
        let camera = SCNCamera()
        let cameraNode = SCNNode()
        cameraNode.camera = camera
        let maxL = max(Float(maxPoint.x - minPoint.x), Float(maxPoint.y - minPoint.y), Float(points.count))
        cameraNode.position = SCNVector3(
            x: Float(minPoint.x + maxPoint.x)/2,
            y: Float(points.count)/2 - 0.5,
            z: Float(minPoint.y + maxPoint.y)/2 + maxL/2 + 20.5
        )
        scene.rootNode.addChildNode(cameraNode)
        
        camera.zFar = 21 + Double(maxL)
        camera.zNear = 1
        
        return scene
    }
    
    var body: some View {
        SceneView(scene: theScene, options: isEnabled ? [.autoenablesDefaultLighting, .allowsCameraControl] : [.autoenablesDefaultLighting])
            .ignoresSafeArea()
    }
}
