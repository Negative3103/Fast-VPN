//
//  LanguageCollectionViewCell.swift
//  FastVPN
//
//  Created by Хасан Давронбеков on 16/06/24.
//

import UIKit

final class LanguageCollectionViewCell: UICollectionViewCell {
    
    //MARK: - Outlets
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var checkImageView: UIImageView!
    
    //MARK: - Attributes
    internal var items: LanguageModel? {
        didSet {
            guard let items = items else { return }
            titleLabel.text = items.name
        }
    }
    
    internal var didSelect: Bool = false {
        didSet {
            titleLabel.textColor = didSelect ? .appColor(.black) : .appColor(.gray)
            checkImageView.image = didSelect ? UIImage(systemName: "checkmark.circle") : .appImage(.uncheck)
        }
    }
    
    //MARK: - Lifecycles
    
}
