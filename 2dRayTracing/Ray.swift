//
//  Ray.swift
//  2dRayTracing
//
//  Created by Jordan Christensen on 10/25/20.
//

import CoreGraphics

struct Ray {
    var position: CGPoint
    var direction: CGFloat
    
    var secondaryPosition: CGPoint {
        CGPoint(x: position.x + cos(direction), y: position.y + sin(direction))
    }
    
    init(position: CGPoint, direction: CGFloat) {
        self.position = position
        self.direction = direction
    }
    
    func intersects(line: Line) -> CGPoint? {
        let p2 = secondaryPosition
        
        let x1 = line.startPoint.x
        let y1 = line.startPoint.y
        let x2 = line.endPoint.x
        let y2 = line.endPoint.y
        
        let x3 = position.x
        let y3 = position.y
        let x4 = p2.x
        let y4 = p2.y
        
        let denominator = (x1 - x2) * (y3 - y4) - (y1 - y2) * (x3 - x4)
        
        if denominator == 0 {
            return nil
        }
        
        let t =  ((x1 - x3) * (y3 - y4) - (y1 - y3) * (x3 - x4)) / denominator
        let u = -((x1 - x2) * (y1 - y3) - (y1 - y2) * (x1 - x3)) / denominator
        
        
        if t > 0 && t < 1 && u > 0 {
            return CGPoint(x: x1 + t * (x2 - x1), y: y1 + t * (y2 - y1))
        }
        
        return nil
    }
}
