//
//  ExchangeData.swift
//  ByteCoin
//
//  Created by Pavel Romanishkin on 16.03.21.
//  Copyright © 2021 The App Brewery. All rights reserved.
//

import Foundation

struct ExchangeData: Decodable {
    let rate: Double
    let asset_id_quote: String
}
