//
//  Cell.swift
//  CustomCardList
//
//  Created by RavikumarBukka on 04/10/18.
//  Copyright © 2018 RavikumarBukka. All rights reserved.
//

import UIKit

class Cell: UICollectionViewCell {
    
    let label = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        label.numberOfLines = 0
        backgroundColor = .orange
        contentView.addSubview(label)
        
        label.translatesAutoresizingMaskIntoConstraints = false
        label.topAnchor.constraint(equalTo: contentView.layoutMarginsGuide.topAnchor).isActive = true
        label.leadingAnchor.constraint(equalTo: contentView.layoutMarginsGuide.leadingAnchor).isActive = true
        label.trailingAnchor.constraint(equalTo: contentView.layoutMarginsGuide.trailingAnchor).isActive = true
        label.bottomAnchor.constraint(equalTo: contentView.layoutMarginsGuide.bottomAnchor).isActive = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func preferredLayoutAttributesFitting(_ layoutAttributes: UICollectionViewLayoutAttributes) -> UICollectionViewLayoutAttributes {
        layoutIfNeeded()
        label.preferredMaxLayoutWidth = label.bounds.size.width
        layoutAttributes.bounds.size.height = contentView.systemLayoutSizeFitting(UILayoutFittingCompressedSize).height
        return layoutAttributes
    }
    
    // Alternative implementation
    /*
     override func preferredLayoutAttributesFitting(_ layoutAttributes: UICollectionViewLayoutAttributes) -> UICollectionViewLayoutAttributes {
     label.preferredMaxLayoutWidth = layoutAttributes.size.width - contentView.layoutMargins.left - contentView.layoutMargins.right
     layoutAttributes.bounds.size.height = contentView.systemLayoutSizeFitting(UILayoutFittingCompressedSize).height
     return layoutAttributes
     }
     */
    
}
