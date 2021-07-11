//
//  NetworkManager.swift
//  hnews
//
//  Created by Pavel Romanishkin on 26.03.21.
//

import Foundation

class NetworkManager: ObservableObject {
    
    @Published var posts = [Post]()
    
    func fetchData() {
        if let url = URL(string: "http://hn.algolia.com/api/v1/search?tags=front_page") {
            let session = URLSession(configuration: .default)
            let task = session.dataTask(with: URLRequest(url: url)) { (data, response, error) in
                if error == nil {
                    let decoder = JSONDecoder()
                    if let receivedData = data {
                        do {
                            let decodedData = try decoder.decode(PostData.self, from: receivedData)
                            DispatchQueue.main.async {
                                self.posts = decodedData.hits
                            }
                        } catch {
                            print(error)
                        }
                    }
                }
            }
            task.resume()
        }
    }
}
