//
//  ConfiguracionNiveles.swift
//  TodoPole
//
//  Created by Alberto Banet Masa on 5/4/17.
//  Copyright © 2017 Alberto Banet. All rights reserved.
//

import Foundation

class ConfigurationNiveles {
  
  var nivelesBloqueados: [String]?
  static let maxNivel = 6
  
  static func getNivelesBloqueados() -> [String]? {
    return UserDefaults.standard.array(forKey: "nivelesBloqueados") as! [String]?
  }
  
  static func setNivelesBloqueados(autores: [String]) {
    UserDefaults.standard.set(autores, forKey: "nivelesBloqueados")
  }
  
}
