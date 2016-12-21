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
        ParseData.sharedInstance.cargarFigurasFavoritas(){
            (figuras:[Figura]) -> Void in
            self.figuras = figuras
            self.collectionView.reloadData()
        }
    }

}
