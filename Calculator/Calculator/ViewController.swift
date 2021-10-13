//
//  ViewController.swift
//  Calculator
//
//  Created by ZFirozen on 2021/10/11.
//

import UIKit

extension ViewController {
    override open var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return .all
    }
}

class ViewController: UIViewController {

    @IBOutlet weak var displayLabel: UILabel!
    @IBOutlet weak var buttonSets: UIButton!
    @IBOutlet weak var rootStackView: UIStackView!
    @IBOutlet weak var resultLabel: UIView!
    @IBOutlet weak var buttonsSetsView: UIView!
    @IBOutlet weak var buttonSetsSubview: UIStackView!
    @IBOutlet weak var buttonSets1: UIStackView!
    @IBOutlet weak var buttonSets2: UIStackView!
    @IBOutlet weak var buttonSets3: UIStackView!
    @IBOutlet weak var buttonSets4: UIStackView!
    @IBOutlet weak var buttonSets5: UIStackView!
    @IBOutlet weak var buttonBar1: UIStackView!
    @IBOutlet weak var buttonBar2: UIStackView!
    @IBOutlet weak var buttonBar3: UIStackView!
    @IBOutlet weak var buttonBar4: UIStackView!
    
    var buttonWidth: CGFloat = 0, buttonHeight: CGFloat = 0
    var resultLabelHeight: CGFloat = 0
    var rootStackWidth: CGFloat = 0, rootStackHeight: CGFloat = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.displayLabel.text! = "0"
        UIDevice.current.beginGeneratingDeviceOrientationNotifications()
        NotificationCenter.default.addObserver(self, selector: #selector(self.receivedRotation), name: UIDevice.orientationDidChangeNotification, object: nil)
        resultLabel.autoresizesSubviews = true
        buttonsSetsView.autoresizesSubviews = true
        receivedRotation()
    }
    
    @objc func receivedRotation(){
        
        rootStackWidth = rootStackView.frame.width
        rootStackHeight = rootStackView.frame.height
        
        switch UIDevice.current.orientation{
        case .portrait: if rootStackWidth > rootStackHeight {
            rootStackWidth = rootStackView.frame.height
            rootStackHeight = rootStackView.frame.width
        }
        case .portraitUpsideDown: if UIDevice.current.userInterfaceIdiom == UIUserInterfaceIdiom.phone {
            return
        } else {
            if rootStackWidth > rootStackHeight {
                rootStackWidth = rootStackView.frame.height
                rootStackHeight = rootStackView.frame.width
            }
        }
        case .landscapeLeft: if rootStackWidth < rootStackHeight {
            rootStackWidth = rootStackView.frame.height
            rootStackHeight = rootStackView.frame.width
        }
        case .landscapeRight: if rootStackWidth < rootStackHeight {
            rootStackWidth = rootStackView.frame.height
            rootStackHeight = rootStackView.frame.width
        }
        case .faceUp: if rootStackWidth > rootStackHeight {
            rootStackWidth = rootStackView.frame.height
            rootStackHeight = rootStackView.frame.width
        }
        case .faceDown: if rootStackWidth > rootStackHeight {
            rootStackWidth = rootStackView.frame.height
            rootStackHeight = rootStackView.frame.width
        }
        case .unknown: return
        default: return
        }
        
        //changeRoundedCorner(buttonToChange: buttonSets)
        
        if (view.viewWithTag(49) as? UIButton)!.isHidden {
            buttonWidth = floor((rootStackWidth - 30) / 2) / 2
            rootStackWidth = buttonWidth * 4 + 30
            buttonHeight = buttonWidth
            resultLabelHeight = (rootStackHeight - 40 - buttonHeight * 5)
            if resultLabelHeight * 3 < rootStackHeight {
                resultLabelHeight = rootStackHeight / 3
                buttonHeight = floor((rootStackHeight - resultLabelHeight - 40) / 5 * 2) / 2
                resultLabelHeight = rootStackHeight - buttonHeight * 5 - 40
            }
        } else {
            buttonWidth = floor((rootStackWidth - 90) / 5) / 2
            rootStackWidth = buttonWidth * 10 + 90
            buttonHeight = buttonWidth
            resultLabelHeight = (rootStackHeight - 40 - buttonHeight * 5)
            if resultLabelHeight * 4 < rootStackHeight {
                resultLabelHeight = rootStackHeight / 4
                buttonHeight = floor((rootStackHeight - resultLabelHeight - 40) / 5 * 2) / 2
                resultLabelHeight = rootStackHeight - buttonHeight * 5 - 40
            }
        }
        
        resultLabel.frame.size = CGSize(width: rootStackWidth, height: resultLabelHeight)
        displayLabel.frame.size = CGSize(width: rootStackWidth, height: resultLabelHeight)
        buttonsSetsView.frame.size = CGSize(width: rootStackWidth, height: rootStackHeight - resultLabelHeight)
        buttonSetsSubview.frame.size = CGSize(width: rootStackWidth, height: rootStackHeight - resultLabelHeight)
        buttonSets1.frame.size = CGSize(width: rootStackWidth, height: buttonHeight)
        buttonSets2.frame.size = CGSize(width: rootStackWidth, height: buttonHeight)
        buttonSets3.frame.size = CGSize(width: rootStackWidth, height: buttonHeight)
        buttonSets4.frame.size = CGSize(width: rootStackWidth, height: buttonHeight)
        buttonSets5.frame.size = CGSize(width: rootStackWidth, height: buttonHeight)
        buttonBar1.frame.size = CGSize(width: buttonWidth * 2 + 10, height: buttonHeight)
        buttonBar2.frame.size = CGSize(width: buttonWidth * 2 + 10, height: buttonHeight)
        buttonBar3.frame.size = CGSize(width: buttonWidth * 2 + 10, height: buttonHeight)
        buttonBar4.frame.size = CGSize(width: buttonWidth * 2 + 10, height: buttonHeight)
        changeRoundedCorner(buttonToChange: (view.viewWithTag(1) as? UIButton)!, buttonSize: CGSize(width: buttonWidth * 2 + 10, height: buttonHeight))
        for i in 2...49 {
            if let buttonFound = view.viewWithTag(i) as? UIButton {
                changeRoundedCorner(buttonToChange: (buttonFound), buttonSize: CGSize(width: buttonWidth, height: buttonHeight))
            }
        }
    }
    
