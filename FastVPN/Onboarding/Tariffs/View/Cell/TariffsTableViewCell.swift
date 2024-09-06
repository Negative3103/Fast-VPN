//
//  TariffsTableViewCell.swift
//  FastVPN
//
//  Created by Хасан Давронбеков on 13/08/24.
//

import UIKit

final class TariffsTableViewCell: CustomTableViewCell {
    
    //MARK: - Outlets
    @IBOutlet weak var titleLabel: UILabel!
    
    //MARK: - Attributes
    internal var item: TariffModel? {
        didSet {
            
        }
    }
    
    internal var didSelect: Bool = false {
        didSet {
            titleLabel.textColor = didSelect ? .appColor(.newBlack) : .white
            self.backgroundColor = didSelect ? .white : .clear
        }
    }
    
    //MARK: - Lifecycles
    override func layoutSubviews() {
        super.layoutSubviews()
        self.layer.cornerRadius = 16
        self.setBorder(enable: true, borderWidth: 1.5, color: .white)
    }
}
