//
//  DrawableView.swift
//  2dRayTracing
//
//  Created by Jordan Christensen on 10/25/20.
//

import UIKit

class DrawableView: UIView {
    // setNeedsDisplay for each variable to call the draw(_:) function at next update cycle
    var lines = [Line]() {
        didSet {
            setNeedsDisplay()
        }
    }
    
    var boundaryColor: CGColor {
        didSet {
            setNeedsDisplay()
        }
    }
    var lightColor: CGColor {
        didSet {
            setNeedsDisplay()
        }
    }
    var lineWidth: CGFloat {
        didSet {
            setNeedsDisplay()
        }
    }
    var lightSourceCircleSize: CGFloat {
        didSet {
            setNeedsDisplay()
        }
    }
    
    let light = LightSource(position: CGPoint(x: 0, y: 0), accuracy: 0)
    
    init(boundaryColor: UIColor, lightColor: UIColor, lineWidth: CGFloat, lightWidth: CGFloat, frame: CGRect) {
        self.boundaryColor = boundaryColor.cgColor
        self.lightColor = lightColor.cgColor
        self.lineWidth = lineWidth
        self.lightSourceCircleSize = lightWidth
        
        super.init(frame: frame)
        
        light.delegate = self
    }
    
    required init?(coder: NSCoder) {
        self.boundaryColor = UIColor.gray.cgColor
        self.lightColor = UIColor.yellow.cgColor
        self.lineWidth = 10
        self.lightSourceCircleSize = lineWidth * 2
        
        super.init(coder: coder)
        
        light.delegate = self
    }
    
    override func draw(_ rect: CGRect) {
        guard let context = UIGraphicsGetCurrentContext() else { return }
        // Clear previously drawn stuff
        context.clear(rect)
        
        context.setStrokeColor(boundaryColor)
        context.setLineCap(.round)
        context.setLineWidth(lineWidth)
        
        // Draw each boundary
        for line in lines {
            context.move(to: line.startPoint)
            context.addLine(to: line.endPoint)
            
            context.strokePath()
        }
        
        context.setStrokeColor(lightColor)
        
        // Draw each rayLine calculated in light.look
        for rayLine in light.look(at: lines) {
            context.move(to: rayLine.startPoint)
            context.addLine(to: rayLine.endPoint)
            
            context.strokePath()
        }
        
        context.setFillColor(lightColor)
        
        // Draw light sources center with init-defined size
        context.fillEllipse(in: CGRect(x: light.position.x - lightSourceCircleSize / 2,
                                       y: light.position.y - lightSourceCircleSize / 2,
                                       width: lightSourceCircleSize,
                                       height: lightSourceCircleSize))
    }
    
    func addLines(_ newLines: [Line]) {
        self.lines.append(contentsOf: newLines)
    }
    
    func add(line: Line) {
        self.lines.append(line)
    }
    
    func changeLightSourcePosition(to point: CGPoint) {
        light.position = point
    }
    
    func changeLightSourcePosition(by size: CGSize) {
        light.position.x += size.width
        light.position.y += size.height
    }
    
    func setAccuacy(to newVal: Int) {
        light.accuracy = newVal
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let point = touches.first?.location(in: self) {
            changeLightSourcePosition(to: point)
        }
    }
}

extension DrawableView: LightSourceDelegate {
    func positionDidChange(to position: CGPoint) {
        setNeedsDisplay()
    }
    
    func accuracyDidChange(to accuracy: Int) {
        setNeedsDisplay()
    }
}
