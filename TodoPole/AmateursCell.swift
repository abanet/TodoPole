//
//  Amateurs.swift
//  TodoPole
//
//  Created by Alberto Banet Masa on 23/3/17.
//  Copyright © 2017 Alberto Banet. All rights reserved.
//

import UIKit

class AmateursCell: FeedCell {
  
  
  override func cargarFigurasDeParse(red: Bool) {
    ParseData.sharedInstance.cargarFigurasAmateurs(red: red){
      (figuras:[Figura]) -> Void in
      self.figuras = figuras
      self.collectionView.reloadData()
      self.refresh.endRefreshing()
      if figuras.count == 0 {
        self.collectionView.backgroundView = EmptyView(message: "Sorry, no amateur moves available right now.")
      } else {
        self.collectionView.backgroundView = nil
      }
      self.notificarUpdateTitle(num: figuras.count, menuOpcion: .amateurs)
    }
    
  }
  
  override func refreshCell() {
    self.cargarFigurasDeParse(red: false)
    print("refresh Cell de Amateur cell")
  }
  
  //  Notificación de refresco de título
  func notificarUpdateTitle(num: Int, menuOpcion: MainMenu) {
    NotificationCenter.default.post(name: NSNotification.Name(rawValue: titleNeedRefreshNotification), object: nil, userInfo: ["num": num, "menuOpcion": MainMenu.amateurs])
  }
  

}

