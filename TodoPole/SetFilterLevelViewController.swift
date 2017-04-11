//
//  SetFilterLevelViewController.swift
//  TodoPole
//
//  Created by Alberto Banet Masa on 5/4/17.
//  Copyright © 2017 Alberto Banet. All rights reserved.
//

import UIKit
import SwiftForms


class SetFilterLevelViewController: FormViewController {
  
  
  override func viewDidLoad() {
    super.viewDidLoad()
    view.backgroundColor = ColoresApp.primary.lighter(by: 15.0)
    self.loadForm()
  }
  
  fileprivate func loadForm(){
    let form = FormDescriptor(title: "Level filter")
    
    // Section 1: Back button
    let section1 = FormSectionDescriptor(headerTitle: "", footerTitle: "")
    var row = FormRowDescriptor(tag: "back", type: .button, title: "Save & Back")
    row.configuration.cell.appearance = ["titleLabel.font": UIFont(name: "Avenir-Medium", size:18)!]
    
    row.configuration.button.didSelectClosure = { _ in
      self.back()
    }
    section1.rows.append(row)
    
    // Section 1.5: All levels button
    let section15 = FormSectionDescriptor(headerTitle: "", footerTitle: "")
    row = FormRowDescriptor(tag: "allLevels", type: .button, title: "All levels")
    row.configuration.cell.appearance = ["titleLabel.font": UIFont(name: "Avenir-Medium", size:18)!]
    
    row.configuration.button.didSelectClosure = { _ in
      self.selectAllLevels()
    }
    section15.rows.append(row)
    
    // Section 2: Level filter
    let section2 = FormSectionDescriptor(headerTitle: "Which levels are you interested in?", footerTitle: "")
    let nivelesBloqueados = ConfigurationNiveles.getNivelesBloqueados()
    for level in 1...ConfigurationNiveles.maxNivel {
      row = FormRowDescriptor(tag: "\(level)", type: .booleanCheck, title: "Level \(level)")
      
      if let listaNivelesBloqueados = nivelesBloqueados {
        if listaNivelesBloqueados.contains(String(level)) {
          row.value = false as AnyObject
        } else {
          row.value = true as AnyObject
        }
      } else {
        row.value = true as AnyObject
      }
      section2.rows.append(row)
    }
    
    let section3 = FormSectionDescriptor(headerTitle: "", footerTitle: "")
    row = FormRowDescriptor(tag: "back", type: .button, title: "Save & Back")
    row.configuration.cell.appearance = ["titleLabel.font": UIFont(name: "Avenir-Medium", size:18)!]
    row.configuration.button.didSelectClosure = { _ in
      self.back()
    }
    section3.rows.append(row)
    
    
    form.sections = [section1, section15, section2, section3]
    
    self.form = form
    
  }
  
  func back() {
    let values = self.form.formValues() as! [String:Bool]
    var noSeleccionados = [String]()
    for (nombre, checked) in values {
      if !checked {
        noSeleccionados.append(nombre)
      }
    }
    ConfigurationNiveles.setNivelesBloqueados(autores: noSeleccionados)
    self.dismiss(animated: true, completion: nil)
    NotificationCenter.default.post(name:
      NSNotification.Name(rawValue: dictionaryCellNeedRefreshNotification), object: nil)
    
  }
  
  func selectAllLevels() {
    for section in self.form.sections {
      for row in section.rows {
        if row.type != .button {
            row.value = true as AnyObject 
        }
      }
    }
    self.tableView.reloadData()
  }
  
}
