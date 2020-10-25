//
//  Calculator.swift
//  Calculator
//
//  Created by zero on 2020/10/20.
//

import Foundation

class Calculator {
    var displayString : String {
        if !typingDecimalString.isEmpty {
            return typingDecimalString
        } else if let val = currentValue {
            return displayString(of: val)
        } else {
            var val = 0.0
            switch currentBinaryOperation {
            case .add, .sub: val = sum + lhsOperand
            case .mul, .div: val = lhsOperand
            case .none: break
            }
            return displayString(of: val)
        }
    }
    
    private func displayString(of val : Double ) -> String {
        if val.isNaN {
            return "error"
        } else {
            let formatter = NumberFormatter()
            if abs(val) > pow(10.0, 12) || abs(val) < pow(10.0, -12) {
                formatter.numberStyle = .scientific
                formatter.maximumSignificantDigits = 12
            } else {
                formatter.maximumSignificantDigits = 15
            }
            return formatter.string(from: NSNumber(value: val)) ?? ""
        }
    }
    
    
    private var sum : Double = 0.0
    private var lhsOperand : Double = 0.0
    private var currentValue : Double? = 0.0
    private var currentBinaryOperation : BinaryOperation?
    private var typingDecimalString = "0" {
        willSet {
            if !newValue.isEmpty {
                currentValue = Double(newValue) ?? 0.0
            }
        }
    }


    func clear() {
        typingDecimalString = "0"
    }

    func clearAll() {
        sum = 0.0
        lhsOperand = 0.0
        currentBinaryOperation = nil
        typingDecimalString = "0"
    }

    func digitPressed(_ c : String) {
        if c == "." {
            if typingDecimalString.isEmpty || currentValue == nil {
                typingDecimalString = "0."
            } else if !typingDecimalString.contains("."){
                typingDecimalString += "."
            }
            return
        }

        guard c.count == 1, ("0"..."9").contains(c) else { return }
        if typingDecimalString == "0" {
            typingDecimalString = c
        } else if typingDecimalString == "-0" {
            typingDecimalString = "-" + c
        } else {
            typingDecimalString += c
        }
    }

    func negatePressed() {
        if currentValue == nil {
            typingDecimalString = "-0"
        } else if typingDecimalString.isEmpty {
            currentValue?.negate()
        } else if typingDecimalString.first == "-" {
            typingDecimalString.removeFirst()
        } else {
            typingDecimalString.insert("-", at: typingDecimalString.startIndex)
        }
    }

    func equalPressed() {
        if let rhs = currentValue {
            if let op = currentBinaryOperation {
                currentValue = sum + binaryOpDict[op]!(lhsOperand, rhs)
            }
        } else {
            currentValue = sum + lhsOperand
        }
        
        sum = 0.0
        lhsOperand = 0.0
        currentBinaryOperation = nil
        typingDecimalString.removeAll()
    }

    func immediateDecimalPressed(val : ImmediateDecimal) {
        typingDecimalString.removeAll()
        switch val {
        case .e: currentValue = exp(1.0)
        case .pi: currentValue = Double.pi
        case .random: currentValue = Double.random(in: 0.0..<1.0)
        }
    }

    func binaryOperationPressed(op : BinaryOperation) {
        if let val = currentValue {
            if let prevOp = currentBinaryOperation {
                switch prevOp {
                case .add:
                    sum += lhsOperand
                    lhsOperand = val
                case .sub:
                    sum += lhsOperand
                    lhsOperand = -val
                case .mul, .div:
                    lhsOperand = binaryOpDict[prevOp]!(lhsOperand, val)
                }
            } else {
                lhsOperand = val
            }
        }
        
        currentBinaryOperation = op
        typingDecimalString.removeAll()
        currentValue = nil
    }

    func unaryOperationPressed(op : UnaryOperation) {
        if let val = currentValue {
            currentValue = unaryOpDict[op]!(val)
            typingDecimalString.removeAll()
        }
    }
    
    
    enum UnaryOperation {
        case percent
        case square, cube, sqrt, cbrt, reciprocal
        case exp, exp10, log, log10
        case sin, cos, tan
        case sinh, cosh, tanh
        case asin, acos, atan
        case asinh, acosh, atanh
    }

    enum BinaryOperation {
        case add, sub, mul, div
    }

    enum ImmediateDecimal {
        case pi, e
        case random
    }

    private let unaryOpDict : [UnaryOperation : (Double)->Double] = [
        .percent : { $0 / 100.0 },
        .square : { $0 * $0 },
        .cube : { pow($0, 3) },
        .sqrt : sqrt,
        .cbrt : cbrt,
        .reciprocal : { 1.0 / $0 },
        .exp : exp,
        .exp10 : { pow(10.0, $0) },
        .log : log,
        .log10 : log10,
        .sin : sin,
        .cos : cos,
        .tan : tan,
        .sinh : sinh,
        .cosh : cosh,
        .tanh : tanh,
        .asin : asin,
        .acos : acos,
        .atan : atan,
        .asinh : asinh,
        .acosh : acosh,
        .atanh : atanh
    ]

    private let binaryOpDict : [BinaryOperation : (Double, Double)->Double] = [
        .add : { $0 + $1 },
        .sub : { $0 - $1 },
        .mul : { $0 * $1 },
        .div : { $0 / $1 }
    ]
}
