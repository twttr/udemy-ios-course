//
//  ViewController.swift
//  ARDicee
//
//  Created by Pavel Romanishkin on 06.04.21.
//

import UIKit
import SceneKit
import ARKit

class ViewController: UIViewController, ARSCNViewDelegate {
    
    @IBOutlet var sceneView: ARSCNView!
    
    var diceArray = [SCNNode]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        sceneView.delegate = self
        sceneView.showsStatistics = true
        sceneView.autoenablesDefaultLighting = true
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        let configuration = ARWorldTrackingConfiguration()
        configuration.planeDetection = .horizontal
        
        sceneView.session.run(configuration)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        sceneView.session.pause()
    }
    
    @IBAction func rollAgain(_ sender: UIBarButtonItem) {
        rollAll()
    }
    @IBAction func removeAllScenes(_ sender: UIBarButtonItem) {
        if !diceArray.isEmpty {
            for dice in diceArray {
                dice.removeFromParentNode()
            }
        }
    }
    
    override func motionEnded(_ motion: UIEvent.EventSubtype, with event: UIEvent?) {
        rollAll()
    }
    
    func renderer(_ renderer: SCNSceneRenderer, didAdd node: SCNNode, for anchor: ARAnchor) {
        guard let planeAnchor = anchor as? ARPlaneAnchor else { return }
        
        node.addChildNode(planeRenderer(with: planeAnchor))
    }
    
    func planeRenderer(with planeAnchor: ARPlaneAnchor) ->  SCNNode{
        let plane = SCNPlane(width: CGFloat(planeAnchor.extent.x), height: CGFloat(planeAnchor.extent.z))
        let planeNode = SCNNode()
        planeNode.position = SCNVector3(planeAnchor.center.x, 0, planeAnchor.center.z)
        planeNode.transform = SCNMatrix4MakeRotation(-Float.pi / 2, 1, 0, 0)
        let gridMaterial = SCNMaterial()
        gridMaterial.diffuse.contents = UIImage(named: "art.scnassets/grid.png")
        plane.materials = [gridMaterial]
        planeNode.geometry = plane
        
        return planeNode
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let touch = touches.first {
            let touchLocation = touch.location(in: sceneView)
            let query: ARRaycastQuery? = sceneView.raycastQuery(
                from: touchLocation,
                allowing: .existingPlaneGeometry,
                alignment: .horizontal
            )
            
            if let nonOptQuery: ARRaycastQuery = query {
                
                let result: [ARRaycastResult] = sceneView.session.raycast(nonOptQuery)
                if let result = result.first {
                    addDice(at: result)
                }
            }
        }
    }
    
    func addDice(at location: ARRaycastResult) {
        let scene = SCNScene(named: "art.scnassets/diceColladaScene.scn")!
        if let diceNode = scene.rootNode.childNode(withName: "Dice", recursively: true) {
            let worldTransform = location.worldTransform.columns.3
            
            diceArray.append(diceNode)
            
            diceNode.position = SCNVector3(
                worldTransform.x,
                worldTransform.y + diceNode.boundingSphere.radius,
                worldTransform.z
            )
            sceneView.scene.rootNode.addChildNode(diceNode)
            roll(dice: diceNode)
        }
    }
    
    func rollAll() {
        if !diceArray.isEmpty {
            for dice in diceArray {
                roll(dice: dice)
            }
        }
    }
    
    func roll(dice: SCNNode) {
        let randomX = CGFloat((Float(arc4random_uniform(4) + 1)) * (Float.pi/2) * 5)
        let randomZ = CGFloat((Float(arc4random_uniform(4) + 1)) * (Float.pi/2) * 5)
        dice.runAction(SCNAction.rotateBy(x: randomX, y: 0, z: randomZ, duration: 0.5))
    }
}
