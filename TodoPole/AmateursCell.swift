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
    print("cargando datos en AmateursCell")
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
    //self.cargarFigurasDeParse(red: false)
    // Parece que no es necesario cargar de nuevo y provoca malfuncionamiento con el refresco del título.
  }
  
  
  

}

