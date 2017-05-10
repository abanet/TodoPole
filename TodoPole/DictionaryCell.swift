//
//  DictionaryCell.swift
//  TodoPole
//
//  Created by Alberto Banet on 21/12/16.
//  Copyright © 2016 Alberto Banet. All rights reserved.
//

import UIKit

class DictionaryCell: FeedCell {

    var tipo: TipoFigura?
    
    override func cargarFigurasDeParse(red: Bool) {
      print("cargando datos en DictionaryCell")
        if tipo == nil {
        ParseData.sharedInstance.cargarFigurasVisibles(red: red){
            (figuras:[Figura]) -> Void in
            self.figuras = figuras
            self.collectionView.reloadData()
            self.refresh.endRefreshing()
            if figuras.count == 0 {
                self.collectionView.backgroundView = EmptyView(message: "Check your filters!. It seems there is nothing to show to you with the actual settings.")
            } else {
                self.collectionView.backgroundView = nil
                self.notificarUpdateTitle(num: figuras.count, menuOpcion: .polemoves)
            }
        }
        } else {
            cargarFigurasDeParse(tipo: tipo!, red: red)
            
        }
    }
    
    func cargarFigurasDeParse(tipo: TipoFigura, red: Bool) {
        ParseData.sharedInstance.cargarFigurasTipo(tipo, red: red) {
            (figuras:[Figura]) -> Void in
            self.figuras = figuras
            self.collectionView.reloadData()
            self.refresh.endRefreshing()
            if !red && figuras.count > 0 {
                self.collectionView.scrollToItem(at: IndexPath(row: 0, section: 0),
                                                 at: .top,
                                                 animated: true)
            }
          // Para tenerlos leídos de antemano
          if ParseData.sharedInstance.primeraVezAutoresLeidos {
            let _ = ParseData.sharedInstance.listOfAuthorsNow()
          }
            if figuras.count == 0 {
                self.collectionView.backgroundView = EmptyView(message: "Check your filters!. It seems there is nothing to show you with the actual settings.")
            } else {
                self.collectionView.backgroundView = nil
            }
          self.notificarUpdateTitle(num: figuras.count, menuOpcion: .polemoves)
        }
    }
    
    override func refreshCell() {
        //self.cargarFigurasDeParse(red: false)
        // Parece que no es necesario cargar de nuevo y provoca malfuncionamiento con el refresco del título.
    }
  
  
  
}
