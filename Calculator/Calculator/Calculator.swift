//
//  Calculator.swift
//  Calculator
//
//  Created by ZFirozen on 2021/10/11.
//

import UIKit

class Calculator: NSObject {
    enum Operation {
        case UnaryOp((Decimal)->Decimal)
        case BinaryOp((Decimal,Decimal)->Decimal)
        case StatusOp
        case Constant(Decimal)
    }
    
    var memoryValue: Decimal = 0
    var isUsingRad: Bool = false, lastOpIsMr: Bool = false
    var haveLeftParenthese: Int = 0
    
    lazy var operations = [
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
        "C": Operation.StatusOp,
        "AC": Operation.StatusOp,
        "Rand": Operation.StatusOp,
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
            if self.isUsingRad {
                return Decimal(sin(Double(truncating: NSDecimalNumber(decimal: op))))
            } else {
                return Decimal(sin(Double(truncating: NSDecimalNumber(decimal: op * Decimal.pi)) / 180))
            }
        },
        "cos": Operation.UnaryOp{
            op in
            if self.isUsingRad {
                return Decimal(cos(Double(truncating: NSDecimalNumber(decimal: op))))
            } else {
                return Decimal(cos(Double(truncating: NSDecimalNumber(decimal: op * Decimal.pi)) / 180))
            }
        },
        "tan": Operation.UnaryOp{
            op in
            if self.isUsingRad {
                return Decimal(tan(Double(truncating: NSDecimalNumber(decimal: op))))
            } else {
                return Decimal(tan(Double(truncating: NSDecimalNumber(decimal: op * Decimal.pi)) / 180))
            }
        },
        "sinh": Operation.UnaryOp{
            op in
            if self.isUsingRad {
                return Decimal(sinh(Double(truncating: NSDecimalNumber(decimal: op))))
            } else {
                return Decimal(sinh(Double(truncating: NSDecimalNumber(decimal: op * Decimal.pi)) / 180))
            }
        },
        "cosh": Operation.UnaryOp{
            op in
            if self.isUsingRad {
                return Decimal(cosh(Double(truncating: NSDecimalNumber(decimal: op))))
            } else {
                return Decimal(cosh(Double(truncating: NSDecimalNumber(decimal: op * Decimal.pi)) / 180))
            }
        },
        "tanh": Operation.UnaryOp{
            op in
            if self.isUsingRad {
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
            self.memoryValue += op
            return op
        },
        "m-": Operation.UnaryOp{
            op in
            self.memoryValue -= op
            return op
        },
        "mr": Operation.StatusOp,
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
            if self.isUsingRad {
                return Decimal(asin(Double(truncating: NSDecimalNumber(decimal: op))))
            } else {
                return Decimal(asin(Double(truncating: NSDecimalNumber(decimal: op)))) / Decimal.pi * 180
            }
        },
        "cos⁻¹": Operation.UnaryOp{
            op in
            if self.isUsingRad {
                return Decimal(acos(Double(truncating: NSDecimalNumber(decimal: op))))
            } else {
                return Decimal(acos(Double(truncating: NSDecimalNumber(decimal: op)))) / Decimal.pi * 180
            }
        },
        "tan⁻¹": Operation.UnaryOp{
            op in
            if self.isUsingRad {
                return Decimal(atan(Double(truncating: NSDecimalNumber(decimal: op))))
            } else {
                return Decimal(atan(Double(truncating: NSDecimalNumber(decimal: op)))) / Decimal.pi * 180
            }
        },
        "sinh⁻¹": Operation.UnaryOp{
            op in
            if self.isUsingRad {
                return Decimal(asinh(Double(truncating: NSDecimalNumber(decimal: op))))
            } else {
                return Decimal(asinh(Double(truncating: NSDecimalNumber(decimal: op)))) / Decimal.pi * 180
            }
        },
        "cosh⁻¹": Operation.UnaryOp{
            op in
            if self.isUsingRad {
                return Decimal(acosh(Double(truncating: NSDecimalNumber(decimal: op))))
            } else {
                return Decimal(acosh(Double(truncating: NSDecimalNumber(decimal: op)))) / Decimal.pi * 180
            }
        },
        "tanh⁻¹": Operation.UnaryOp{
            op in
            if self.isUsingRad {
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
    var lastOp: Intermediate? = nil
    
    func isArithmeticSymbol(operation: String)->Bool {
        switch operation {
        case "AC": fallthrough
        case "Rand": fallthrough
        case "π": fallthrough
        case "e": fallthrough
        case "(": return false
        default: return true
        }
    }
    
    func performOperation(operation: String, operand: Decimal, haveTyped: Bool)->Decimal? {
        if let op = operations[operation] {
            switch op {
            case .BinaryOp(let function):
                if pendingOp != nil {
                    let temp = pendingOp!.waitingOperation(pendingOp!.firstOp, operand)
                    pendingOp = Intermediate(firstOp: temp, waitingOperation: function)
                } else {
                    pendingOp = Intermediate(firstOp: operand, waitingOperation: function)
                }
                lastOpIsMr = false
                return nil
            case .Constant(let value):
                lastOpIsMr = false
                return value
            case .StatusOp:
                switch operation {
                case "Rand": lastOpIsMr = false
                    return Decimal(Double.random(in: 0...1))
                case "Rad": fallthrough
                case "Deg": lastOpIsMr = false
                    isUsingRad = !isUsingRad
                    return nil
                case "(": lastOpIsMr = false
                    haveLeftParenthese = haveLeftParenthese + 1
                    return nil
                case ")": lastOpIsMr = false
                    if haveLeftParenthese > 0 {
                        haveLeftParenthese = haveLeftParenthese - 1
                        if pendingOp != nil {
                            return pendingOp!.waitingOperation(pendingOp!.firstOp, operand)
                        } else {
                            return operand
                        }
                    } else {
                        return nil
                    }
                case "mc": lastOpIsMr = false
                    memoryValue = 0
                    return nil
                case "mr": lastOpIsMr = true
                    return memoryValue
                case "=": haveLeftParenthese = 0
                    if pendingOp != nil {
                        if haveTyped || lastOpIsMr {
                            lastOpIsMr = false
                            lastOp = Intermediate(firstOp: operand, waitingOperation: pendingOp!.waitingOperation)
                            let returnValue = pendingOp!.waitingOperation(pendingOp!.firstOp, operand)
                            pendingOp = nil
                            return returnValue
                        } else {
                            lastOpIsMr = false
                            lastOp = pendingOp
                            pendingOp = nil
                            return lastOp!.waitingOperation(lastOp!.firstOp, lastOp!.firstOp)
                        }
                    } else if lastOp != nil {
                        lastOpIsMr = false
                        if lastOp!.firstOp == Decimal.nan {
                            lastOp!.firstOp = operand
                            return operand
                        } else {
                            return lastOp!.waitingOperation(operand, lastOp!.firstOp)
                        }
                    } else {
                        lastOpIsMr = false
                        return operand
                    }
                case "AC": lastOpIsMr = false
                    pendingOp = nil
                    lastOp = nil
                    haveLeftParenthese = 0
                    return 0
                case "C": lastOpIsMr = false
                    haveLeftParenthese = 0
                    if lastOp != nil {
                        lastOp!.firstOp = Decimal.nan
                    }
                    if haveTyped && pendingOp != nil {
                        return 0
                    } else if pendingOp != nil {
                        pendingOp = nil
                        return nil
                    } else {
                        return 0
                    }
                default: lastOpIsMr = false
                    return nil
                }
            case .UnaryOp(let function):
                lastOpIsMr = false
                return function(operand)
            }
        }
        lastOpIsMr = false
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
