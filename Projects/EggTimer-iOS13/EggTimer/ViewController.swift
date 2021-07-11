//
//  ViewController.swift
//  EggTimer
//
//  Created by Angela Yu on 08/07/2019.
//  Copyright © 2019 The App Brewery. All rights reserved.
//

import UIKit
import AVFoundation

class ViewController: UIViewController {
    
    @IBOutlet weak var progressBar: UIProgressView!
    @IBOutlet weak var mainLabel: UILabel!
    
    let eggTimes: [String: Int] = ["Soft": 5, "Medium": 420, "Hard": 720]
    var totalTime = 0
    var secondsPassed = 0
    var timer = Timer()
    var player: AVAudioPlayer?
    
    @IBAction func hardnessSelected(_ sender: UIButton) {
        let hardness = sender.currentTitle!
        
        timer.invalidate()
        
        progressBar.progress = 0
        secondsPassed = 0
        
        mainLabel.text = "How do you like your eggs?"
        
        totalTime = eggTimes[hardness]!
        timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(countdown), userInfo: nil, repeats: true)
    }
    
    @objc func countdown() {
        if secondsPassed < totalTime {
            secondsPassed += 1
            let percentageProgress = Float(secondsPassed) / Float(totalTime)
            progressBar.progress = percentageProgress
        } else {
            timer.invalidate()
            mainLabel.text = "Done"
            guard let url = Bundle.main.url(forResource: "alarm_sound", withExtension: "mp3") else { return }
            
            player =  try! AVAudioPlayer(contentsOf: url, fileTypeHint: AVFileType.mp3.rawValue)

            player!.play()

        }
    }
}
