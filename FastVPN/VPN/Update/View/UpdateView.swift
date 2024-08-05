//
//  UpdateView.swift
//  FastVPN
//
//  Created by Хасан Давронбеков on 31/07/24.
//

import UIKit

final class UpdateView: CustomView {
    
    //MARK: - Outlets
    @IBOutlet weak var acceptButton: HighlightButton!
    
    //MARK: - Lifecycles
    override func layoutSubviews() {
        super.layoutSubviews()
        acceptButton.layer.cornerRadius = 10
    }
}
