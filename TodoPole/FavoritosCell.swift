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

          self.figuras = self.sortArrayFigurasByFavoritas(figuras: figuras)
         
            self.collectionView.reloadData()
            self.refresh.endRefreshing()
            print("al cargar vemos que en favoritos tenemos: \(figuras.count)")
            if figuras.count == 0 {
                self.collectionView.backgroundView = EmptyView(message: "You don't have any favorite move. To add a favorite just press the heart when you're watching the video.")
            } else {
                self.collectionView.backgroundView = nil
            }
            self.notificarUpdateTitle(num: figuras.count, menuOpcion: .favorites)
        }
        
            }

    // override de la respuesta al protocolo VideoPlayerViewProtocol
    override func didCloseVideoPlayer() {
        self.setupViews()
        self.collectionView.allowsSelection = true // activamos de nuevo la selección.
        //print("Llamando protocolo desde FavoritosCell")
    }
  
  //  Función que ordena la lista de figuras favoritas encontrada en Parse con el array de figuras Favoritas almacenado en userDefaults.
  private func sortArrayFigurasByFavoritas(figuras: [Figura]) -> [Figura] {
    let arrayOrdenado = Favoritos.sharedInstance.arrayFavoritos
    let sorted = figuras.sorted { arrayOrdenado.index(of: $0.objectId!)! > arrayOrdenado.index(of: $1.objectId!)! }
    return sorted
  }
  
  
  override func refreshCell() {
    //self.cargarFigurasDeParse(red: false)
    // Parece que no es necesario cargar de nuevo y provoca malfuncionamiento con el refresco del título.
  }

   func collectionView(_ collectionView: UICollectionView, moveItemAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
    Favoritos.sharedInstance.changeFavoritoAt(sourceIndexPath.item, porPosicion: destinationIndexPath.item)
    let tempFigura = self.figuras![destinationIndexPath.item]
    self.figuras![destinationIndexPath.item] = self.figuras![sourceIndexPath.item]
    self.figuras![sourceIndexPath.item] = tempFigura
  }
  
  func setLongGesture() {
    let longPressGesture = UILongPressGestureRecognizer(target: self, action: #selector(handleLongGesture(_:)))
    self.addGestureRecognizer(longPressGesture)
  }
  
  func handleLongGesture(_ gesture: UILongPressGestureRecognizer) {
    print("long Gesture")
    
      switch(gesture.state) {
        
      case UIGestureRecognizer.State.began:
        guard let selectedIndexPath = self.collectionView.indexPathForItem(at: gesture.location(in: self.collectionView)) else {
          break
        }
        
        collectionView.beginInteractiveMovementForItem(at: selectedIndexPath)
      case UIGestureRecognizer.State.changed:
        collectionView.updateInteractiveMovementTargetPosition(gesture.location(in: gesture.view!))
      case UIGestureRecognizer.State.ended:
        collectionView.endInteractiveMovement()
      default:
        collectionView.cancelInteractiveMovement()
      }
    }
  
  
  
}

