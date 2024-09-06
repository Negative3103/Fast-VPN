//
//  DescriptionsCollectionViewCell.swift
//  FastVPN
//
//  Created by Хасан Давронбеков on 13/08/24.
//

import UIKit

final class DescriptionsCollectionViewCell: UICollectionViewCell {
    
    //MARK: - Outlets
    @IBOutlet weak var titleLabel: UILabel!
    
    //MARK: - Attributes
    internal var item: DescriptionsModel? {
        didSet {
            guard let title = item?.title else { return }
            titleLabel.text = title
        }
    }
    
    //MARK: - Lifecycles
    override func layoutSubviews() {
        super.layoutSubviews()
        layer.cornerRadius = 16
        setBorder(enable: true, borderWidth: 1.5, color: .white)
    }
}
