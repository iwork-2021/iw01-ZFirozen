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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.displayLabel.text! = "0"
        UIDevice.current.beginGeneratingDeviceOrientationNotifications()
        NotificationCenter.default.addObserver(self, selector: #selector(self.receivedRotation), name: UIDevice.orientationDidChangeNotification, object: nil)
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
        for i in 1...49 {
            if let buttonFound = view.viewWithTag(i) as? UIButton {
                changeRoundedCorner(buttonToChange: (buttonFound))
            }
        }
    }
    
    func changeRoundedCorner(buttonToChange: UIButton) {
        buttonToChange.layer.cornerRadius = min(buttonToChange.frame.height, (buttonToChange.frame.width)) / 2
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
                    if abs(Double(truncating: NSDecimalNumber(decimal: result))) < 10e-15 {
                        digitOnDisplay = "0"
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

