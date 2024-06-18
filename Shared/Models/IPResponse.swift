//
//  IPResponse.swift
//  FastVPN
//
//  Created by Хасан Давронбеков on 17/06/24.
//

import Foundation

struct IPResponse: Decodable {
    let ip: String
}

struct LocationResponse: Decodable {
    let country: String
}
