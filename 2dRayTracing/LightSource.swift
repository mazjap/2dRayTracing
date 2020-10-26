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
            delegate?.positionDidChange(to: position)
        }
    }
    
    // Amount of rays to be displayed
    var accuracy: Int {
        didSet {
            rays = getRays()
            delegate?.accuracyDidChange(to: accuracy)
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
    
    func look(at line: Line) -> [Line] {
        var lines = [Line]()
        for ray in rays {
            if let point = ray.intersects(line: line) {
                lines.append(Line(start: ray.position, end: point))
            }
        }
        
        return lines
    }
}

protocol LightSourceDelegate: AnyObject {
    func positionDidChange(to position: CGPoint)
    func accuracyDidChange(to accuracy: Int)
}
