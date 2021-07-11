//
//  ViewController.swift
//  Tipsy
//
//  Created by Angela Yu on 09/09/2019.
//  Copyright © 2019 The App Brewery. All rights reserved.
//

import UIKit

class CalculatorViewController: UIViewController {
    @IBOutlet weak var billTextField: UITextField!
    @IBOutlet weak var zeroPercentButton: UIButton!
    @IBOutlet weak var tenPercentButton: UIButton!
    @IBOutlet weak var twentyPercentButton: UIButton!
    @IBOutlet weak var splitNumberLabel: UILabel!
    
    var calculator = Calculator()

    @IBAction func tipChanged(_ sender: UIButton) {
        billTextField.endEditing(true)
        
        zeroPercentButton.isSelected = false
        tenPercentButton.isSelected = false
        twentyPercentButton.isSelected = false
        
        sender.isSelected = true
        
        let buttonLabel = sender.currentTitle!
        
        calculator.calculateTipAmout(tipString: buttonLabel)
    }
    
    @IBAction func stepperValueChanged(_ sender: UIStepper) {
        billTextField.endEditing(true)
        
        let changedValue = Int(sender.value)
        
        calculator.amountOfPeople = changedValue
        splitNumberLabel.text = String(changedValue)
    }
    
    @IBAction func calculateButtonPressed(_ sender: UIButton) {        
        calculator.userInputValue = Double(billTextField.text ?? "0.0") ?? 0.0
        
        calculator.calculateTotalValue()
                
        performSegue(withIdentifier: "Calculate", sender: nil)
    }
    
    // MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "Calculate" {
            let destinationVC = segue.destination as! ResultsViewController
            destinationVC.numberOfPeople = calculator.amountOfPeople
            destinationVC.result = calculator.totalValue
            destinationVC.tipPercentage = "\(calculator.tipAmount * 100)%"
        }
    }
}