    func changeRoundedCorner(buttonToChange: UIButton, buttonSize: CGSize) {
        buttonToChange.frame.size = buttonSize
        buttonToChange.layer.cornerRadius = min(buttonSize.height, buttonSize.width) / 2
    }
    
    var lastResult: Decimal = 0
    var isLastResultValid: Bool = false
    
    var digitOnDisplay: String {
        get {
            return self.displayLabel.text!
        }
        set {
            self.displayLabel.text! = newValue
        }
    }
    
    var inTypingMode = false

    @IBAction func numberTouched(_ sender: UIButton) {
        if inTypingMode {
            digitOnDisplay = digitOnDisplay + sender.currentTitle!
        } else {
            digitOnDisplay = sender.currentTitle!
            inTypingMode = true
        }
        if (view.viewWithTag(16) as? UIButton)!.titleLabel!.text == "AC" {
            (view.viewWithTag(16) as? UIButton)!.setTitle("C", for: .normal)
        }
    }
    
    @IBAction func titleSwitchACAndC(_ sender: UIButton) {
        if sender.titleLabel!.text == "C" {
            sender.setTitle("AC", for: .normal)
        }
    }
    
    @IBAction func titleSwitchRadAndDeg(_ sender: UIButton) {
        if sender.titleLabel!.text == "Rad" {
            sender.setTitle("Deg", for: .normal)
        } else {
            sender.setTitle("Rad", for: .normal)
        }
    }
    
