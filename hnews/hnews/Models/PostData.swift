//
//  PostData.swift
//  hnews
//
//  Created by Pavel Romanishkin on 26.03.21.
//

import Foundation

struct PostData: Decodable {
    let hits: [Post]
}

struct Post: Decodable, Identifiable {
    var id: String {
        return objectID
    }
    let objectID: String
    let title: String
    let url: String?
    let points: Int
    
}
