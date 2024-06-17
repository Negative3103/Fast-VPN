//
//  JSONData.swift
//  FastVPN
//
//  Created by Хасан Давронбеков on 15/06/24.
//

import Foundation

struct JSONData<T: Decodable>: Decodable {
    var data: T?
    var server: String?
    var tokenEndDate: String?
    var message: String?
}
