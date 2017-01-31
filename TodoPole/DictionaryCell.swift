//
//  DictionaryCell.swift
//  TodoPole
//
//  Created by Alberto Banet on 21/12/16.
//  Copyright © 2016 Alberto Banet. All rights reserved.
//

import UIKit

class DictionaryCell: FeedCell {

    override func cargarFigurasDeParse(red: Bool) {
        print("Llamada a DictionaryCell")
        ParseData.sharedInstance.cargarFigurasVisibles(red: red){
            (figuras:[Figura]) -> Void in
            self.figuras = figuras
            self.collectionView.reloadData()
            self.refresh.endRefreshing()

        }
    }
    
}
