//
//  ParseData.swift
//  TodoPole
//
//  Created by Alberto Banet on 15/12/16.
//  Copyright © 2016 Alberto Banet. All rights reserved.
//

import Foundation
import Parse

class ParseData: NSObject {
    
    static let sharedInstance = ParseData()
    
    func cargarFigurasVisibles(completion: @escaping ([Figura]) -> ()) {
        let query = PFQuery(className:"Figura")
        query.whereKey("visible", equalTo: true)
        cargarQueryParse(query, completion: completion)
    }
    
    func cargarFigurasFavoritas(completion: @escaping ([Figura]) -> ()) {
        let query = PFQuery(className:"Figura")
        query.whereKey("visible", equalTo: true)
        query.whereKey("autor", equalTo: "Tania Guillén")
        cargarQueryParse(query, completion: completion)
    }
    
    func cargarQueryParse(_ query: PFQuery<PFObject>, completion: @escaping ([Figura]) -> ()) {
        query.limit = 200 // límite impuesto por Parse
        query.cachePolicy = .cacheElseNetwork
        query.findObjectsInBackground {
            (objects: [PFObject]?, error: Error?) -> Void in
            if error == nil { // datos encontrados
                var figuras = [Figura]()
                for object in objects! {
                    let nuevaFigura = Figura(object: object)
                    figuras.append(nuevaFigura)
                }
                DispatchQueue.main.async {
                    completion(figuras)
                }
            } else {
                // No hay datos ni en la red ni en la caché...ups!
            }
        }
    }
}
