//
//  LanguageModel.swift
//  FastVPN
//
//  Created by Хасан Давронбеков on 16/06/24.
//

import UIKit

struct LanguageModel {
    let name: String
    let domen: String
    
    static let languages: [LanguageModel] = [
        LanguageModel(name: "russian".localized, domen: AppLanguage.ru.rawValue),
        LanguageModel(name: "english".localized, domen: AppLanguage.en.rawValue)
    ]
}
