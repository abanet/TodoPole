//
//  ConfiguracionAutores.swift
//  TodoPole
//
//  Created by Alberto Banet on 18/3/17.
//  Copyright © 2017 Alberto Banet. All rights reserved.
//

import Foundation

class ConfigurationAutores {
    
    var autoresBloqueados: [String]?
    
    
    static func getAutoresBloqueados() -> [String]? {
        return UserDefaults.standard.array(forKey: "autoresBloqueados") as! [String]?
    }
    
    static func setAutoresBloqueados(autores: [String]) {
        UserDefaults.standard.set(autores, forKey: "autoresBloqueados")
    }
    
}
