//
//  FavoritosCell.swift
//  TodoPole
//
//  Created by Alberto Banet on 21/12/16.
//  Copyright © 2016 Alberto Banet. All rights reserved.
//

import UIKit

class FavoritosCell: FeedCell {

    override func cargarFigurasDeParse() {
        print("En favoritosCell")
        ParseData.sharedInstance.cargarFigurasFavoritas(){
            (figuras:[Figura]) -> Void in
            self.figuras = figuras
            self.collectionView.reloadData()
        }
    }

    
    override func didCloseVideoPlayer() {
        self.setupViews()
        print("Llamando protocolo desde FavoritosCell")
    }
}

