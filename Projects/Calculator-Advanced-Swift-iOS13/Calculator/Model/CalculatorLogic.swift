//
//  CalculatorLogic.swift
//  Calculator
//
//  Created by Pavel Romanishkin on 03.04.21.
//  Copyright © 2021 London App Brewery. All rights reserved.
//

import Foundation

struct CalculatorLogic {
    private var number: Double?
    private var intermediateCalculation: (method: String, number: Double)?
    
    mutating func setNumber(_ number: Double) {
        self.number = number
    }
    
    mutating func performCalculation(withMethod calcMethod: String) -> Double? {
        if let num = number {
            switch calcMethod {
            case "+/-":
                return num * -1
            case "AC":
                return 0
            case "%":
                return num / 100                
            case "=":
                return performTwoNumCalculation(number2: num)
            default:
                intermediateCalculation = (method: calcMethod, number: number!)
            }
        }
        return nil
    }
    
    private func performTwoNumCalculation(number2: Double) -> Double? {
        if let number1 = intermediateCalculation?.number, let method = intermediateCalculation?.method {
            switch method {
            case "+":
                return number1 + number2
            case "-":
                return number1 - number2
            case "÷":
                return number1 / number2
            case "×":
                return number1 * number2
            default:
                fatalError("No method found")
            }
        }
        return nil
    }
}
