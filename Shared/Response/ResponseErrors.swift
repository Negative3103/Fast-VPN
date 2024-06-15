//
//  ResponseErrors.swift
//  FastVPN
//
//  Created by Хасан Давронбеков on 15/06/24.
//

enum Result<T> {
    case Success(T)
    case Error(APIError, String? = nil)
}

enum APIError: Error {
    case requestFailed
    case invalidData
    case responseUnsuccessful
    case serverError
    case notAuthorized
    case fromMessage
    case notEnoughBalance
    case noSubscription
}
