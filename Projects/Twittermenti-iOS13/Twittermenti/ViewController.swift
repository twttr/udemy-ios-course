//
//  ViewController.swift
//  Twittermenti
//
//  Created by Angela Yu on 17/07/2019.
//  Copyright © 2019 London App Brewery. All rights reserved.
//

import UIKit
import SwifteriOS
import CoreML
import SwiftyJSON

class ViewController: UIViewController {
    
    @IBOutlet weak var backgroundView: UIView!
    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var sentimentLabel: UILabel!
    let textClassifier = try! twitter(configuration: MLModelConfiguration())
    let tweetCount = 100
    
    let swifter = Swifter(
        consumerKey: "k6NSFXpUjDinkLCTTegZcxoiK",
        consumerSecret: "7y90fKrg3uFpbFq1KYA47KklFdxK8bWzEpMvGaNzTZGiRoZukB"
    )

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    @IBAction func predictPressed(_ sender: Any) {
        fetchTweets()
    }
    
    func fetchTweets() {
        if let searchText = textField.text {
            swifter.searchTweet(using: searchText, lang: "en", count: tweetCount, tweetMode: .extended) { (results, metadata) in
                var tweetsArray = [twitterInput]()
                for i in 0..<self.tweetCount {
                    if let tweet = results[i]["full_text"].string {
                        let tweetForInput = twitterInput(text: tweet)
                        tweetsArray.append(tweetForInput)
                    }
                }
                
                self.makePrediction(with: tweetsArray)
            } failure: { (error) in
                print(error)
            }
        }
    }
    
    func makePrediction(with tweets: [twitterInput]) {
        do {
            var sentScore = 0
            let predictions = try self.textClassifier.predictions(inputs: tweets)
            for prediction in predictions {
                let sent = prediction.label
                
                if sent == "Neg" {
                    sentScore -= 1
                } else if sent == "Pos" {
                    sentScore += 1
                }
            }
            updateUI(with: sentScore)
        } catch {
            print(error)
        }
    }
    
    func updateUI(with score: Int) {
        if score > 20 {
            self.sentimentLabel.text = "😍"
        } else if score > 10 {
            self.sentimentLabel.text = "😀"
        } else if score > 0 {
            self.sentimentLabel.text = "🙂"
        } else if score == 0 {
            self.sentimentLabel.text = "😐"
        } else if score > -10 {
            self.sentimentLabel.text = "😕"
        } else if score > -20 {
            self.sentimentLabel.text = "😡"
        } else {
            self.sentimentLabel.text = "🤮"
        }
    }
}

