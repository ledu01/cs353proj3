//
//  CalculatorBrain.swift
//  Calculator
//
//  Created by HoangDucLe on 2/18/16.
//  Copyright © 2016 HoangDucLe. All rights reserved.
//

import Foundation

class CalculatorBrain {
    private enum Op {
        case variable(String)
        case constant(String)
        case Operand(Double)
        case UnaryOperation(String, Double -> Double)
        case BinaryOperation(String, (Double, Double) -> Double)
        
        var description: String {
            get {
                switch self {
                case .variable(let symbol):
                    return symbol
                case .constant(let symbol):
                    return symbol
                case .Operand(let operand):
                    return "\(operand)"
                case .UnaryOperation(let symbol, _):
                    return symbol
                case .BinaryOperation(let symbol, _):
                    return symbol
                }
            }
            
        }
    }
    
    private var opStack = [Op]()
    
    private var knownOps = [String:Op]()
    
    var variableValues = [String:Double]()
    
    
    init() {
        knownOps["×"] = Op.BinaryOperation("×") {$0 * $1}
        knownOps["÷"] = Op.BinaryOperation("÷") {$1 / $0}
        knownOps["+"] = Op.BinaryOperation("+") {$0 + $1}
        knownOps["−"] = Op.BinaryOperation("−") {$1 - $0}
        knownOps["√"] = Op.UnaryOperation("√") {sqrt($0)}
        knownOps["cos"] = Op.UnaryOperation("cos") {cos((($0)*M_PI)/180.0)}
        knownOps["sin"] = Op.UnaryOperation("sin") {sin((($0)*M_PI)/180.0)}
        knownOps["π"] = Op.constant("π")
    }
    
    var program: AnyObject {
        get {
            return opStack.map { $0.description }
        }
        set {
            if let opSymbols = newValue as? Array<String> {
                var newOpStack = [Op]()
                for opSymbol in opSymbols {
                    if let op = knownOps[opSymbol] {
                        newOpStack.append(op)
                    } else if let operand = NSNumberFormatter().numberFromString(opSymbol)?.doubleValue {
                        newOpStack.append(.Operand(operand))
                    } else {
                        newOpStack.append(.variable(opSymbol))
                    }
                }
                opStack = newOpStack
            }
        }
    }
    
    private func evaluate(ops: [Op]) -> (result: Double?, remainingOps: [Op]) {
        if !ops.isEmpty {
            var remainingOps = ops
            let op = remainingOps.removeLast()
            switch op {
            case .variable(let symbol):
                return (variableValues[symbol],remainingOps)
            case .constant(_):
                return (M_PI, remainingOps)
            case .Operand(let operand):
                return (operand,remainingOps)
            case .UnaryOperation(_, let operation):
                let operandEvaluation = evaluate(remainingOps)
                if let operand = operandEvaluation.result {
                    return (operation(operand), operandEvaluation.remainingOps)
                }
            case .BinaryOperation(_, let operation):
                let op1Evaluation = evaluate(remainingOps)
                if let operand1 = op1Evaluation.result {
                    let op2Evaluation = evaluate(op1Evaluation.remainingOps)
                    if let operand2 = op2Evaluation.result {
                        return (operation(operand1, operand2), op2Evaluation.remainingOps)
                    }
                }
            }
        }
        return (nil,ops)
    }
    
    var descript: String {
        get {
            var bothExpression = ""
            var leftover = opStack
            while leftover.count > 0 {
                var typedExpression: String?
                (typedExpression, leftover) = description(leftover)
                if bothExpression == "" {
                    bothExpression = typedExpression!
                } else {
                    bothExpression = "\(typedExpression!),\(bothExpression)"
                }
            }
            return bothExpression
        }
    }
    
    private func description(ops: [Op]) -> (result: String?, remainingOps: [Op]) {
        if !ops.isEmpty {
            var remainingOps = ops
            let op = remainingOps.removeLast()
            switch op {
            case .variable(let symbol):
                return (symbol, remainingOps)
            case .constant(let symbol):
                return (symbol, remainingOps)
            case .Operand(let operand):
                return ("\(operand)",remainingOps)
            case .UnaryOperation(let symbol, _):
                let operandDescription = description(remainingOps)
                if let operand = operandDescription.result {
                    return ("\(symbol)(\(operand))", operandDescription.remainingOps)
                }
            case .BinaryOperation(let symbol, _):
                let op1Description = description(remainingOps)
                if let operand1 = op1Description.result {
                    let op2Description = description(op1Description.remainingOps)
                    if let operand2 = op2Description.result {
                        return ("(\(operand2) \(symbol) \(operand1))", op2Description.remainingOps)
                    }
                }
            }
        }
        return ("?",ops)
    }
    
    func evaluate() -> Double? {
        let (result, remainder) = evaluate(opStack)
        print("\(opStack) = \(result) with \(remainder) left over")
        return result
    }
    
    func pushOperand(operand: Double) -> Double?{
        opStack.append(Op.Operand(operand))
        return evaluate()
    }
    
    func pushOperand(symbol: String) -> Double?{
        opStack.append(Op.variable(symbol))
        return evaluate()
    }
    
    func performOperation(symbol: String) -> Double? {
        if let operation = knownOps[symbol] {
            opStack.append(operation)
        }
        return evaluate()
    }
    
    func clearStack() {
        opStack.removeAll()
    }
  

    
}

















