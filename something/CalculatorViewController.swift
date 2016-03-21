//
//  ViewController.swift
//  Calculator
//
//  Created by HoangDucLe on 2/10/16.
//  Copyright © 2016 HoangDucLe. All rights reserved.
//

import UIKit

class CalculatorViewController: UIViewController {
    

    @IBOutlet weak var display: UILabel!
    
    var userIsTyping = false
    
    private var brain = CalculatorBrain()
    
    @IBAction func appendDigit(sender: UIButton) {
        let digit = sender.currentTitle!
        if userIsTyping {
            display.text = display.text! + digit
            inputHistory.text = inputHistory.text! + digit
        }   else    {
            display.text=digit
            inputHistory.text = digit
            userIsTyping = true
        }
    }
    
    
    @IBAction func enter() {
        userIsTyping = false
        
        if let result = brain.pushOperand(displayValue!) {
            displayValue = result
        } else {
            displayValue = nil
        }
    }
    
    var displayValue: Double? {
        get {
            return  NSNumberFormatter().numberFromString(display.text!)?.doubleValue
        }
        set {
            if let strValue = newValue {
                display.text = "\(strValue)"
            }
            else {
                display.text = ""
            }
            userIsTyping = false
            inputHistory.text = brain.descript + "="
        }
    }

    @IBAction func decimaldot(sender: AnyObject) {
        if (!display.text!.containsString(".")) {
            display.text = display.text! + "."
        }
        if (!inputHistory.text!.containsString(".")) {
            inputHistory.text = inputHistory.text! + "."
        }
    }
    
    
    @IBAction func operate(sender: UIButton) {
        if userIsTyping {
            enter()
        }
        
        if let operation = sender.currentTitle {
            if let result = brain.performOperation(operation) {
                displayValue = result
            } else {
                displayValue = nil
            }
        }
    }
    
    @IBAction func Mbutton(sender: UIButton) {
        if userIsTyping {
            enter()
        }
        if let result = brain.pushOperand("M") {
            displayValue = result
        } else {
            displayValue = nil
        }
        userIsTyping = false
    }

    @IBAction func toMbutton(sender: UIButton) {
        brain.variableValues["M"] = displayValue
        if let result = brain.evaluate() {
            displayValue = result
        } else {
            displayValue = nil
        }
    }
    
    @IBAction func graphButton() {
        performSegueWithIdentifier("graph", sender: nil)
    }
    
    @IBOutlet weak var inputHistory: UILabel!
    
    @IBAction func Clear() {
        brain.clearStack()
        display.text = "0"
        inputHistory.text=""
        userIsTyping = false
        brain.variableValues.removeValueForKey("M")
    }
    
    

    
}




