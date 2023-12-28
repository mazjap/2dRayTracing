import UIKit

class DrawableView: UIView {
    // setNeedsDisplay for each variable to call the draw(_:) function at next update cycle
    var boundries = [Line]() {
        didSet {
            update()
        }
    }
    
    var lines = [Line]() {
        didSet {
            setNeedsDisplay()
        }
    }
    
    var boundaryColor: CGColor {
        didSet {
            update(false)
        }
    }
    var lightColor: CGColor {
        didSet {
            update(false)
        }
    }
    var lineWidth: CGFloat {
        didSet {
            update(false)
        }
    }
    var lightSourceCircleSize: CGFloat {
        didSet {
            update(false)
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
        for line in boundries {
            context.move(to: line.startPoint)
            context.addLine(to: line.endPoint)
            
            context.strokePath()
        }
        
        context.setStrokeColor(self.lightColor)
        
        // Draw each rayLine calculated in light.look
        for rayLine in lines {
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
    
    private func update(_ updateList: Bool = true) {
        if updateList {
            light.look(at: boundries) { lineList in
                self.lines = lineList
            }
        } else {
            setNeedsDisplay()
        }
    }
    
    func addLines(_ newLines: [Line]) {
        self.boundries.append(contentsOf: newLines)
    }
    
    func add(line: Line) {
        self.boundries.append(line)
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
        update()
    }
    
    func accuracyDidChange(to accuracy: Int) {
        update()
    }
}
