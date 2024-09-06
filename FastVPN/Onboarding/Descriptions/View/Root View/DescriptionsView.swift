//
//  DescriptionsView.swift
//  FastVPN
//
//  Created by Хасан Давронбеков on 13/08/24.
//

import UIKit

final class DescriptionsView: CustomView {
    
    //MARK: - Outlets
    @IBOutlet weak var collectionView: UICollectionView! {
        didSet {
            collectionView.register(UINib(nibName: DescriptionsCollectionViewCell.defaultReuseIdentifier, bundle: nil), forCellWithReuseIdentifier: DescriptionsCollectionViewCell.defaultReuseIdentifier)
        }
    }
    @IBOutlet weak var nextButton: HighlightButton! {
        didSet {
            nextButton.setBorder(enable: true, borderWidth: 1.5, color: .white)
            nextButton.layer.cornerRadius = 16
        }
    }
}
