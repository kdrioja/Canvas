//
//  CanvasViewController.swift
//  Canvas
//
//  Created by user145766 on 11/2/18.
//  Copyright © 2018 Kenia Rioja. All rights reserved.
//

import UIKit

class CanvasViewController: UIViewController {

    @IBOutlet weak var trayView: UIView!
    var trayOriginalCenter: CGPoint!
    var trayDownOffset: CGFloat!
    var trayUp: CGPoint!
    var trayDown: CGPoint!
    var newlyCreatedFace: UIImageView!
    var newlyCreatedFaceOriginalCenter: CGPoint!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        trayDownOffset = 230
        trayUp = trayView.center // The initial position of the tray
        trayDown = CGPoint(x: trayView.center.x ,y: trayView.center.y + trayDownOffset) // The position of the tray transposed down
    }
    
    @IBAction func didPanTray(_ sender: UIPanGestureRecognizer) {
        let translation = sender.translation(in: view)
        
        if sender.state == .began {
            trayOriginalCenter = trayView.center
        }
        else if sender.state == .changed {
            trayView.center = CGPoint(x: trayOriginalCenter.x, y: trayOriginalCenter.y + translation.y)
        }
        else if sender.state == .ended {
            let velocity = sender.velocity(in: view)
            if velocity.y > 0 {
                UIView.animate(withDuration: 0.3) {
                    self.trayView.center = self.trayDown
                }
            } else {
                UIView.animate(withDuration: 0.3) {
                    self.trayView.center = self.trayUp
                }
            }
        }
    }
    
    
    @IBAction func didPanFace(_ sender: UIPanGestureRecognizer) {
        let translation = sender.translation(in: view)
        if sender.state == .began {
            let imageView = sender.view as! UIImageView
            newlyCreatedFace = UIImageView(image: imageView.image)
            createdPanGestureRecognizer(targetView: newlyCreatedFace)
            newlyCreatedFace.center = imageView.center
            newlyCreatedFace.center.y += trayView.frame.origin.y
            newlyCreatedFaceOriginalCenter = newlyCreatedFace.center
            
            newlyCreatedFace.isUserInteractionEnabled = true
            
            view.addSubview(newlyCreatedFace)
            
            // Here we use the method didPan(sender:), which we defined in the previous step, as the action.
            let panGestureRecognizer = UIPanGestureRecognizer(target: self, action: #selector(didPan(sender:)))
            
            // Attach it to a view of your choice. If it's a UIImageView, remember to enable user interaction
            view.isUserInteractionEnabled = true
            view.addGestureRecognizer(panGestureRecognizer)

        }
        else if sender.state == .changed {
            newlyCreatedFace.center = CGPoint(x: newlyCreatedFaceOriginalCenter.x + translation.x, y: newlyCreatedFaceOriginalCenter.y + translation.y)
        }
        else if sender.state == .ended {
            
        }
    }
    
    @objc func didPan(sender: UIPanGestureRecognizer) {
        //let location = sender.location(in: view)
        //let velocity = sender.velocity(in: view)
        let translation = sender.translation(in: view)
        
        if sender.state == .began {
            newlyCreatedFace = sender.view as? UIImageView // to get the face that we panned on.
            newlyCreatedFaceOriginalCenter = newlyCreatedFace.center // so we can offset by translation later.
        } else if sender.state == .changed {
            newlyCreatedFace.center = CGPoint(x: newlyCreatedFaceOriginalCenter.x + translation.x, y: newlyCreatedFaceOriginalCenter.y + translation.y)
        } else if sender.state == .ended {
        }
    }
    
    func createdPanGestureRecognizer(targetView: UIImageView) {
        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(handlePanGesture(_:)))
        targetView.isUserInteractionEnabled = true
        targetView.addGestureRecognizer(panGesture)
        
    }
    
    @objc func handlePanGesture(_ gesture: UIPanGestureRecognizer){
        let translation = gesture.translation(in: view)
        
        if gesture.state == .began {
            
            newlyCreatedFace = gesture.view as? UIImageView
            newlyCreatedFaceOriginalCenter = newlyCreatedFace.center
        } else if gesture.state == .changed {
            newlyCreatedFace.center = CGPoint(x: newlyCreatedFaceOriginalCenter.x + translation.x, y: newlyCreatedFaceOriginalCenter.y + translation.y)
        } else if gesture.state == .ended {
            
        }
    }
}
