//
//  Calculator.swift
//  Tipsy
//
//  Created by Pavel Romanishkin on 13.03.21.
//  Copyright © 2021 The App Brewery. All rights reserved.
//

import Foundation

struct Calculator {
    
    var tipAmount = 0.0
    
    var amountOfPeople = 2
    
    var totalValue = ""
    
    var userInputValue = 0.0
    
    mutating func calculateTipAmout(tipString: String) {
        tipAmount = Double(String(tipString.dropLast()))! / 100
    }
 
    mutating func calculateTotalValue() {
        totalValue = String(format: "%.2f", ((userInputValue + userInputValue * tipAmount) / Double(amountOfPeople)))
    }
}
