//
//  ViewController.swift
//  SpotTheScientist
//
//  Created by Paul Hudson on 28/04/2019.
//  Copyright © 2019 Hacking with Swift. All rights reserved.
//

import UIKit
import SceneKit
import ARKit
import AVFoundation

class ViewController: UIViewController, ARSCNViewDelegate {
    
    @IBOutlet var sceneView: ARSCNView!
    
    @IBOutlet var cofrePokeball1: UIButton!
    @IBOutlet var cofreFotoLibro2: UIButton!
    @IBOutlet var cofreSora3: UIButton!
    @IBOutlet var cofreHive4: UIButton!
    
    @IBOutlet var cofreZapatilla5: UIButton!
    @IBOutlet var cofreLondres6: UIButton!
    @IBOutlet var cofreTostaRica7: UIButton!
    @IBOutlet var cofreTostadora8: UIButton!
    @IBOutlet var cofreFotoKira9: UIButton!

    var pistas = [String: Pistas]()
    var player: AVAudioPlayer?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        sceneView.delegate = self
        loadData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Create a session configuration
        let configurationImage = ARImageTrackingConfiguration()
        let configuration = ARWorldTrackingConfiguration()

        guard let trackingImages = ARReferenceImage.referenceImages(inGroupNamed: "fotos", bundle: nil) else {
            fatalError("Couldn't load tracking images")
        }

        guard let trackingObjects = ARReferenceObject.referenceObjects(inGroupNamed: "objetos", bundle: nil) else{
            fatalError("Couldn't load tracking images")
        }
        
        configurationImage.trackingImages = trackingImages
        configuration.detectionObjects = trackingObjects
        

