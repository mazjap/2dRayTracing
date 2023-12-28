//
//  RayTracingView.swift
//  2dRayTracing
//
//  Created by Jordan Christensen on 12/27/23.
//

import SwiftUI

struct RayTracingView: View {
    @Binding private var lightPosition: CGPoint
    @Binding private var lightDirection: Angle
    @Binding private var rayCount: Int
    @Binding private var walls: [Line]
    @State private var gestureRotation = Angle.zero
    
    private let halfFOVDegrees: Double
    private let maxTravelDistance: Double
    
    init(lightPosition: Binding<CGPoint>, lightDirection: Binding<Angle>, rayCount: Binding<Int>, walls: Binding<[Line]>, halfFOVDegrees: Double = 40, maxTravelDistance: Double = 500) {
        self._lightPosition = lightPosition
        self._lightDirection = lightDirection
        self._rayCount = rayCount
        self._walls = walls
        self.halfFOVDegrees = halfFOVDegrees
        self.maxTravelDistance = maxTravelDistance
    }
    
    var body: some View {
        GeometryReader { geometry in
            Canvas { context, size in
                let bounds = CGRect(origin: .zero, size: size)
                
                context.drawLayer { context in // Draw Background
                    context.fill(Path() <- { $0.addRect(bounds) }, with: .color(Color(uiColor: .darkGray)))
                }
                
                context.drawLayer { context in // Draw walls
                    for wall in walls {
                        context.stroke(
                            wall.path,
                            with: .color(.white),
                            lineWidth: 2
                        )
                    }
                }
                
                context.drawLayer { context in // Draw Rays
                    for i in 0..<rayCount {
                        let percent = Double(i) / Double(rayCount - 1)
                        let angle = Angle(degrees: (lightDirection.degrees + gestureRotation.degrees - halfFOVDegrees) + (halfFOVDegrees * 2 * percent))
                        
                        context.stroke(lineToFirstIntersetion(travelingIn: angle, bounds: bounds).path, with: .color(.yellow), lineWidth: 2)
                    }
                }
            }
            .onTapGesture { location in
                lightPosition = location
            }
            .gesture(DragGesture()
                .onChanged { value in
                    lightPosition = value.location
                }
                .onEnded { value in
                    lightPosition = value.location
                }
            )
            .gesture(RotateGesture()
                .onChanged { value in
                    gestureRotation = value.rotation
                }
                .onEnded { value in
                    lightDirection = .degrees(lightDirection.degrees + gestureRotation.degrees)
                    gestureRotation = .zero
                }
            )
            .task {
                lightPosition = CGPoint(x: geometry.size.width / 2, y: geometry.size.height / 2)
                addWalls(10, geometry.size)
            }
        }
    }
    
    struct Quadrant: OptionSet {
        var rawValue: Int8
        
        static let topLeading = Quadrant(rawValue: 1 << 0)
        static let topTrailing = Quadrant(rawValue: 1 << 1)
        static let bottomTrailing = Quadrant(rawValue: 1 << 2)
        static let bottomLeading = Quadrant(rawValue: 1 << 3)
    }
    
    private func lineToFirstIntersetion(travelingIn direction: Angle, bounds: CGRect) -> Line {
        let cosDirection = cos(direction.radians)
        let sinDirection = sin(direction.radians)
        var x = cosDirection * maxTravelDistance + lightPosition.x
        var y = sinDirection * maxTravelDistance + lightPosition.y
        var distance = Line(start: lightPosition, end: CGPoint(x: x, y: y)).distance
        
        func quadrant(for point: CGPoint) -> Quadrant {
            let diffX = lightPosition.x - point.x
            let diffY = lightPosition.y - point.y
            
            if diffX >= 0 && diffY >= 0 {
                return .topTrailing
            } else if diffY >= 0 {
                return .topLeading
            } else if diffX >= 0 {
                return .bottomTrailing
            } else {
                return .bottomLeading
            }
        }
        
        for wall in walls {
            // Check whether wall line points are within angle's quadrant
            let lineQuadrant = quadrant(for: CGPoint(x: x, y: y))
            let wallQuadrants = [quadrant(for: wall.startPoint), quadrant(for: wall.endPoint)]
            // Diagonals = bad
            let tooClose = (wallQuadrants.contains(.topLeading) && wallQuadrants.contains(.bottomTrailing)) ||
                           (wallQuadrants.contains(.topTrailing) && wallQuadrants.contains(.bottomLeading))
            
            if !tooClose {
                guard Quadrant(wallQuadrants).contains(lineQuadrant) else { continue }
            }
            
            let x1 = wall.startPoint.x
            let y1 = wall.startPoint.y
            let x2 = wall.endPoint.x
            let y2 = wall.endPoint.y
            
            let x3 = lightPosition.x
            let y3 = lightPosition.y
            let x4 = x
            let y4 = y
            
            // Found here: https://en.wikipedia.org/wiki/Line-line_intersection
            
            let denominator = (x1 - x2) * (y3 - y4) - (y1 - y2) * (x3 - x4)
            
            guard denominator != 0 else { continue }
            
            let t =  ((x1 - x3) * (y3 - y4) - (y1 - y3) * (x3 - x4)) / denominator
            let u = -((x1 - x2) * (y1 - y3) - (y1 - y2) * (x1 - x3)) / denominator
            
            guard t > 0 && t < 1 && u > 0 else { continue }
            
            let newX = x1 + t * (x2 - x1)
            let newY = y1 + t * (y2 - y1)
            let newDistance = Line(start: lightPosition, end: CGPoint(x: newX, y: newY)).distance
            
            guard newDistance < distance else { continue }
            x = newX
            y = newY
            distance = newDistance
        }
        
        return Line(start: lightPosition, end: CGPoint(x: x, y: y))
    }
    
    private func addWalls(_ count: Int, _ size: CGSize) {
        let xRange = 0...size.width
        let yRange = 0...size.height
        for _ in 0..<count {
            walls.append(Line(
                start: CGPoint(x: CGFloat.random(in: xRange), y: CGFloat.random(in: yRange)),
                end: CGPoint(x: CGFloat.random(in: xRange), y: CGFloat.random(in: yRange))
            ))
        }
    }
}

extension Line {
    var path: Path {
        Path() <- {
            $0.move(to: startPoint)
            $0.addLine(to: endPoint)
        }
    }
}

#Preview {
    ContentView()
}
