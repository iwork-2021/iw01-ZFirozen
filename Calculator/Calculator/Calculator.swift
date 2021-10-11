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
        case EqualOp
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
        "=": Operation.EqualOp,
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
            case .EqualOp:
                return pendingOp!.waitingOperation(pendingOp!.firstOp, operand)
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
