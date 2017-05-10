//
//  YourEvolutionCell.swift
//  TodoPole
//
//  Created by Alberto Banet Masa on 8/5/17.
//  Copyright © 2017 Alberto Banet. All rights reserved.
//

import UIKit

class YourEvolutionCell: FeedCell {
  
  
  override func cargarFigurasDeParse(red: Bool) {
    ParseData.sharedInstance.cargarFigurasEvolution(red: red){
      (figuras:[Figura]) -> Void in
      self.figuras = figuras
      self.collectionView.reloadData()
      self.refresh.endRefreshing()
      if figuras.count == 0 {
        let config = DefaultConfiguration()
        self.collectionView.backgroundView = EmptyView(message: "Sorry, You dont have uploaded any move with the email set as the Evolution user: \(config.evolutionMail ?? "not Evolution mail founded").")
      } else {
        self.collectionView.backgroundView = nil
      }
      self.notificarUpdateTitle(num: figuras.count, menuOpcion: .yourEvolution)
    }
    
  }
  
  override func refreshCell() {
    self.cargarFigurasDeParse(red: false)
    // Parece que no es necesario cargar de nuevo y provoca malfuncionamiento con el refresco del título.
  }
  
    
}
