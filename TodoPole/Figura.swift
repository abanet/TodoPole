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
    case combos = "combo"
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
  var createdAt   : Date?
  var visible     : Bool?
  var escuela     : Escuela?
  var urlStringVideo    : String?
  var fileVideo   : PFFile?
  var likes       : Int?
  var profesional : Bool?
  var email       : String?
  var instagram   : Bool?
  
  
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
    createdAt   = object.createdAt
    visible     = object["visible"] as? Bool
    fileFoto    = object["foto"] as? PFFile
    fileVideo   = object["video"] as? PFFile
    urlStringVideo = fileVideo?.url
    likes       = object["likes"] as? Int
    profesional = object["profesional"] as? Bool
    email       = object["email"] as? String
    instagram   = object["instagram"] as? Bool
  }
  
    func tieneFormatoInstagram() -> Bool {
        if let formatoInstagram = self.instagram, formatoInstagram {
            return true
        } else {
            return false
        }
    }
}
