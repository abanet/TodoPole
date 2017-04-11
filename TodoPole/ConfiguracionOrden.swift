//
//  ConfiguracionOrden.swift
//  TodoPole
//
//  Created by Alberto Banet Masa on 7/4/17.
//  Copyright © 2017 Alberto Banet. All rights reserved.
//

import Foundation

enum OrdenType: String {
  case lastViewed
  case createdDate
  case likes
}

class ConfigurationOrden {
  
  static func getOrden() -> String? {
    return UserDefaults.standard.string(forKey: "ordenType")
  }
  
  static func setOrden(_ orden: OrdenType) {
    UserDefaults.standard.set(orden.rawValue, forKey: "ordenType")  }
  
  static func fieldOrderDatabase()->String {
    let ordenacion = getOrden()
    
    if let orden = ordenacion {
      switch orden {
      case OrdenType.createdDate.rawValue:
        return "createdAt"
      case OrdenType.lastViewed.rawValue:
        return "updatedAt"
      case OrdenType.likes.rawValue:
        return "likes"
      default:
        return "updatedAt"
      }
    } else {
      return "updatedAt"
    }

  }
  
  func fieldToOrderBy(orden: String) -> String {
    
    return "updatedAt"
  }
}
