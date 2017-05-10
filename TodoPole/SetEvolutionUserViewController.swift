//
//  SetEvolutionUserViewController.swift
//  TodoPole
//
//  Created by Alberto Banet Masa on 8/5/17.
//  Copyright © 2017 Alberto Banet. All rights reserved.
//

import UIKit
import SwiftForms


class SetEvolutionUserViewController: FormViewController {
  
  
  override func viewDidLoad() {
    super.viewDidLoad()
    view.backgroundColor = ColoresApp.primary.lighter(by: 15.0)
    self.loadForm()
  }
  
  fileprivate func loadForm(){
    let form = FormDescriptor(title: "Evolution user")
    let defaultConfiguration = DefaultConfiguration()
    
    // Section 1: Back button
    let section1 = FormSectionDescriptor(headerTitle: "Set the email you used to upload the videos", footerTitle: "")
    
    var row = FormRowDescriptor(tag: "email", type: .email , title: "Email")
    if let defaultMail = defaultConfiguration.evolutionMail, !defaultMail.isEmpty {
      row.configuration.cell.appearance = ["textField.text" : defaultMail as AnyObject, "textField.textAlignment" : NSTextAlignment.right.rawValue as AnyObject, "titleLabel.font": UIFont(name: "Avenir-Medium", size:15)!]
      row.value = defaultMail as AnyObject
    } else {
      row.configuration.cell.appearance = ["textField.placeholder" : "Write your email here" as AnyObject, "textField.textAlignment" : NSTextAlignment.right.rawValue as AnyObject, "titleLabel.font": UIFont(name: "Avenir-Medium", size:15)!]
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
    let values = self.form.formValues()
    let mail   = (values["email"] as? String) ?? ""
    
    
    let defaultConfiguration = DefaultConfiguration()
    defaultConfiguration.setDefaultEvolutionMail(mail: mail)
    
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