        // Run the view's session
        sceneView.session.run(configurationImage)
//        sceneView.session.run(configuration)
    }
    
    
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        // Pause the view's session
        sceneView.session.pause()
    }

    
    
    func renderer(_ renderer: SCNSceneRenderer, nodeFor anchor: ARAnchor) -> SCNNode? {
        var name = ""
        if let imageAnchor = anchor as? ARImageAnchor{
            name = imageAnchor.referenceImage.name ?? ""
            guard let descubrimiento = pistas[name] else { return nil }
            
            let plane = SCNPlane(width: imageAnchor.referenceImage.physicalSize.width, height: imageAnchor.referenceImage.physicalSize.height)
            plane.firstMaterial?.diffuse.contents = UIColor.clear
            
            let planeNode = SCNNode(geometry: plane)
            planeNode.eulerAngles.x = -.pi / 2
            
            let node = SCNNode()
            node.addChildNode(planeNode)

            let spacing: Float = 0.005

            let titleNode = textNode(descubrimiento.name, font: UIFont.boldSystemFont(ofSize: 14))
            titleNode.pivotOnTopLeft()

            titleNode.position.x += Float(plane.width / 2) + spacing
            titleNode.position.y += Float(plane.height / 2)

            planeNode.addChildNode(titleNode)

            
            let bioNode = textNode(descubrimiento.bio, font: UIFont.systemFont(ofSize: 4), maxWidth: 100)
            bioNode.pivotOnTopLeft()

            bioNode.position.x += Float(plane.width / 2) + spacing
            bioNode.position.y = titleNode.position.y - titleNode.height - spacing
            planeNode.addChildNode(bioNode)


            let flag = SCNPlane(width: 0.2, height: 0.2 / 8 * 5)
            flag.firstMaterial?.diffuse.contents = UIImage(named: descubrimiento.country)

            let flagNode = SCNNode(geometry: flag)
            flagNode.pivotOnTopCenter()

            flagNode.position.y -= Float(plane.height / 2) + spacing
            planeNode.addChildNode(flagNode)
            
            DispatchQueue.main.async {
                    self.updateChest(name: name)
                    self.playSound()
            }

            return node
        }
        
        
        if let objectAnchor = anchor as? ARObjectAnchor{
            name = objectAnchor.referenceObject.name ?? ""
            guard let descubrimiento = pistas[name] else { return nil }
            
            let plane = SCNPlane(width: 0.2, height: 0.2)
            plane.firstMaterial?.diffuse.contents = UIColor.clear
            
            let planeNode = SCNNode(geometry: plane)
            
            let node = SCNNode()
            node.addChildNode(planeNode)

            let spacing: Float = 0.005

            let titleNode = textNode(descubrimiento.name, font: UIFont.boldSystemFont(ofSize: 10))
            titleNode.pivotOnTopLeft()

            titleNode.position.x += Float(plane.width / 2) + spacing
            titleNode.position.y += Float(plane.height / 2)

            planeNode.addChildNode(titleNode)
            
            let bioNode = textNode(descubrimiento.bio, font: UIFont.systemFont(ofSize: 4), maxWidth: 100)
            bioNode.pivotOnTopLeft()

            bioNode.position.x += Float(plane.width / 2) + spacing
            bioNode.position.y = titleNode.position.y - titleNode.height - spacing
            planeNode.addChildNode(bioNode)


            let flag = SCNPlane(width: 0.2, height: 0.2 / 8 * 5)
            flag.firstMaterial?.diffuse.contents = UIImage(named: descubrimiento.country)

            let flagNode = SCNNode(geometry: flag)
            flagNode.pivotOnTopCenter()

            flagNode.position.y -= Float(plane.height / 2) + spacing
            planeNode.addChildNode(flagNode)

            DispatchQueue.main.async {
                    self.updateChest(name: name)
                    self.playSound()
            }
            
            
            return node

        }
        
        return nil
        
    }
    
    func updateChest(name: String){
        switch name {
        case "pokeBall":
            cofrePokeball1.isEnabled = true
            cofrePokeball1.setImage(UIImage(named: "cofre_abierto"), for: .normal)
        case "fotoCuaderno":
            cofreFotoLibro2.isEnabled = true
            cofreFotoLibro2.setImage(UIImage(named: "cofre_abierto"), for: .normal)
        case "sora":
            cofreSora3.isEnabled = true
            cofreSora3.setImage(UIImage(named: "cofre_abierto"), for: .normal)
        case "hive":
            cofreHive4.isEnabled = true
            cofreHive4.setImage(UIImage(named: "cofre_abierto"), for: .normal)
        case "zapatilla":
            cofreZapatilla5.isEnabled = true
            cofreZapatilla5.setImage(UIImage(named: "cofre_abierto"), for: .normal)
        case "londres":
            cofreLondres6.isEnabled = true
            cofreLondres6.setImage(UIImage(named: "cofre_abierto"), for: .normal)
        case "tostaRica":
            cofreTostaRica7.isEnabled = true
            cofreTostaRica7.setImage(UIImage(named: "cofre_abierto"), for: .normal)
        case "tostadora":
            cofreTostadora8.isEnabled = true
            cofreTostadora8.setImage(UIImage(named: "cofre_abierto"), for: .normal)
        case "kira":
            cofreFotoKira9.isEnabled = true
            cofreFotoKira9.setImage(UIImage(named: "cofre_abierto"), for: .normal)
        default:
            break
        }
    }
    
    func playSound() {
        guard let url = Bundle.main.url(forResource: "zelda_item", withExtension: "mp3") else { return }

        do {
            try AVAudioSession.sharedInstance().setCategory(.playback, mode: .default)
            try AVAudioSession.sharedInstance().setActive(true)

            /* The following line is required for the player to work on iOS 11. Change the file type accordingly*/
            player = try AVAudioPlayer(contentsOf: url, fileTypeHint: AVFileType.mp3.rawValue)

            /* iOS 10 and earlier require the following line:
            player = try AVAudioPlayer(contentsOf: url, fileTypeHint: AVFileTypeMPEGLayer3) */

            guard let player = player else { return }

            player.play()

        } catch let error {
            print(error.localizedDescription)
        }
    }

    func loadData() {
        guard let url = Bundle.main.url(forResource: "pistas", withExtension: "json") else {
            fatalError("Unable to find JSON in bundle")
        }

        guard let data = try? Data(contentsOf: url) else {
            fatalError("Unable to load JSON")
        }

        let decoder = JSONDecoder()

        guard let pistas = try? decoder.decode([String: Pistas].self, from: data) else {
            fatalError("Unable to parse JSON.")
        }

        self.pistas = pistas
    }

    func textNode(_ str: String, font: UIFont, maxWidth: Int? = nil) -> SCNNode {
        let text = SCNText(string: str, extrusionDepth: 0)

        text.flatness = 0.1
        text.font = font

        if let maxWidth = maxWidth {
            text.containerFrame = CGRect(origin: .zero, size: CGSize(width: maxWidth, height: 500))
            text.isWrapped = true
        }

        let textNode = SCNNode(geometry: text)
        textNode.scale = SCNVector3(0.002, 0.002, 0.002)

        return textNode
    }
}

extension SCNNode {
    var height: Float {
        return (boundingBox.max.y - boundingBox.min.y) * scale.y
    }

    func pivotOnTopLeft() {
        let (min, max) = boundingBox
        pivot = SCNMatrix4MakeTranslation(min.x, max.y, 0)
    }

    func pivotOnTopCenter() {
        let (_, max) = boundingBox
        pivot = SCNMatrix4MakeTranslation(0, max.y, 0)
    }
}