    @IBAction func titleSwitch1stAnd2nd(_ sender: UIButton) {
        if sender.titleLabel!.text == "2ⁿᵈ" {
            sender.setTitle("1ˢᵗ", for: .normal)
            (view.viewWithTag(30) as? UIButton)!.setTitle("yˣ", for: .normal)
            (view.viewWithTag(31) as? UIButton)!.setTitle("2ˣ", for: .normal)
            (view.viewWithTag(36) as? UIButton)!.setTitle("logｙ", for: .normal)
            (view.viewWithTag(37) as? UIButton)!.setTitle("log₂", for: .normal)
            (view.viewWithTag(39) as? UIButton)!.setTitle("sin⁻¹", for: .normal)
            (view.viewWithTag(40) as? UIButton)!.setTitle("cos⁻¹", for: .normal)
            (view.viewWithTag(41) as? UIButton)!.setTitle("tan⁻¹", for: .normal)
            (view.viewWithTag(45) as? UIButton)!.setTitle("sinh⁻¹", for: .normal)
            (view.viewWithTag(46) as? UIButton)!.setTitle("cosh⁻¹", for: .normal)
            (view.viewWithTag(47) as? UIButton)!.setTitle("tanh⁻¹", for: .normal)
        } else {
            sender.setTitle("2ⁿᵈ", for: .normal)
            (view.viewWithTag(30) as? UIButton)!.setTitle("eˣ", for: .normal)
            (view.viewWithTag(31) as? UIButton)!.setTitle("10ˣ", for: .normal)
            (view.viewWithTag(36) as? UIButton)!.setTitle("ln", for: .normal)
            (view.viewWithTag(37) as? UIButton)!.setTitle("log₁₀", for: .normal)
            (view.viewWithTag(39) as? UIButton)!.setTitle("sin", for: .normal)
            (view.viewWithTag(40) as? UIButton)!.setTitle("cos", for: .normal)
            (view.viewWithTag(41) as? UIButton)!.setTitle("tan", for: .normal)
            (view.viewWithTag(45) as? UIButton)!.setTitle("sinh", for: .normal)
            (view.viewWithTag(46) as? UIButton)!.setTitle("cosh", for: .normal)
            (view.viewWithTag(47) as? UIButton)!.setTitle("tanh", for: .normal)
        }
    }
    
    
    let calculator = Calculator()
    @IBAction func operatorTouched(_ sender: UIButton) {
        if let op = sender.currentTitle {
            var operand: Decimal
            if isLastResultValid && calculator.isArithmeticSymbol(operation: op) {
                operand = lastResult
            } else {
                operand = Decimal.init(string: digitOnDisplay) ?? 0
            }
            isLastResultValid = false
            if let result = calculator.performOperation(operation: op, operand: operand, haveTyped: inTypingMode) {
                lastResult = result
                digitOnDisplay = String(NSDecimalNumber(decimal: lastResult).stringValue)
                let dotIndex = digitOnDisplay.findFirst(".")
                if digitOnDisplay.findFirst(".") != -1 && digitOnDisplay.count - dotIndex > 15 {
                    var tempZeroString = ""
                    for _ in 1...dotIndex {
                        tempZeroString.append("0")
                    }
                    if String(digitOnDisplay.prefix(dotIndex)) == tempZeroString {
                        tempZeroString = ""
                        for _ in dotIndex...digitOnDisplay.count - 3 {
                            tempZeroString.append("0")
                        }
                        if String(String(digitOnDisplay.suffix(digitOnDisplay.count - dotIndex - 1)).prefix(digitOnDisplay.count - dotIndex - 2)) == tempZeroString {
                            digitOnDisplay = "1e-" + String(digitOnDisplay.count - dotIndex - 1)
                            inTypingMode = false
                            isLastResultValid = true
                            return
                        }
                    }
                    if abs(Double(truncating: NSDecimalNumber(decimal: lastResult))) < 10e-14 {
                        digitOnDisplay = "0"
                        isLastResultValid = false
                    } else if Double(truncating: NSDecimalNumber(decimal: lastResult)) - floor(Double(truncating: NSDecimalNumber(decimal: lastResult))) < 10e-14 {
                        digitOnDisplay = String(Int(floor(Double(truncating: NSDecimalNumber(decimal: lastResult)))))
                        isLastResultValid = false
                    } else if (String(digitOnDisplay.prefix(dotIndex + 17)).suffix(1) <= "4") {
                        digitOnDisplay = String(digitOnDisplay.prefix(dotIndex + 16))
                        isLastResultValid = true
                    } else {
                        let lastChar = String(String(digitOnDisplay.prefix(dotIndex + 16)).suffix(1))
                        digitOnDisplay = String(digitOnDisplay.prefix(dotIndex + 15))
                        digitOnDisplay.append(String(Int(lastChar)! + 1))
                        isLastResultValid = true
                    }
                } else {
                    isLastResultValid = false
                }
            } else {
                
            }
            inTypingMode = false
        }
    }
    
}
