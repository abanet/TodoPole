//
//  setOrderViewController.swift
//  TodoPole
//
//  Created by Alberto Banet Masa on 6/4/17.
//  Copyright © 2017 Alberto Banet. All rights reserved.
//

import UIKit
import SwiftForms


class SetOrderViewController: FormViewController {
  
  
  override func viewDidLoad() {
    super.viewDidLoad()
    view.backgroundColor = ColoresApp.primary.lighter(by: 15.0)
    self.loadForm()
  }
  
  fileprivate func loadForm(){
    let form = FormDescriptor(title: "Order by")
    
    // Section 1: Back button
    let section1 = FormSectionDescriptor(headerTitle: "Which order do you prefer?", footerTitle: "")
    
    let orden = ConfigurationOrden.getOrden()
    
    var row = FormRowDescriptor(tag: "last", type: .booleanCheck, title: "Last viewed first")
    if let ordenacion = orden, ordenacion == OrdenType.lastViewed.rawValue {
      row.value = true as AnyObject
    }
    row.configuration.cell.appearance = ["titleLabel.font": UIFont(name: "Avenir-Medium", size:18)!]
    row.configuration.button.didSelectClosure = { _ in
      self.selectRow(tag: "last")
      
    }
    section1.rows.append(row)

    row = FormRowDescriptor(tag: "date", type: .booleanCheck, title: "Created date")
    if let ordenacion = orden, ordenacion == OrdenType.createdDate.rawValue {
      row.value = true as AnyObject
    }
    row.configuration.cell.appearance = ["titleLabel.font": UIFont(name: "Avenir-Medium", size:18)!]
    row.configuration.button.didSelectClosure = { _ in
      self.selectRow(tag: "date")
      
    }
    section1.rows.append(row)
    row = FormRowDescriptor(tag: "likes", type: .booleanCheck, title: "Likes")
    if let ordenacion = orden, ordenacion == OrdenType.likes.rawValue {
      row.value = true as AnyObject
    }
    row.configuration.cell.appearance = ["titleLabel.font": UIFont(name: "Avenir-Medium", size:18)!]
    row.configuration.button.didSelectClosure = { _ in
      self.selectRow(tag: "likes")
      
    }
    section1.rows.append(row)
    
  
    
    
    
    let section2 = FormSectionDescriptor(headerTitle: "", footerTitle: "")
    row = FormRowDescriptor(tag: "back", type: .button, title: "Save & Back")
    row.configuration.cell.appearance = ["titleLabel.font": UIFont(name: "Avenir-Medium", size:18)!]
    row.configuration.button.didSelectClosure = { _ in
      self.back()
    }
    section2.rows.append(row)
    
    
    form.sections = [section1, section2]
    
    self.form = form
    
  }
  
  // TODO: grabar el orden al salir y aplicar en las búsquedas.
  func back() {
    let values = self.form.formValues() as! [String:Bool]
    for (nombre, checked) in values {
      if checked {
        switch nombre {
        case "last":
          ConfigurationOrden.setOrden(OrdenType.lastViewed)
        case "date":
          ConfigurationOrden.setOrden(OrdenType.createdDate)
        case "likes":
          ConfigurationOrden.setOrden(OrdenType.likes)
        default:
          ConfigurationOrden.setOrden(OrdenType.lastViewed)
        }
      }
    }
    self.dismiss(animated: true, completion: nil)
    NotificationCenter.default.post(name:
      NSNotification.Name(rawValue: dictionaryCellNeedRefreshNotification), object: nil)
    
  }
  
  
  
  func selectRow(tag: String) {
    for section in self.form.sections {
      for row in section.rows {
        if row.type == .booleanCheck {
          if row.tag != tag {
            row.value = false as AnyObject
          }
        }
      }
    }
    self.tableView.reloadData()
  }
  
  
}
