//
//  NetworkManager.swift
//  FlowerRecognition
//
//  Created by Pavel Romanishkin on 04.04.21.
//

import Foundation
import Alamofire
import SwiftyJSON

struct NetworkManager {
    let wikipediaURl = "https://en.wikipedia.org/w/api.php"
    
    let flowerName = ""
    
    var defaultParameters : [String:String] = [
        "format" : "json",
        "action" : "query",
        "prop" : "extracts|pageimages",
        "exintro" : "",
        "explaintext" : "",
        "indexpageids" : "",
        "redirects" : "1",
        "pithumbsize" : "500"
    ]
    
    mutating func fetchFlower(flowerName: String, completion: @escaping ([String:String]) -> ()) {
        defaultParameters["titles"] = flowerName
        let request = AF.request(wikipediaURl, parameters: defaultParameters)
        DispatchQueue.main.async {
            request.responseJSON { (response) in
                guard let data = response.data else {
                    fatalError("Error fetching response")
                }
                do {
                    let json = try JSON(data: data)
                    if let id = json["query"]["pageids"].array?.first?.string {
                        var output: [String:String] = [:]
                        output["text"] = json["query"]["pages"][id]["extract"].string!
                        output["image"] = json["query"]["pages"][id]["thumbnail"]["source"].string!
                        completion(output)
                    }
                } catch {
                    print(error)
                }
                
            }
        }
    }
}
