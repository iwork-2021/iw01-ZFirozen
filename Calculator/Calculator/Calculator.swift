//
//  Calculator.swift
//  Calculator
//
//  Created by ZFirozen on 2021/10/11.
//

import UIKit

var memoryValue: Decimal = 0
var isUsingRad = false
var haveLeftParenthese: Int = 0

class Calculator: NSObject {
    enum Operation {
        case UnaryOp((Decimal)->Decimal)
        case BinaryOp((Decimal,Decimal)->Decimal)
        case StatusOp
        case Constant(Decimal)
    }
    
    var operations = [
        "+": Operation.BinaryOp{
            (op1, op2) in
            return op1 + op2
        },
        "−": Operation.BinaryOp{
            (op1, op2) in
            return op1 - op2
        },
        "×": Operation.BinaryOp{
            (op1, op2) in
            return op1 * op2
        },
        "÷": Operation.BinaryOp{
            (op1, op2) in
            return op1 / op2
        },
        "=": Operation.StatusOp,
        "%": Operation.UnaryOp{
            op in
            return op / 100.0
        },
        "⁺⁄₋": Operation.UnaryOp{
            op in
            return -op
        },
        "AC": Operation.UnaryOp{
            _ in
            return 0
        },
        "Rand": Operation.Constant(Decimal(Double.random(in: 0...1))),
        "π": Operation.Constant(Decimal.pi),
        "e": Operation.Constant(Decimal(M_E)),
        "EE": Operation.BinaryOp{
            (op1, op2) in
            return op1 * (Decimal(string: "10e" + String(NSDecimalNumber(decimal: op2).stringValue))! - 1)
        },
        "x!": Operation.UnaryOp{
            op in
            if op == 0 {
                return 1
            }
            if String(NSDecimalNumber(decimal: op).stringValue).findFirst(".") == -1 {
                let loopTimes: Int = Int(truncating: NSDecimalNumber(decimal: op))
                var res: Decimal = 1
                for i in 1...loopTimes {
                    res = res * Decimal(i)
                }
                return res
            }
            else {
                return Decimal.nan
            }
        },
        "sin": Operation.UnaryOp{
            op in
            if isUsingRad {
                return Decimal(sin(Double(truncating: NSDecimalNumber(decimal: op))))
            } else {
                return Decimal(sin(Double(truncating: NSDecimalNumber(decimal: op * Decimal.pi)) / 180))
            }
        },
        "cos": Operation.UnaryOp{
            op in
            if isUsingRad {
                return Decimal(cos(Double(truncating: NSDecimalNumber(decimal: op))))
            } else {
                return Decimal(cos(Double(truncating: NSDecimalNumber(decimal: op * Decimal.pi)) / 180))
            }
        },
        "tan": Operation.UnaryOp{
            op in
            if isUsingRad {
                return Decimal(tan(Double(truncating: NSDecimalNumber(decimal: op))))
            } else {
                return Decimal(tan(Double(truncating: NSDecimalNumber(decimal: op * Decimal.pi)) / 180))
            }
        },
        "sinh": Operation.UnaryOp{
            op in
            if isUsingRad {
                return Decimal(sinh(Double(truncating: NSDecimalNumber(decimal: op))))
            } else {
                return Decimal(sinh(Double(truncating: NSDecimalNumber(decimal: op * Decimal.pi)) / 180))
            }
        },
        "cosh": Operation.UnaryOp{
            op in
            if isUsingRad {
                return Decimal(cosh(Double(truncating: NSDecimalNumber(decimal: op))))
            } else {
                return Decimal(cosh(Double(truncating: NSDecimalNumber(decimal: op * Decimal.pi)) / 180))
            }
        },
        "tanh": Operation.UnaryOp{
            op in
            if isUsingRad {
                return Decimal(tanh(Double(truncating: NSDecimalNumber(decimal: op))))
            } else {
                return Decimal(tanh(Double(truncating: NSDecimalNumber(decimal: op * Decimal.pi)) / 180))
            }
        },
        "Rad": Operation.StatusOp,
        "(": Operation.StatusOp,
        ")": Operation.StatusOp,
        "mc": Operation.StatusOp,
        "m+": Operation.UnaryOp{
            op in
            memoryValue += op
            return op
        },
        "m-": Operation.UnaryOp{
            op in
            memoryValue -= op
            return op
        },
        "mr": Operation.UnaryOp{
            _ in
            return memoryValue
        },
        "x²": Operation.UnaryOp{
            op in
            return op * op
        },
        "x³": Operation.UnaryOp{
            op in
            return op * op * op
        },
        "xʸ": Operation.BinaryOp{
            (op1, op2) in
            return Decimal(pow(Double(truncating: NSDecimalNumber(decimal: op1)), Double(truncating: NSDecimalNumber(decimal: op2))))
        },
        "eˣ": Operation.UnaryOp{
            op in
            return Decimal(pow(M_E, Double(truncating: NSDecimalNumber(decimal: op))))
        },
        "10ˣ": Operation.UnaryOp{
            op in
            return Decimal(pow(10, Double(truncating: NSDecimalNumber(decimal: op))))
        },
        "¹⁄ₓ": Operation.UnaryOp{
            op in
            return 1 / op
        },
        "²√x": Operation.UnaryOp{
            op in
            return Decimal(sqrt(Double(truncating: NSDecimalNumber(decimal: op))))
        },
        "³√x": Operation.UnaryOp{
            op in
            return Decimal(cbrt(Double(truncating: NSDecimalNumber(decimal: op))))
        },
        "ʸ√x": Operation.BinaryOp{
            (op1, op2) in
            return Decimal(pow(Double(truncating: NSDecimalNumber(decimal: op1)), Double(truncating: NSDecimalNumber(decimal: 1 / op2))))
        },
        "ln": Operation.UnaryOp{
            op in
            return Decimal(log(Double(truncating: NSDecimalNumber(decimal: op))))
        },
        "log₁₀": Operation.UnaryOp{
            op in
            return Decimal(log10(Double(truncating: NSDecimalNumber(decimal: op))))
        },
        "yˣ": Operation.BinaryOp{
            (op1, op2) in
            return Decimal(pow(Double(truncating: NSDecimalNumber(decimal: op2)), Double(truncating: NSDecimalNumber(decimal: op1))))
        },
        "2ˣ": Operation.UnaryOp{
            op in
            return Decimal(pow(2, Double(truncating: NSDecimalNumber(decimal: op))))
        },
        "logｙ": Operation.BinaryOp{
            (op1, op2) in
            return Decimal(log(Double(truncating: NSDecimalNumber(decimal: op1))) / log(Double(truncating: NSDecimalNumber(decimal: op2))))
        },
        "log₂": Operation.UnaryOp{
            op in
            return Decimal(log2(Double(truncating: NSDecimalNumber(decimal: op))))
        },
        "sin⁻¹": Operation.UnaryOp{
            op in
            if isUsingRad {
                return Decimal(asin(Double(truncating: NSDecimalNumber(decimal: op))))
            } else {
                return Decimal(asin(Double(truncating: NSDecimalNumber(decimal: op)))) / Decimal.pi * 180
            }
        },
        "cos⁻¹": Operation.UnaryOp{
            op in
            if isUsingRad {
                return Decimal(acos(Double(truncating: NSDecimalNumber(decimal: op))))
            } else {
                return Decimal(acos(Double(truncating: NSDecimalNumber(decimal: op)))) / Decimal.pi * 180
            }
        },
        "tan⁻¹": Operation.UnaryOp{
            op in
            if isUsingRad {
                return Decimal(atan(Double(truncating: NSDecimalNumber(decimal: op))))
            } else {
                return Decimal(atan(Double(truncating: NSDecimalNumber(decimal: op)))) / Decimal.pi * 180
            }
        },
        "sinh⁻¹": Operation.UnaryOp{
            op in
            if isUsingRad {
                return Decimal(asinh(Double(truncating: NSDecimalNumber(decimal: op))))
            } else {
                return Decimal(asinh(Double(truncating: NSDecimalNumber(decimal: op)))) / Decimal.pi * 180
            }
        },
        "cosh⁻¹": Operation.UnaryOp{
            op in
            if isUsingRad {
                return Decimal(acosh(Double(truncating: NSDecimalNumber(decimal: op))))
            } else {
                return Decimal(acosh(Double(truncating: NSDecimalNumber(decimal: op)))) / Decimal.pi * 180
            }
        },
        "tanh⁻¹": Operation.UnaryOp{
            op in
            if isUsingRad {
                return Decimal(atanh(Double(truncating: NSDecimalNumber(decimal: op))))
            } else {
                return Decimal(atanh(Double(truncating: NSDecimalNumber(decimal: op)))) / Decimal.pi * 180
            }
        }
    ]
    
