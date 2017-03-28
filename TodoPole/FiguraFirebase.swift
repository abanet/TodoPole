//
//  FiguraFirebase.swift
//  TodoPole
//
//  Created by Alberto Banet on 9/2/17.
//  Copyright © 2017 Alberto Banet. All rights reserved.
//

import UIKit

class FiguraFirebase: NSObject {
  var nombre: String
  var mail:   String
  var autor:  String
  var studio: String
  var pro:    Bool
  
  init(nombre: String, mail: String, autor: String, studio: String, pro: Bool) {
        self.nombre = nombre
        self.mail   = mail
        self.autor  = autor
        self.studio = studio
        self.pro    = pro
    }
    
    func formatoArray() -> [String:String] {
        return ["nombre": nombre, "mail": mail, "autor": autor, "studio": studio, "pro": String(pro)]
    }
}
