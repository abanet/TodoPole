//
//  Escuela.swift
//  TodoPole
//
//  Created by Alberto Banet on 23/12/16.
//  Copyright © 2016 Alberto Banet. All rights reserved.
//

import UIKit
import Parse

class Escuela: NSObject {
    var objectId:       String?
    var foto:           PFFile?
    var nombre:         String?
    var descripcion:    String?
    var provincia:      String?
    var pais:           String?
    var createAt:       Date?
    var updateAt:       Date?
    var direccion:      String?
    var web:            String?
    var mail:           String?
    var movil:          String?
    var fijo:           String?
    var visible:        Bool?
    //var posicionGPS:    ...
    
    init(object: PFObject){
        objectId    = object.objectId
        foto        = object["foto"] as? PFFile
        nombre      = object["nombre"] as? String
        descripcion = object["descripcion"] as? String
        provincia   = object["provincia"] as? String
        pais        = object["pais"] as? String
        createAt    = object.createdAt
        updateAt    = object.updatedAt
        direccion   = object["direccion"] as? String
        web         = object["web"] as? String
        mail        = object["mail"] as? String
        movil       = object["movil"] as? String
        fijo        = object["fijo"] as? String
        visible     = object["visible"] as? Bool
    }
}
