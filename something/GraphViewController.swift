//
//  ViewController.swift
//  something
//
//  Created by HoangDucLe on 3/17/16.
//  Copyright © 2016 HoangDucLe. All rights reserved.
//

import UIKit


class GraphViewController: UIViewController, GraphViewDataSource {
    
    private var brain = CalculatorBrain()
    
    var program: AnyObject {
        get {
            return brain.program
        }
        set {
            brain.program = newValue
        }
    }
    
    @IBOutlet weak var graphView: GraphView! {
        didSet {
            graphView.dataSource = self
            graphView.addGestureRecognizer(UIPinchGestureRecognizer(target: graphView, action: "scale:"))
            graphView.addGestureRecognizer(UIPanGestureRecognizer(target: graphView, action: "panGraph:"))
            let tap = UITapGestureRecognizer(target: graphView, action: "tapGraph:")
            tap.numberOfTapsRequired = 2
            graphView.addGestureRecognizer(tap)
        }
    }
    
    func y(x: CGFloat) -> CGFloat? {
        brain.variableValues["M"] = Double(x)
        if let y = brain.evaluate() {
            return CGFloat(y)
        }
        return nil
	}
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        var destination = segue.destinationViewController as? UIViewController
        if let nvc = destination as? UINavigationController {
            destination = nvc.visibleViewController
        }
        if let gvc = destination as? GraphViewController {
            if let identifier = segue.identifier {
                switch identifier {
                case "graph":
                    gvc.title = brain.descript == "" ? "Graph" : brain.descript.componentsSeparatedByString(", ").last
                    gvc.program = brain.program
                default: break
                }
            }
        }
    }
}

    




