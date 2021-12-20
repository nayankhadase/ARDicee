//
//  ViewController.swift
//  ARDicee
//
//  Created by Nayan Khadase on 13/12/21.
//

import UIKit
import SceneKit
import ARKit

class ViewController: UIViewController, ARSCNViewDelegate {

    @IBOutlet var sceneView: ARSCNView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set the view's delegate
        sceneView.delegate = self
        
        // Show statistics such as fps and timing information
        sceneView.showsStatistics = true

        sceneView.debugOptions = [.showFeaturePoints, .showWorldOrigin]
        
            
        sceneView.autoenablesDefaultLighting = true
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Create a session configuration
        let configuration = ARWorldTrackingConfiguration()
        configuration.planeDetection = .horizontal
       print("arworls tracking : \(ARWorldTrackingConfiguration.isSupported)")
        // Run the view's session
        sceneView.session.run(configuration)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        // Pause the view's session
        sceneView.session.pause()
    }

    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let touch = touches.first{
            print("h")
            let touchLocation = touch.location(in: sceneView)
            let result = sceneView.hitTest(touchLocation, types: .existingPlaneUsingExtent)
            if let hitResult = result.first{
                if let dice = SCNScene(named: "art.scnassets/diceCollada.scn"){
                    if let diceNode = dice.rootNode.childNode(withName: "Dice", recursively: true){
                        diceNode.position = SCNVector3(x: hitResult.worldTransform.columns.3.x, y: hitResult.worldTransform.columns.3.y + diceNode.boundingSphere.radius, z: hitResult.worldTransform.columns.3.z)
                        sceneView.scene.rootNode.addChildNode(diceNode)
                    }
                }
            }
        }
    }
    
    
    
    // MARK: - ARSCNViewDelegate
    func renderer(_ renderer: SCNSceneRenderer, didAdd node: SCNNode, for anchor: ARAnchor) {
        if anchor is ARPlaneAnchor{
            let planeAnchor = anchor as! ARPlaneAnchor
            let plane = SCNPlane(width: CGFloat(planeAnchor.extent.x), height: CGFloat(planeAnchor.extent.z))
            plane.firstMaterial?.diffuse.contents = UIImage(named: "art.scnassets/grid.png")
            let planeNode = SCNNode(geometry: plane)
            planeNode.position = SCNVector3(planeAnchor.center.x, 0, planeAnchor.center.z)
            planeNode.transform = SCNMatrix4MakeRotation(-.pi/2, 1, 0, 0)
            node.addChildNode(planeNode)
        }else{
            return
        }
    }

}
