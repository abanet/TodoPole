//
//  DictionaryCell.swift
//  TodoPole
//
//  Created by Alberto Banet on 21/12/16.
//  Copyright © 2016 Alberto Banet. All rights reserved.
//

import UIKit

class DictionaryCell: FeedCell {

    override func cargarFigurasDeParse() {
        ParseData.sharedInstance.cargarFigurasVisibles(){
            (figuras:[Figura]) -> Void in
            self.figuras = figuras
            self.collectionView.reloadData()
        }
    }
}
