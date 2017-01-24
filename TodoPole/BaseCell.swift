//
//  BaseCell.swift
//  TodoPole
//
//  Created by Alberto Banet on 5/1/17.
//  Copyright © 2017 Alberto Banet. All rights reserved.
//

import UIKit

class BaseCell: UICollectionViewCell {
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    func setupViews() {
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
