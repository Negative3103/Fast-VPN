//
//  TariffsView.swift
//  FastVPN
//
//  Created by Хасан Давронбеков on 13/08/24.
//

import UIKit

final class TariffsView: CustomView {
    
    //MARK: - Outlets
    @IBOutlet weak var tableView: UITableView! {
        didSet {
            tableView.register(UINib(nibName: TariffsTableViewCell.defaultReuseIdentifier, bundle: nil), forCellReuseIdentifier: TariffsTableViewCell.defaultReuseIdentifier)
        }
    }
    @IBOutlet weak var nextButton: HighlightButton! {
        didSet {
            nextButton.setBorder(enable: true, borderWidth: 1.5, color: .white)
            nextButton.layer.cornerRadius = 16
        }
    }
}
