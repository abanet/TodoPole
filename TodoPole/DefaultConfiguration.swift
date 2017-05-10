//
//  DefaultConfiguration.swift
//  TodoPole
//
//  Created by Alberto Banet on 18/2/17.
//  Copyright © 2017 Alberto Banet. All rights reserved.
//

import Foundation

class DefaultConfiguration {
    
    var mail:   String?
    var autor:  String?
    var studio: String?
    var evolutionMail: String? // For YourEvolucion
    var pro:    Bool?
  
    init() {
        self.mail   = getDefaultMail()
        self.autor  = getDefaultAutor()
        self.studio = getDefaultStudio()
        self.pro    = getDefaultPro()
        self.evolutionMail = getDefaultEvolutionMail()
    }
    
    
    private func getDefaultMail() -> String? {
        return UserDefaults.standard.string(forKey: "defaultMail")
    }
  
    // Si no se ha grabado un mail para la evolución se cogerá el mail utilizado en el último upload.
    private func getDefaultEvolutionMail() -> String? {
      if let evolutionMail = UserDefaults.standard.string(forKey: "defaultEvolutionMail") {
        return evolutionMail
      } else {
        return getDefaultMail()
      }
    }
    
    private func getDefaultAutor() -> String? {
        return UserDefaults.standard.string(forKey: "defaultAutor")
    }
    
    private func getDefaultStudio() -> String? {
        return UserDefaults.standard.string(forKey: "defaultStudio")
    }
  
    private func getDefaultPro() -> Bool? {
        return UserDefaults.standard.bool(forKey: "defaultPro")
    }
    
    func setDefaultMail(mail: String) {
        UserDefaults.standard.set(mail, forKey: "defaultMail")
        self.mail = mail
    }
  
  func setDefaultEvolutionMail(mail: String) {
    UserDefaults.standard.set(mail, forKey: "defaultEvolutionMail")
    self.evolutionMail = mail
  }
  
    func setDefaultAutor(autor: String) {
        UserDefaults.standard.set(autor, forKey: "defaultAutor")
        self.autor = autor
    }
    
    func setDefaultStudio(studio: String) {
        UserDefaults.standard.set(studio, forKey: "defaultStudio")
        self.studio = studio
    }
  
    func setDefaultPro(pro: Bool) {
      UserDefaults.standard.set(pro, forKey: "defaultPro")
      self.pro = pro
    }
}
