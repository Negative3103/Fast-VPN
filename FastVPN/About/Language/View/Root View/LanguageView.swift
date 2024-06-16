//
//  LanguageView.swift
//  FastVPN
//
//  Created by Хасан Давронбеков on 16/06/24.
//

import UIKit

final class LanguageView: UIView {
    
    //MARK: - Outlets
    @IBOutlet weak var collectionView: UICollectionView! {
        didSet {
            collectionView.register(UINib(nibName: LanguageCollectionViewCell.defaultReuseIdentifier, bundle: nil), forCellWithReuseIdentifier: LanguageCollectionViewCell.defaultReuseIdentifier)
        }
    }
}
