//
//  ViewController.swift
//  AR Ruler
//
//  Created by Pavel Romanishkin on 07.04.21.
//

import UIKit
import SceneKit
import ARKit

class ViewController: UIViewController, ARSCNViewDelegate {
    
    @IBOutlet var sceneView: ARSCNView!
    
    var dotNodes = [SCNNode]()
    var textNode = SCNNode()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set the view's delegate
        sceneView.delegate = self
        sceneView.debugOptions = [ARSCNDebugOptions.showFeaturePoints]
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if dotNodes.count >= 2 {
            for dot in dotNodes {
                dot.removeFromParentNode()
            }
            dotNodes = [SCNNode]()
        }
        if let touch = touches.first {
            let touchLocation = touch.location(in: sceneView)
            let query: [ARHitTestResult] = sceneView.hitTest(touchLocation, types: .featurePoint)
            
            if let result = query.first {
                addDot(at: result)
            }
        }
    }
    
    func addDot(at location: ARHitTestResult) {
        let sphere = SCNSphere(radius: 0.005)
        let sphereNode = SCNNode(geometry: sphere)
        let material = SCNMaterial()
        material.diffuse.contents = UIColor.red
        sphere.materials = [material]
        sphereNode.position = SCNVector3(
            location.worldTransform.columns.3.x,
            location.worldTransform.columns.3.y,
            location.worldTransform.columns.3.z
        )
        sceneView.scene.rootNode.addChildNode(sphereNode)
        
        dotNodes.append(sphereNode)
        
        if dotNodes.count >= 2 {
            calculate()
        }
    }
    
    func calculate(){
        let start = dotNodes[0]
        let end = dotNodes[1]
        
        let distance = (pow((end.position.x - start.position.x), 2) + pow((end.position.y - start.position.y), 2) + pow((end.position.z - start.position.z), 2)).squareRoot()
        
        updateText(with: "\(String(format: "%.2f", abs(distance) * 100))cm", at: end.position)
    }
    
    func updateText(with text: String, at position: SCNVector3) {
        textNode.removeFromParentNode()
        
        let textGeo = SCNText(string: text, extrusionDepth: 1.0)
        textGeo.firstMaterial?.diffuse.contents = UIColor.red
        
        textNode = SCNNode(geometry: textGeo)
        textNode.position = position
        textNode.scale = SCNVector3(0.01, 0.01, 0.01)
        sceneView.scene.rootNode.addChildNode(textNode)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Create a session configuration
        let configuration = ARWorldTrackingConfiguration()
        
        // Run the view's session
        sceneView.session.run(configuration)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        // Pause the view's session
        sceneView.session.pause()
    }
}
