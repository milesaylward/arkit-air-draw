//
//  ViewController.swift
//  airDraw
//
//  Created by Miles Aylward on 10/8/18.
//  Copyright © 2018 Miles Aylward. All rights reserved.
//

import UIKit
import ARKit
class ViewController: UIViewController, ARSCNViewDelegate {

    @IBOutlet weak var sceneView: ARSCNView!
    @IBOutlet weak var Draw: UIButton!
    let config = ARWorldTrackingConfiguration()
    override func viewDidLoad() {
        super.viewDidLoad()
//        self.sceneView.debugOptions = [ARSCNDebugOptions.showWorldOrigin, ARSCNDebugOptions.showFeaturePoints]
//        self.sceneView.showsStatistics = true
        self.sceneView.session.run(config)
        self.sceneView.delegate = self
    }
    
    func renderer(_ renderer: SCNSceneRenderer, willRenderScene scene: SCNScene, atTime time: TimeInterval) {
        guard let POV = sceneView.pointOfView else {return}
        let transform = POV.transform
        let orientation = SCNVector3(-transform.m31, -transform.m32, -transform.m33)
        let location = SCNVector3(transform.m41,transform.m42,transform.m43)
        let currentPOC = orientation + location
        DispatchQueue.main.async {
            if self.Draw.isHighlighted {
                let brush = SCNNode(geometry: SCNSphere(radius: 0.02))
                brush.position = currentPOC
                brush.geometry?.firstMaterial?.diffuse.contents = UIColor.red
                self.sceneView.scene.rootNode.addChildNode(brush)
            } else {
                let pointer = SCNNode(geometry: SCNSphere(radius: 0.01))
                pointer.name = "pointer"
                pointer.position = currentPOC
                pointer.geometry?.firstMaterial?.diffuse.contents = UIColor.white
                self.sceneView.scene.rootNode.enumerateChildNodes({ (node, _) in
                    if node.name == "pointer" {
                        node.removeFromParentNode()
                    }
                });
                self.sceneView.scene.rootNode.addChildNode(pointer)
            }
        }
    }
}

func + (left: SCNVector3, right: SCNVector3) -> SCNVector3 {
    return SCNVector3Make(left.x + right.x, left.y + right.y, left.z + right.z)
}

