//
//  Figura.swift
//  TodoPole
//
//  Created by Alberto Banet on 15/12/16.
//  Copyright © 2016 Alberto Banet. All rights reserved.
//

//  Figura contiene todos los elementos de una figura de Pole Dance
import Foundation
import Parse

enum TipoFigura: String {
    case giro = "giro"
    case suelo = "suelo"
    case figura = "figura"
    case subida = "subida"
    case transicion = "transición"
}

class Figura: NSObject {
    var objectId    : String?
    var nombre      : String?
    var englishName : String?
    var autor       : String?
    var nivel       : String?
    var descripcion : String?
    var fileFoto    : PFFile?   // se trata diferente
    var tipo        : String?
    var updateAt    : Date?     // se trata diferente
    var visible     : Bool?
    var escuela     : Escuela?
    var urlStringVideo    : String?
    var fileVideo   : PFFile?
    
   
    // var escuelaId: Escuela?
    
    // Iniciación de una Figura a partir de un PFObject
    // PFObject es el resultado empaquetado que devuelve Parse para una figura.
    init(object: PFObject){
        objectId    = object.objectId
        nombre      = object["nombre"] as? String
        englishName = object["EnglishName"] as? String
        autor       = object["autor"] as? String
        nivel       = object["nivel"] as? String
        descripcion = object["descripcion"] as? String
        tipo        = object["tipo"] as? String
        updateAt    = object.updatedAt
        visible     = object["visible"] as? Bool
        fileFoto    = object["foto"] as? PFFile
        fileVideo   = object["video"] as? PFFile
        urlStringVideo = fileVideo?.url
        
    }

}
