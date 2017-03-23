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
    print("En amateursCell")
    ParseData.sharedInstance.cargarFigurasAmateurs(red: red){
      (figuras:[Figura]) -> Void in
      self.figuras = figuras
      self.collectionView.reloadData()
      self.refresh.endRefreshing()
      if figuras.count == 0 {
        self.collectionView.backgroundView = EmptyView(message: "No amateurs moves available right now.")
      } else {
        self.collectionView.backgroundView = nil
      }
    }
    
  }
  
  // override de la respuesta al protocolo VideoPlayerViewProtocol
  override func didCloseVideoPlayer() {
    self.setupViews()
    self.collectionView.allowsSelection = true // activamos de nuevo la selección.
  }
  

}

