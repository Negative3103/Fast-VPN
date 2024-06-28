//
//  String.swift
//  FastVPN
//
//  Created by Хасан Давронбеков on 28/06/24.
//

import UIKit

extension String {
    func changeTimeFormat(from: String, to: String) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = from
        
        guard let newDate = dateFormatter.date(from: self) else { return "" }
        dateFormatter.dateFormat = to
        dateFormatter.locale = Locale.current
        
        return dateFormatter.string(from: newDate)
    }
}
