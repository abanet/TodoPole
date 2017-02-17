//
//  EmptyView.swift
//  TodoPole
//
//  Created by Alberto Banet on 13/2/17.
//  Copyright © 2017 Alberto Banet. All rights reserved.
//

import UIKit

class EmptyView: UIView {

    
    var messageLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "Avenir-Medium", size:22)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Giro"
        label.lineBreakMode = NSLineBreakMode.byWordWrapping
        label.numberOfLines = 5
        label.textColor = ColoresApp.darkPrimary
        label.textAlignment = .center
        return label
    }()
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.addSubview(messageLabel)
        messageLabel.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        messageLabel.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        messageLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -8).isActive = true
        messageLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 8).isActive = true
    }
    
    convenience init(message: String) {
        self.init(frame: CGRect.zero)
        messageLabel.text = message
    }
}
