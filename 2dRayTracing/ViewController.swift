//
//  ViewController.swift
//  2dRayTracing
//
//  Created by Jordan Christensen on 10/25/20.
//
//  Following The Coding Train's tutorial for P5.js: https://www.youtube.com/watch?v=TOEi6T2mtHo

import UIKit

class ViewController: UIViewController {
    var drawableView: DrawableView!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        drawableView = DrawableView(color: .red, lineWidth: 2, lightWidth: 10, frame: view.bounds)
        view.addSubview(drawableView)
        
        drawableView.changeLightSourcePosition(to: CGPoint(x: 50, y: 50))
        drawableView.setAccuacy(to: 20)
        drawableView.addLines([Line(x1: 100, y1: 0, x2: 100, y2: 100)])
        
        for ray in drawableView.light.rays {
            for line in drawableView.lines {
                print(ray.intersects(line: line))
            }
        }
    }
}

