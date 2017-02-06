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
    
       
    // Cargar todas las figuras visibles desde la cache si hay
    func cargarFigurasVisibles(red: Bool, completion: @escaping ([Figura]) -> ()) {
        
        let query = PFQuery(className:"Figura")
        if red {
            query.cachePolicy = .networkOnly
        } else {
            query.cachePolicy = .cacheElseNetwork
        }
        query.whereKey("visible", equalTo: true)
        query.order(byDescending: "updatedAt")
        cargarQueryParse(query, completion: completion)
    }
    
    // Cargar las figuras favoritas
    func cargarFigurasFavoritas(red: Bool, completion: @escaping ([Figura]) -> ()) {
         let arrayFavoritos = Favoritos.sharedInstance.arrayFavoritos 
            print("vamos a buscar lo que está en arrayFav: \(arrayFavoritos)")
            let query = PFQuery(className:"Figura")
            if red {
                query.cachePolicy = .networkOnly
            } else {
                query.cachePolicy = .cacheElseNetwork
            }
            query.whereKey("objectId", containedIn: arrayFavoritos)
            query.whereKey("visible", equalTo: true)
            cargarQueryParse(query, completion: completion)
    }
    
    
    
    // Cargas las figuras que se corresponden con un tipo dado
    // tipo -> Tipo de las figuras que se van a cargar
    func cargarFigurasTipoGiro (tipo: TipoFigura, completion: @escaping ([Figura]) -> ()) {
        let query = PFQuery(className:"Figura")
        query.whereKey("visible", equalTo: true)
        query.whereKey("tipo", equalTo: tipo.rawValue)
        cargarQueryParse(query, completion: completion)
    }
    
    
    
    private func cargarQueryParse(_ query: PFQuery<PFObject>, completion: @escaping ([Figura]) -> ()) {
        query.limit = 200 // límite impuesto por Parse
        query.includeKey("escuelaId")
        query.findObjectsInBackground {
            (objects: [PFObject]?, error: Error?) -> Void in
            if error == nil { // datos encontrados
                var figuras = [Figura]()
                for object in objects! {
                    let nuevaFigura = Figura(object: object)
                    // leemos la escuela
                    if let pfEscuela = object.object(forKey: "escuelaId") as? PFObject {
                        let escuela = Escuela(object: pfEscuela)
                        nuevaFigura.escuela = escuela
                    }
                    figuras.append(nuevaFigura)
                }
                DispatchQueue.main.async {
                    completion(figuras)
                }
            } else {
                // No hay datos ni en la red ni en la caché...ups!
                print("no estamos encontrando datos")
            }
        }
    }
    
    
    
    // carga un vídeo de parse
    // No hace falta: usar url directamente
    func cargarVideo(figura: Figura, completion: @escaping (Data)-> Void) {
        print("vamos a visionar \(figura.nombre)")
        if let videoFile = figura.fileVideo {
            print("url del video: \(figura.urlStringVideo)")
            videoFile.getDataInBackground(block: {
                (videoData: Data?, error: Error?) in
                guard error != nil else { return }
                if let video = videoData {
                    // tenemos el fichero con el vídeo para mostrar
                    completion(video)
                }
            })
        }
        
    }
    
    
    // Incrementamos el campo likes de la figura
    func incrementarLikes(figura: Figura) {
        var query = PFQuery(className:"Figura")
        query.getObjectInBackground(withId: figura.objectId!) {
            (figura: PFObject?, error: Error?) -> Void in
            if error == nil && figura != nil {
                figura?.incrementKey("likes")
                figura?.saveInBackground()
            } else {
                print("error")
            }
        }
    }
    
    
       
} // Fin de la clase
