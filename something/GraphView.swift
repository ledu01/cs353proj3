//
//  GraphView.swift
//  something
//
//  Created by HoangDucLe on 3/17/16.
//  Copyright © 2016 HoangDucLe. All rights reserved.
//

import UIKit

protocol GraphViewDataSource: class {
    func y(x: CGFloat) -> CGFloat? 
}

@IBDesignable
class GraphView: UIView {
    
    
    var coordinateSize: CGSize {
        return UIScreen.mainScreen().bounds.size
    }
    
    var aUnit: CGFloat = 30
    @IBInspectable
    var lineWidth: CGFloat = 3 { didSet { setNeedsDisplay() } }
    @IBInspectable
    var color: UIColor = UIColor.blackColor() { didSet { setNeedsDisplay() } }
    @IBInspectable
    var scale: CGFloat = 0.50 { didSet { setNeedsDisplay() } }

    var graphOrigin: CGPoint = CGPoint() { didSet { setNeedsDisplay() } }

    
    weak var dataSource: GraphViewDataSource?
    
    func scale(gesture: UIPinchGestureRecognizer) {
        if gesture.state == .Changed {
            scale *= gesture.scale
            gesture.scale = 1
        }
    }
    
    func panGraph(gesture: UIPanGestureRecognizer) {
        switch gesture.state {
        case .Ended: fallthrough
        case .Changed:
            let translation = gesture.translationInView(self)
            graphOrigin.x += translation.x
            graphOrigin.y += translation.y
            gesture.setTranslation(CGPointZero, inView: self)
        default: break
        }
    }

    func tapGraph(gesture: UITapGestureRecognizer) {
        if gesture.state == .Ended {
            graphOrigin = gesture.locationInView(self)
        }
    }
    
    override func drawRect(rect: CGRect) {
        let drawAxes = AxesDrawer(contentScaleFactor: contentScaleFactor)
        drawAxes.drawAxesInRect(bounds, origin: graphOrigin, pointsPerUnit: 30)
        color.set()
        let path = UIBezierPath()
        path.lineWidth = lineWidth
        var point = CGPoint()
        for var i = 0; i <= Int(UIScreen.mainScreen().bounds.size.width * contentScaleFactor); i++ {
            point.x = CGFloat(i) / contentScaleFactor
            if let y = dataSource?.y((point.x - graphOrigin.x) / scale) {
                point.y = graphOrigin.y - y * scale
                path.moveToPoint(point)
                path.addLineToPoint(point)
            }
        path.stroke()
		}
	}
}




