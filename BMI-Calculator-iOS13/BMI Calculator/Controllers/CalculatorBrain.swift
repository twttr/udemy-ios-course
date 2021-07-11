//
//  CalculatorBrain.swift
//  BMI Calculator
//
//  Created by Pavel Romanishkin on 09.03.21.
//  Copyright © 2021 Angela Yu. All rights reserved.
//

import UIKit

struct CalculatorBrain {
    
    var bmi: BMI?
    
    mutating func calculateBMI(height: Float, weight: Float) {
        let bmiValue =  weight / (height * height)
        
        switch bmiValue {
        case 0..<18.5:
            bmi = BMI(value: bmiValue, advice: "Eat more pies", color: .blue)
        case 18.5..<24.9:
            bmi = BMI(value: bmiValue, advice: "Fit as a fiddle!", color: .green)
        case 24.9..<1000:
            bmi = BMI(value: bmiValue, advice: "Eat less pies!", color: .red)
        default:
            print("Incorrect BMI value")
        }
    }
    
    func getBMIValue() -> String {
        return String(format: "%.1f", bmi?.value ?? "0.0")
    }
    
    func getColor() -> UIColor? {
        return bmi?.color
    }
    
    func getAdvice() -> String? {
        return bmi?.advice
    }
}
