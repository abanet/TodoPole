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
        NotificationCenter.default.addObserver(self, selector: #selector(refreshCell), name: NSNotification.Name(rawValue: dictionaryCellNeedRefreshNotification), object: nil)
    }
    
    func setupViews() {
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func refreshCell(){
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name(rawValue: dictionaryCellNeedRefreshNotification), object: nil)
    }
  
  //  Notificación de refresco de título
  func notificarUpdateTitle(num: Int, menuOpcion: MainMenu) {
    NotificationCenter.default.post(name: NSNotification.Name(rawValue: titleNeedRefreshNotification), object: nil, userInfo: ["num": num, "menuOpcion": menuOpcion])
  }
    
}
