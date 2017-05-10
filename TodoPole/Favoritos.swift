//
//  Favoritos.swift
//  TodoPole
//
//  Created by Alberto Banet on 25/1/17.
//  Copyright © 2017 Alberto Banet. All rights reserved.
//

import UIKit

class Favoritos: NSObject {
    static let sharedInstance = Favoritos()
    
    var arrayFavoritos: [String] = {
        let favoritosEnUserDefaults = UserDefaults.standard.array(forKey:"favoritos") as! [String]?
        if favoritosEnUserDefaults != nil {
            return favoritosEnUserDefaults!
        }
        return [String]()
    }()
    
    func addFavorito(id: String) {
        arrayFavoritos.append(id)
        UserDefaults.standard.set(arrayFavoritos, forKey: "favoritos")
        print("Favorito (\(id)) añadido quedando: \(arrayFavoritos)")
    }
    
    func removeFavorito(id: String) {
        arrayFavoritos = arrayFavoritos.filter { $0 != id }
        UserDefaults.standard.set(arrayFavoritos, forKey: "favoritos")
        print("Favorito quitado quedando: \(arrayFavoritos)")
    }
    
    func isFavorito(id: String) -> Bool {
        return arrayFavoritos.contains(id)
    }
  
  func changeFavoritoAt(_ origen: Int, porPosicion posicionFinal: Int) {
    let valorEnFinal = arrayFavoritos[posicionFinal]
    arrayFavoritos[posicionFinal] = arrayFavoritos[origen]
    arrayFavoritos[origen] = valorEnFinal
    UserDefaults.standard.set(arrayFavoritos, forKey: "favoritos")
  }
}
