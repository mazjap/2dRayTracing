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
    
    // Did this instead of computed 'rays' variable to save some computational time
    private func getRays() -> [Ray] {
        var temp = [Ray]()
        
        // Creates n rays, n being accuracy, in a circle around position
        for i in 0..<accuracy {
            temp.append(Ray(position: position, direction: CGFloat(i) / CGFloat(accuracy) * .pi * 2))
        }
        
        return temp
    }
    
    // Find nearest boundary that each ray intersects, return a line between those two points
    func look(at lines: [Line], completion: @escaping ([Line]) -> Void) {
        var temp = [Line]()
        
        for ray in rays {
            getPoint(for: ray, with: lines) { line in
                DispatchQueue.main.async {
                    temp.append(line)
                    if temp.count == self.rays.count {
                        completion(temp)
                    }
                }
            }
        }
    }
    
    private func getPoint(for ray: Ray, with lines: [Line], completion: @escaping (Line) -> Void) {
        DispatchQueue.global(qos: .userInteractive).async {
            var closest: CGPoint? = nil
            var record = CGFloat.greatestFiniteMagnitude
            
            for line in lines {
                if let point = ray.intersects(line: line) {
                    let d = self.getDistance(from: self.position, to: point)
                    if d < record {
                        record = d
                        closest = point
                    }
                }
            }
            
            if let unwrappedClosest = closest {
                completion(Line(start: ray.position, end: unwrappedClosest))
            }
        }
    }
    
    // Calculate distance between two points: Square root of ((x2 - x1) + (y2 - y1))
    func getDistance(x1: CGFloat, y1: CGFloat, x2: CGFloat, y2: CGFloat) -> CGFloat {
        let a = x1 - x2
        let b = y1 - y2
        
        return sqrt(a * a + b * b)
    }
    
    func getDistance(from p1: CGPoint, to p2: CGPoint) -> CGFloat {
        return getDistance(x1: p1.x, y1: p1.y, x2: p2.x, y2: p2.y)
    }
}

protocol LightSourceDelegate: AnyObject {
    func positionDidChange(to position: CGPoint)
    func accuracyDidChange(to accuracy: Int)
}