    struct Intermediate {
        var firstOp: Decimal
        var waitingOperation: (Decimal, Decimal) -> Decimal
    }
    var pendingOp: Intermediate? = nil
    
    func performOperation(operation: String, operand: Decimal)->Decimal? {
        if let op = operations[operation] {
            switch op {
            case .BinaryOp(let function):
                pendingOp = Intermediate(firstOp: operand, waitingOperation: function)
                return nil
            case .Constant(let value):
                return value
            case .StatusOp:
                switch operation {
                case "Rad": fallthrough
                case "Deg": isUsingRad = !isUsingRad
                    return nil
                case "(": haveLeftParenthese = haveLeftParenthese + 1
                    return nil
                case ")": if haveLeftParenthese > 0 {
                    haveLeftParenthese = haveLeftParenthese - 1
                    if (pendingOp != nil) {
                            return pendingOp!.waitingOperation(pendingOp!.firstOp, operand)
                        } else {
                            return operand
                        }
                } else {
                    return nil
                }
                case "mc": memoryValue = 0
                    return nil
                case "=": if (pendingOp != nil) {
                    return pendingOp!.waitingOperation(pendingOp!.firstOp, operand)
                } else {
                    return operand
                }
                default: return nil
                }
            case .UnaryOp(let function):
                return function(operand)
            }
        }
        return nil
    }
}

extension String {
    func subStringInRange(_ r: Range<Int>) -> String? {
        if r.lowerBound < 0 || r.upperBound > self.count {
            return nil
        }
        let startIndex = self.index(self.startIndex, offsetBy: r.lowerBound)
        let endIndex = self.index(self.startIndex, offsetBy: r.upperBound)
        return String(self[startIndex..<endIndex])
    }
    
    func findFirst(_ sub: String)->Int {
        var pos = -1
        if let range = range(of:sub, options: .literal) {
            if !range.isEmpty {
                pos = self.distance(from:startIndex, to:range.lowerBound)
            }
        }
        return pos
    }
}
