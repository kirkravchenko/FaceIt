//
//  ViewController.swift
//  FaceIt
//
//  Created by Kyrylo Kravchenko on 13.12.2021.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var faceView: FaceView! {
        didSet {
            let handler = #selector(FaceView.changeScale(byReactingTo:))
            let pitchRecognizer = UIPinchGestureRecognizer(target: faceView, action: handler)
            faceView.addGestureRecognizer(pitchRecognizer)
            let tapRecognizer = UITapGestureRecognizer(
                target: self, action: #selector(toggleEyes(byReactingTo:))
            )
            tapRecognizer.numberOfTapsRequired = 1
            faceView.addGestureRecognizer(tapRecognizer)
            let swipeUpRecognizer = UISwipeGestureRecognizer(target: self, action: #selector(increaseHappines))
            swipeUpRecognizer.direction = .up
            faceView.addGestureRecognizer(swipeUpRecognizer)
            let swipeDownRecognizer = UISwipeGestureRecognizer(target: self, action: #selector(decreaseHappines))
            swipeDownRecognizer.direction = .down
            faceView.addGestureRecognizer(swipeDownRecognizer)
            updateUI()
        }
    }
    
    @objc func toggleEyes(byReactingTo tapRecognizer: UITapGestureRecognizer) {
        if tapRecognizer.state == .ended {
            let eyes: FacialExpression.Eyes = (expression.eyes == .closed) ? .open : .closed
            expression = FacialExpression(eyes: eyes, mouth: expression.mouth )
        }
    }
     
    @objc func increaseHappines() {
        expression = expression.happier
    }
    
    @objc func decreaseHappines() {
        expression = expression.sadder
    }
    
    var expression = FacialExpression(eyes: .closed, mouth: .smile) {
        didSet {
            updateUI()
        }
    }
    
    private func updateUI() {
        switch expression.eyes {
        case .open:
            faceView?.eyesOpen = true
        case .closed:
            faceView?.eyesOpen = false
        case .squinting:
            faceView?.eyesOpen = false
        }
        faceView.mouthCurveture = mouthCurvatures[expression.mouth] ?? 0.0
    }
    
    private let mouthCurvatures = [
        FacialExpression.Mouth.frown:-1.0,
        FacialExpression.Mouth.smirk:-0.5,
        FacialExpression.Mouth.neutral:0.0,
        FacialExpression.Mouth.grin:0.5,
        FacialExpression.Mouth.smile:1.0,
    ]
}

