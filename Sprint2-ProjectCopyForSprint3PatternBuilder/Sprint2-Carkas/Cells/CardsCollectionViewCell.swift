
//
//  CategoryTrelloCollectionViewCell.swift
//  Sprint2-Carkas
//
//  Created by Дмитрий Гришин on 11/11/2019.
//  Copyright © 2019 Дмитрий Гришин. All rights reserved.
//

import UIKit

class CardsCollectionViewCell: UICollectionViewCell {
    public static let reuseId = "CardsCollectionViewCellId"
    public let label = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = .white
        label.frame = contentView.frame
        label.font = UIFont.systemFont(ofSize: 16)
        label.textAlignment = .left
        contentView.addSubview(label)
        label.isHidden = false
        label.layer.borderWidth = 0
        label.layer.cornerRadius = 5
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
