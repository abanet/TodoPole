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
    
    
} // Fin de la clase
