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
        if tipo == nil {
        ParseData.sharedInstance.cargarFigurasVisibles(red: red){
            (figuras:[Figura]) -> Void in
            self.figuras = figuras
            self.collectionView.reloadData()
            self.refresh.endRefreshing()

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
            if !red {
            self.collectionView.scrollToItem(at: IndexPath(row: 0, section: 0),
                                        at: .top,
                                        animated: true)
            }

        }
    }
    
    
    
}
