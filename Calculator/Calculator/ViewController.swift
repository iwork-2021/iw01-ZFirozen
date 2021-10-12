//
//  ViewController.swift
//  Calculator
//
//  Created by ZFirozen on 2021/10/11.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var displayLabel: UILabel!
    @IBOutlet weak var buttonSets: UIButton!
    @IBOutlet weak var rootStackView: UIStackView!
    @IBOutlet weak var resultLabel: UIView!
    @IBOutlet weak var buttonsSetsView: UIView!
    
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
        /*
        var device = UIDevice.current
        switch device.orientation{
        case .Portrait:
        case .PortraitUpsideDown:
        case .LandscapeLeft:
        case .LnadscapeRight:
        case .FaceUp:
        case .FaceDown:
        case .Unknown:
        default:
        }
        */
        //changeRoundedCorner(buttonToChange: buttonSets)
        rootStackWidth = rootStackView.frame.width
        rootStackHeight = rootStackView.frame.height
        buttonWidth = floor((rootStackWidth - 90) / 5) / 2
        print("rootStackWidth", rootStackWidth, "rootStackHeight", rootStackHeight, "buttonWidth", buttonWidth, "buttonHeight", buttonHeight, "resultLabelHeight", resultLabelHeight)
        rootStackWidth = buttonWidth * 10 + 90
        buttonHeight = buttonWidth
        resultLabelHeight = (rootStackHeight - 40 - buttonWidth * 5)
        print("rootStackWidth", rootStackWidth, "rootStackHeight", rootStackHeight, "buttonWidth", buttonWidth, "buttonHeight", buttonHeight, "resultLabelHeight", resultLabelHeight)
        if resultLabelHeight * 4 < rootStackHeight {
            resultLabelHeight = rootStackHeight / 4
            buttonHeight = floor((rootStackHeight - resultLabelHeight - 40) / 5 * 2) / 2
            resultLabelHeight = rootStackHeight - buttonHeight * 5 - 40
        }
        print("rootStackWidth", rootStackWidth, "rootStackHeight", rootStackHeight, "buttonWidth", buttonWidth, "buttonHeight", buttonHeight, "resultLabelHeight", resultLabelHeight)
        
        resultLabel.
        resultLabel.sizeThatFits(CGSize(width: rootStackWidth, height: resultLabelHeight))
        buttonsSetsView.sizeThatFits(CGSize(width: rootStackWidth, height: rootStackHeight - resultLabelHeight))
        changeRoundedCorner(buttonToChange: (view.viewWithTag(1) as? UIButton)!, buttonSize: CGSize(width: buttonWidth * 2 + 10, height: buttonHeight))
        for i in 2...49 {
            if let buttonFound = view.viewWithTag(i) as? UIButton {
                changeRoundedCorner(buttonToChange: (buttonFound), buttonSize: CGSize(width: buttonWidth, height: buttonHeight))
            }
        }
        print(resultLabel.frame.height, buttonsSetsView.frame.height)
    }
    
    func changeRoundedCorner(buttonToChange: UIButton, buttonSize: CGSize) {
        buttonToChange.layer.cornerRadius = min(buttonSize.height, buttonSize.width) / 2
        print("button", buttonToChange.titleLabel!.text, "height", buttonToChange.frame.height, "width", buttonToChange.frame.width, "cornerR", buttonToChange.layer.cornerRadius)
    }
    
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
    }
    
    @IBAction func titleSwitchRadAndDeg(_ sender: UIButton) {
        if sender.titleLabel!.text == "Rad" {
            sender.setTitle("Deg", for: .normal)
        } else {
            sender.setTitle("Rad", for: .normal)
        }
    }
    
    let calculator = Calculator()
    @IBAction func operatorTouched(_ sender: UIButton) {
        if let op = sender.currentTitle {
            if let result = calculator.performOperation(operation: op, operand: Decimal.init(string: digitOnDisplay)!) {
                digitOnDisplay = String(NSDecimalNumber(decimal: result).stringValue)
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
                            return
                        }
                    }
                    if abs(Double(truncating: NSDecimalNumber(decimal: result))) < 10e-14 {
                        digitOnDisplay = "0"
                    } else if Double(truncating: NSDecimalNumber(decimal: result)) - floor(Double(truncating: NSDecimalNumber(decimal: result))) < 10e-14 {
                        digitOnDisplay = String(Int(floor(Double(truncating: NSDecimalNumber(decimal: result)))))
                    } else if (String(digitOnDisplay.prefix(dotIndex + 17)).suffix(1) <= "4") {
                        digitOnDisplay = String(digitOnDisplay.prefix(dotIndex + 16))
                    } else {
                        let lastChar = String(String(digitOnDisplay.prefix(dotIndex + 16)).suffix(1))
                        digitOnDisplay = String(digitOnDisplay.prefix(dotIndex + 15))
                        digitOnDisplay.append(String(Int(lastChar)! + 1))
                    }
                }
            }
            inTypingMode = false
        }
    }
    
}

