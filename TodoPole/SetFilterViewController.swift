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
        let form = FormDescriptor(title: "Upload your video")
        
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
        
        let section1 = FormSectionDescriptor(headerTitle: "", footerTitle: "")
        var row = FormRowDescriptor(tag: "back", type: .button, title: "Back")
        row.configuration.cell.appearance = ["titleLabel.font": UIFont(name: "Avenir-Medium", size:18)!]
        
        row.configuration.button.didSelectClosure = { _ in
            self.back()
        }
        section1.rows.append(row)
        
        let section2 = FormSectionDescriptor(headerTitle: "Which authors are you interested in?", footerTitle: "")
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
        row = FormRowDescriptor(tag: "back", type: .button, title: "Back")
        row.configuration.cell.appearance = ["titleLabel.font": UIFont(name: "Avenir-Medium", size:18)!]
        row.configuration.button.didSelectClosure = { _ in
            self.back()
        }
        section3.rows.append(row)

        
        form.sections = [section1, section2, section3]
        
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
        self.dismiss(animated: true, completion: nil)
        NotificationCenter.default.post(name:
            NSNotification.Name(rawValue: dictionaryCellNeedRefreshNotification), object: nil)

    }
    
}
