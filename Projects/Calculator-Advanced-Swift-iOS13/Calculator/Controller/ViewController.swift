//
//  ViewController.swift
//  Calculator
//
//  Created by Angela Yu on 10/09/2019.
//  Copyright © 2019 London App Brewery. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var displayLabel: UILabel!
    private var isFinishedTypingNumber: Bool = true
    private var calculator = CalculatorLogic()
    private var displayValue: Double {
        get {
            guard let number = Double(displayLabel.text!) else {
                fatalError("can't convert to double")
            }
            return number
        }
        set {
            displayLabel.text = String(newValue)
        }
    }
    
    
    @IBAction func calcButtonPressed(_ sender: UIButton) {
        isFinishedTypingNumber = true
        
        if let calcMethod = sender.currentTitle {
            calculator.setNumber(displayValue)
            if let result = calculator.performCalculation(withMethod: calcMethod) {
                displayValue = result
            }
        }
    }

    
    @IBAction func numButtonPressed(_ sender: UIButton) {
        if let numValue = sender.currentTitle {
            if isFinishedTypingNumber {
                displayLabel.text = numValue
                isFinishedTypingNumber = false
            } else {
                if numValue == "." {
//                    guard let doubleDisplayLabel = Double(displayLabel.text!) else {
//                        fatalError("can't convert to double")
//                    }
//                    let isInt = floor(doubleDisplayLabel) == doubleDisplayLabel
//
//                    if !isInt {
//                        return
//                    }
                    if displayLabel.text!.contains(".") {
                        return
                    }
                }
                displayLabel.text!.append(numValue)
            }
        }
    }

}

