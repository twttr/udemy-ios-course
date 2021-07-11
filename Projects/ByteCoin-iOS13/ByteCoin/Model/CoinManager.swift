//
//  CoinManager.swift
//  ByteCoin
//
//  Created by Angela Yu on 11/09/2019.
//  Copyright © 2019 The App Brewery. All rights reserved.
//

import Foundation

protocol CoinManagerDelegate {
    func didUpdateRate(_ coinManager: CoinManager, coin: CoinModel)
    func didFailWithError(error: Error)
}

struct CoinManager {
    
    var delegate: CoinManagerDelegate?
    
    let baseURL = "https://rest.coinapi.io/v1/exchangerate/BTC"
    let apiKey = "5E42CD5F-F0B7-49FE-B0BA-B63180EC657B"
    
    let currencyArray = ["AUD", "BRL","CAD","CNY","EUR","GBP","HKD","IDR","ILS","INR","JPY","MXN","NOK","NZD","PLN","RON","RUB","SEK","SGD","USD","ZAR"]

    func getCoinPrice(for currency: String) {
        let urlString = "\(baseURL)/\(currency)?apikey=\(apiKey)"
        performRequest(with: urlString)
    }
    
    func performRequest(with urlString: String) {
        if let url = URL(string: urlString) {
            let urlSession = URLSession(configuration: .default)
            
            let task = urlSession.dataTask(with: url) { (data, response, error) in
                if error != nil {
                    delegate?.didFailWithError(error: error!)
                    return
                }
                if let safeData = data {
                    print(safeData)
                    if let exchangeData = parseJSON(safeData) {
                        delegate?.didUpdateRate(self, coin: exchangeData)
                    }
                }
            }
            task.resume()
        }
    }
    
    func parseJSON(_ exchangeData: Data) -> CoinModel? {
        let decoder = JSONDecoder()
        
        do {
            let decodedData = try decoder.decode(ExchangeData.self, from: exchangeData)
            let exchangeRate = decodedData.rate
            let currency = decodedData.asset_id_quote
            return CoinModel(currency: currency, rate: exchangeRate)
        } catch {
            delegate?.didFailWithError(error: error)
            return nil
        }
    }
}
