//
//  ContentView.swift
//  2dRayTracing
//
//  Created by Jordan Christensen on 12/26/23.
//

import SwiftUI

struct ContentView: View {
    @Environment(\.dismiss) private var dismiss
    @State private var lightPosition = CGPoint(x: 100, y: 100)
    @State private var lightDirection = Angle.zero
    @State private var rayCount: Int = 20
    @State private var walls = [Line]()
    
    private var sliderRayCountBinding: Binding<Double> {
        Binding {
            Double(rayCount)
        } set: {
            rayCount = Int($0)
        }
    }
    
    private var sliderDirectionBinding: Binding<Double> {
        Binding {
            lightDirection.degrees
        } set: {
            lightDirection = .degrees($0)
        }
    }
    
    var body: some View {
        VStack {
            RayTracingView(lightPosition: $lightPosition, lightDirection: $lightDirection, rayCount: $rayCount, walls: $walls)
                .ignoresSafeArea(.all, edges: [.top, .leading, .trailing])
            
            Slider(value: sliderRayCountBinding, in: 2...100)
            
            Text("Rays: \(rayCount)")
            
            Spacer()
                .frame(height: 10)
            
            Button("UIKit", action: dismiss.callAsFunction)
        }
        .safeAreaPadding(EdgeInsets(top: 0, leading: 8, bottom: 0, trailing: 8))
    }
}

#Preview {
    ContentView()
}
