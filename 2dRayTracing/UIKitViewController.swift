//
//  UIKitViewController.swift
//  2dRayTracing
//
//  Created by Jordan Christensen on 10/25/20.
//
//  Following The Coding Train's tutorial in P5.js: https://www.youtube.com/watch?v=TOEi6T2mtHo

import SwiftUI

class UIKitViewController: UIViewController {
    var drawableView: DrawableView!
    
    // To adjust accuracy (meaning amount of rays)
    var slider: UISlider!
    var label: UILabel!
    
    var swiftuiButton: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        drawableView = DrawableView(boundaryColor: .gray, lightColor: .yellow, lineWidth: 2, lightWidth: 5, frame: CGRect(origin: .zero, size: CGSize(width: view.bounds.width, height: view.bounds.height - 250)))
        slider = UISlider(frame: CGRect(x: 16, y: drawableView.frame.maxY + 16, width: view.bounds.width - 32, height: 100))
        label = UILabel(frame: CGRect(x: 0, y: slider.frame.maxY + 8, width: view.bounds.width, height: 50))
        swiftuiButton = UIButton(frame: CGRect(x: 0, y: label.frame.maxY + 8, width: view.bounds.width, height: 50))
        
        setup()
    }
    
    private func setup() {
        slider.minimumValue = 0
        slider.maximumValue = 1000
        slider.addTarget(self, action: #selector(sliderChanged(_:)), for: .valueChanged)
        
        slider.value = 20
        
        label.text = "20"
        label.textAlignment = .center
        label.textColor = .black
        
        swiftuiButton.setTitle("SwiftUI", for: .normal)
        swiftuiButton.setTitleColor(.blue, for: .normal)
        swiftuiButton.addTarget(self, action: #selector(presentSwiftUIView(_:)), for: .touchUpInside)
        
        drawableView.changeLightSourcePosition(to: CGPoint(x: 50, y: 50))
        drawableView.setAccuacy(to: 20)
        drawableView.addLines([
            Line(start: drawableView.frame.origin, end: CGPoint(x: drawableView.frame.maxX, y: 0)),
            Line(start: drawableView.frame.origin, end: CGPoint(x: 0, y: drawableView.bounds.maxY)),
            Line(start: CGPoint(x: 0, y: drawableView.bounds.maxY), end: CGPoint(x: drawableView.bounds.maxX, y: drawableView.bounds.maxY)),
            Line(start: CGPoint(x: drawableView.bounds.maxX, y: drawableView.bounds.maxY), end: CGPoint(x: drawableView.bounds.maxX, y: 0)),
            generateRandomLine(), generateRandomLine(), generateRandomLine(),
            generateRandomLine(), generateRandomLine(), generateRandomLine()
        ])
        
        view.addSubview(drawableView)
        view.addSubview(slider)
        view.addSubview(label)
        view.addSubview(swiftuiButton)
    }
    
    private func generateRandomLine() -> Line {
        let xRange = 0..<drawableView.bounds.width
        let yRange = 0..<drawableView.bounds.height
        
        return Line(x1: CGFloat.random(in: xRange), y1: CGFloat.random(in: yRange), x2: CGFloat.random(in: xRange), y2: CGFloat.random(in: yRange))
    }
    
    @objc
    private func sliderChanged(_ sender: UISlider) {
        let value = Int(sender.value)
        label.text = String(value)
        drawableView.setAccuacy(to: value)
    }
    
    @objc
    private func presentSwiftUIView(_ button: UIButton) {
        let vc = UIHostingController(rootView: ContentView())
        vc.modalPresentationStyle = .fullScreen
        present(vc, animated: true)
    }
}

#Preview {
    struct UIKitRep: UIViewControllerRepresentable {
        func makeUIViewController(context: Context) -> UIKitViewController {
            UIKitViewController()
        }
        
        func updateUIViewController(_ uiViewController: UIKitViewController, context: Context) {}
    }
    
    return UIKitRep()
}
