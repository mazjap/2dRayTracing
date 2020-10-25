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

    init(start: CGPoint, end: CGPoint) {
        self.startPoint = start
        self.endPoint = end
    }
    
    init(x1: Double, y1: Double, x2: Double, y2: Double) {
        self.init(start: CGPoint(x: x1, y: y1), end: CGPoint(x: x2, y: y2))
    }
}
