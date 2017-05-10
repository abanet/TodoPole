//
//  SetFilterViewController.swift
//  TodoPole
//
//  Created by Alberto Banet on 18/3/17.
//  Copyright © 2017 Alberto Banet. All rights reserved.
//

import UIKit
import SwiftForms


class SetFilterViewController: FormViewController {

    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = ColoresApp.primary.lighter(by: 15.0)
        self.loadForm()
    }
    
    fileprivate func loadForm(){
        let form = FormDescriptor(title: "Autor filter")
        
        // TODO: Defaults settings let defaultConfiguration = DefaultConfiguration()
        
        // Define first section
        // Mandatory Data
        
//        let section1 = FormSectionDescriptor(headerTitle: "Nivel del autor", footerTitle: "")
//        var row = FormRowDescriptor(tag: "professional", type: .booleanSwitch, title: "Professional")
//        row.configuration.cell.appearance = ["titleLabel.font": UIFont(name: "Avenir-Medium", size:15)!]
//        section1.rows.append(row)
//        row = FormRowDescriptor(tag: "amateur", type: .booleanSwitch, title: "Amateur")
//        row.configuration.cell.appearance = ["titleLabel.font": UIFont(name: "Avenir-Medium", size:15)!]
//        section1.rows.append(row)
      
      
        // Section 1: Back button
        let section1 = FormSectionDescriptor(headerTitle: "", footerTitle: "")
        var row = FormRowDescriptor(tag: "back", type: .button, title: "Save & Back")
        row.configuration.cell.appearance = ["titleLabel.font": UIFont(name: "Avenir-Medium", size:18)!]
        
        row.configuration.button.didSelectClosure = { _ in
            self.back()
        }
        section1.rows.append(row)
      
      // Section 1.5: All pole dancers button
      let section15 = FormSectionDescriptor(headerTitle: "", footerTitle: "")
      row = FormRowDescriptor(tag: "allPoleDancers", type: .button, title: "Check all Pole Dancers")
      row.configuration.cell.appearance = ["titleLabel.font": UIFont(name: "Avenir-Medium", size:18)!]
      row.configuration.button.didSelectClosure = { _ in
        self.selectAllPoleDancers()
      }
      section15.rows.append(row)
      
      // Section 1.7: unselect all pole dancers button
      //let section17 = FormSectionDescriptor(headerTitle: "", footerTitle: "")
      row = FormRowDescriptor(tag: "nonePoleDancers", type: .button, title: "Uncheck all Pole Dancers")
      row.configuration.cell.appearance = ["titleLabel.font": UIFont(name: "Avenir-Medium", size:18)!]
      row.configuration.button.didSelectClosure = { _ in
        self.unselectAllPoleDancers()
      }
      section15.rows.append(row)
      
        // Section 2: Pole Dancer filter
        let section2 = FormSectionDescriptor(headerTitle: "Which Pole Dancers are you interested in?", footerTitle: "")
        let autores = ParseData.sharedInstance.listOfAuthorsNow()
        let autoresBloqueados = ConfigurationAutores.getAutoresBloqueados()
        for autor in autores {
            row = FormRowDescriptor(tag: "\(autor)", type: .booleanCheck, title: autor)
            if let listaAutoresBloqueados = autoresBloqueados {
                if listaAutoresBloqueados.contains(autor) {
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
        ConfigurationAutores.setAutoresBloqueados(autores: noSeleccionados)
        NotificationCenter.default.post(name:
        NSNotification.Name(rawValue: dictionaryCellNeedRefreshNotification), object: nil)
        self.dismiss(animated: true, completion: nil)
      

    }
  
  func selectAllPoleDancers() {
    for section in self.form.sections {
      for row in section.rows {
        if row.type != .button {
          row.value = true as AnyObject
        }
      }
    }
    self.tableView.reloadData()
  }
  
  func unselectAllPoleDancers() {
    for section in self.form.sections {
      for row in section.rows {
        if row.type != .button {
          row.value = false as AnyObject
        }
      }
    }
    self.tableView.reloadData()
  }
  
}
