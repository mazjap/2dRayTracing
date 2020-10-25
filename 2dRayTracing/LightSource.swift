//
//  LightSource.swift
//  2dRayTracing
//
//  Created by Jordan Christensen on 10/25/20.
//

import CoreGraphics

class LightSource {
    // Position of light source
    var position: CGPoint {
        didSet {
            rays = getRays()
        }
    }
    
    // Amount of rays to be displayed
    var accuracy: Int {
        didSet {
            rays = getRays()
        }
    }
    
    weak var delegate: LightSourceDelegate?
    
    private(set) var rays: [Ray]
    
    init(position: CGPoint, accuracy: Int) {
        self.position = position
        self.accuracy = accuracy
        self.rays = []; rays = getRays()
    }
    
    private func getRays() -> [Ray] {
        var temp = [Ray]()
        
        // Creates n rays, n being accuracy, in a circle around position
        for i in 0..<accuracy {
            temp.append(Ray(position: position, direction: CGFloat(i) / CGFloat(accuracy) * .pi * 2))
        }
        
        return temp
    }
}

protocol LightSourceDelegate: AnyObject {
    func positionDidChange(to position: CGPoint)
    func accuracyDidChange(to accuracy: Int)
}
