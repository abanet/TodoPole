//
//  FavoritosCell.swift
//  TodoPole
//
//  Created by Alberto Banet on 21/12/16.
//  Copyright © 2016 Alberto Banet. All rights reserved.
//

import UIKit

class FavoritosCell: FeedCell {

    override func cargarFigurasDeParse(red: Bool) {
        print("En favoritosCell")
        ParseData.sharedInstance.cargarFigurasFavoritas(red: red){
            (figuras:[Figura]) -> Void in
            self.figuras = figuras
            self.collectionView.reloadData()
            self.refresh.endRefreshing()

        }
    }

    // override de la respuesta al protocolo VideoPlayerViewProtocol
    override func didCloseVideoPlayer() {
        self.setupViews()
        print("Llamando protocolo desde FavoritosCell")
    }
}

