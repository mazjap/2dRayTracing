//
//  Line.swift
//  2dRayTracing
//
//  Created by Jordan Christensen on 10/25/20.
//

import CoreGraphics

struct Line {
    let startPoint: CGPoint
    let endPoint: CGPoint
    
    var distance: CGFloat {
        let xComponent = endPoint.x - startPoint.x
        let yComponent = endPoint.y - startPoint.y
        
        return sqrt(xComponent * xComponent + yComponent * yComponent)
    }

    init(start: CGPoint, end: CGPoint) {
        self.startPoint = start
        self.endPoint = end
    }
    
    init<T: BinaryFloatingPoint>(x1: T, y1: T, x2: T, y2: T) {
        self.init(start: CGPoint(x: Double(x1), y: Double(y1)), end: CGPoint(x: Double(x2), y: Double(y2)))
    }
}
