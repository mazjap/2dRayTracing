//
//  DrawableView.swift
//  2dRayTracing
//
//  Created by Jordan Christensen on 10/25/20.
//

import UIKit

class DrawableView: UIView {
    var lines = [Line]() {
        didSet {
            setNeedsDisplay()
        }
    }
    
    var color: CGColor {
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
    
    init(color: UIColor, lineWidth: CGFloat, frame: CGRect) {
        self.color = color.cgColor
        self.lineWidth = lineWidth
        self.lightSourceCircleSize = lineWidth * 2
        
        super.init(frame: frame)
        
        light.delegate = self
    }
    
    required init?(coder: NSCoder) {
        self.color = UIColor.black.cgColor
        self.lineWidth = 10
        self.lightSourceCircleSize = lineWidth * 2
        
        super.init(coder: coder)
        
        light.delegate = self
    }
    
    override func draw(_ rect: CGRect) {
        guard let context = UIGraphicsGetCurrentContext() else { return }
        
        for line in lines {
            context.move(to: line.startPoint)
            context.addLine(to: line.endPoint)
        }
        
        for ray in light.rays {
            context.move(to: ray.position)
            context.addLine(to: ray.secondaryPosition)
        }
        
        context.setLineCap(.round)
        context.setLineWidth(lineWidth)
        context.setStrokeColor(color)
        
        context.addEllipse(in: CGRect(x: light.position.x - lightSourceCircleSize / 2,
                                      y: light.position.y - lightSourceCircleSize / 2,
                                      width: lightSourceCircleSize,
                                      height: lightSourceCircleSize))
        
        context.setFillColor(color)
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
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
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
