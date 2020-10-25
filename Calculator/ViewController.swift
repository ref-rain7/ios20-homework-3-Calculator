//
//  ViewController.swift
//  Calculator
//
//  Created by zero on 2020/10/19.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    var model = Calculator()
    var arcEnabled : Bool = false
    
    @IBOutlet weak var displayLabel: UILabel!
    @IBOutlet weak var clearBtn: UIButton!
    @IBOutlet var triFuncBtns: [UIButton]!
    
    @IBAction func buttonTouched(_ sender: UIButton) {
        switch sender.currentTitle {
        case .none: break
        case "=" : model.equalPressed()
        case "AC" : model.clearAll()
        case "C" : model.clear()
        case "+/-" : model.negatePressed()
        case "2nd" :
            arcEnabled.toggle()
            for btn in triFuncBtns {
                if var label = btn.currentTitle {
                    if arcEnabled { label += "⁻¹" }
                    else { label.removeLast(2) }
                    btn.setTitle(label, for: .normal)
                }
            }
        case .some(let t):
            let c = caseDict[t]
            switch c {
            case .digit : model.digitPressed(t)
            case .unaryOp(let op) : model.unaryOperationPressed(op: op)
            case .binaryOp(let op) : model.binaryOperationPressed(op: op)
            case .immDecimal(let imm) : model.immediateDecimalPressed(val: imm)
            case .none: break
            }
        }
        
        upadteLabel()
    }

    
    func upadteLabel() {
        let text = model.displayString
        clearBtn.setTitle(text == "0" ? "AC" : "C", for: .normal)
        displayLabel.text = text
    }
    
    
    
    enum ButtonCase {
        case digit
        case unaryOp(Calculator.UnaryOperation)
        case binaryOp(Calculator.BinaryOperation)
        case immDecimal(Calculator.ImmediateDecimal)
    }
    
    let caseDict : [String : ButtonCase] = [
        "0" : .digit,
        "1" : .digit,
        "2" : .digit,
        "3" : .digit,
        "4" : .digit,
        "5" : .digit,
        "6" : .digit,
        "7" : .digit,
        "8" : .digit,
        "9" : .digit,
        "." : .digit,
        
        "+" : .binaryOp(.add),
        "−" : .binaryOp(.sub),
        "×" : .binaryOp(.mul),
        "÷" : .binaryOp(.div),
        
        "e" : .immDecimal(.e),
        "π" : .immDecimal(.pi),
        "Rand" : .immDecimal(.random),
        
        "%" : .unaryOp(.percent),
        "x²" : .unaryOp(.square),
        "x³" : .unaryOp(.cube),
        "e^x" : .unaryOp(.exp),
        "10^x" : .unaryOp(.exp10),
        "√x": .unaryOp(.sqrt),
        "∛x" : .unaryOp(.cbrt),
        "ln" : .unaryOp(.log),
        "lg" : .unaryOp(.log10),
        "x⁻¹" : .unaryOp(.reciprocal),
        
        "sin" : .unaryOp(.sin),
        "cos" : .unaryOp(.cos),
        "tan" : .unaryOp(.tan),
        "sinh" : .unaryOp(.sinh),
        "cosh" : .unaryOp(.cosh),
        "tanh" : .unaryOp(.tanh),
        "sin⁻¹" : .unaryOp(.asin),
        "cos⁻¹" : .unaryOp(.acos),
        "tan⁻¹" : .unaryOp(.atan),
        "sinh⁻¹" : .unaryOp(.asinh),
        "cosh⁻¹" : .unaryOp(.acosh),
        "tanh⁻¹" : .unaryOp(.atanh)
    ]
}
