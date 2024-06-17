//
//  CustomDecoder.swift
//  FastVPN
//
//  Created by Хасан Давронбеков on 16/06/24.
//

import Foundation

final class CustomDecoder: JSONDecoder {
    override init() {
        super.init()
        keyDecodingStrategy = .convertFromSnakeCase
    }
}
