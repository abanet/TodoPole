//
//  UploadViewController.swift
//  TodoPole
//
//  Created by Alberto Banet on 8/2/17.
//  Copyright © 2017 Alberto Banet. All rights reserved.
//

import UIKit
import SwiftForms
import MobileCoreServices



class UploadViewController: FormViewController {

    let picker: UIImagePickerController = {
        let p = UIImagePickerController()
        p.sourceType = .photoLibrary
        p.mediaTypes = [kUTTypeMovie as String]//UIImagePickerController.availableMediaTypes(for: .photoLibrary)!
        return p
    }()
    
    var progress: ProgressViewController = {
       let p = ProgressViewController()
       p.modalTransitionStyle = .crossDissolve
       return p
    }()
    
    var metadataFigura: FiguraFirebase?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = ColoresApp.primary
        picker.delegate = self
        self.loadForm()
    }

    fileprivate func loadForm(){
        let form = FormDescriptor(title: "Upload your video")
        
        
        // Define first section
        // Mandatory Data
        
        let section1 = FormSectionDescriptor(headerTitle: "   ", footerTitle: nil)
        var row = FormRowDescriptor(tag: "moveName", type: .asciiCapable, title: "Move Name")
        row.configuration.cell.appearance = ["textField.placeholder" : "Mandatory" as AnyObject, "textField.textAlignment" : NSTextAlignment.right.rawValue as AnyObject, "titleLabel.font": UIFont(name: "Avenir-Medium", size:15)!]
        section1.rows.append(row)
        row = FormRowDescriptor(tag: "email", type: .email , title: "Email")
        row.configuration.cell.appearance = ["textField.placeholder" : "Mandatory" as AnyObject, "textField.textAlignment" : NSTextAlignment.right.rawValue as AnyObject, "titleLabel.font": UIFont(name: "Avenir-Medium", size:15)!]
        section1.rows.append(row)
        
        // Define second section
        // Optional data
        let section2 = FormSectionDescriptor(headerTitle: "", footerTitle: nil)
        row = FormRowDescriptor(tag: "author", type: .name, title: "Your name")
        row.configuration.cell.appearance = ["textField.placeholder" : "Optional" as AnyObject, "textField.textAlignment" : NSTextAlignment.right.rawValue as AnyObject, "titleLabel.font": UIFont(name: "Avenir-Medium", size:15)!]
        section2.rows.append(row)
        row = FormRowDescriptor(tag: "studio", type: .name, title: "Studio name")
        row.configuration.cell.appearance = ["textField.placeholder" : "Optional" as AnyObject, "textField.textAlignment" : NSTextAlignment.right.rawValue as AnyObject, "titleLabel.font": UIFont(name: "Avenir-Medium", size:15)!]
        
        section2.rows.append(row)
        
        // Define third section
        // Buttons to upload and cancel
        let section3 = FormSectionDescriptor(headerTitle: "", footerTitle: nil)
        row = FormRowDescriptor(tag: "elegir", type: .button, title: "Tap to choose the video")
        row.configuration.cell.appearance = ["titleLabel.font": UIFont(name: "Avenir-Medium", size:18)!]
        row.configuration.button.didSelectClosure = { _ in
            if self.checkMandatoryFieldsNotEmpty() {
                self.present(self.picker, animated: true, completion: nil)
            }
        }
        section3.rows.append(row)
        
        let section4 = FormSectionDescriptor(headerTitle: "", footerTitle: "")
        row = FormRowDescriptor(tag: "back", type: .button, title: "Back")
        row.configuration.cell.appearance = ["titleLabel.font": UIFont(name: "Avenir-Medium", size:18)!]

        row.configuration.button.didSelectClosure = { _ in
            self.dismiss(animated: true, completion: nil)
        }
        section4.rows.append(row)
        
    

        form.sections = [section1, section2, section3, section4]

        self.form = form
    
    }
    
    private func checkMandatoryFieldsNotEmpty() -> Bool {
        let valores = self.form.formValues()
        let moveName = (valores["moveName"] as? String) ?? ""
        let mail     = (valores["email"] as? String) ?? ""
        let autor    = (valores["author"] as? String) ?? ""
        let studio   = (valores["studio"] as? String) ?? ""
        
        if moveName.trimmingCharacters(in: CharacterSet.whitespaces).isEmpty {
            showAlert(title:"Move Name is empty", message: "Please tell us the name of the move you'are uploading!")
            return false
        }
        
        if mail.isEmpty {
            showAlert(title: "Mail is empty", message: "Please tell us your email in order to ask you permission before publishing!")
            return false
        }
        
        if !mail.isValidEmailAddress {
            showAlert(title: "Invalid Mail", message: "Please, I need a valid Email address")
            return false
        }
        
        // todos los datos están correctos. Cargamos los metadatos
        metadataFigura = FiguraFirebase(nombre: moveName, mail: mail, autor: autor, studio: studio)
        
        return true
    }
    
    func captureScreen()-> UIImage? {
        UIGraphicsBeginImageContextWithOptions(self.view.bounds.size, true, 1)
        self.view.drawHierarchy(in: self.view.bounds, afterScreenUpdates: true)
        let screenshot = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return screenshot
    }
    
    func showAlert(title: String, message: String){
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let cancel = UIAlertAction(title: "OK", style: .cancel) { (action) in
        }
        alertController.addAction(cancel)
        self.present(alertController, animated: true, completion: nil)
    }
}

extension UploadViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        let urlVideo = info[UIImagePickerControllerMediaURL] as! URL
        let fire = Firebase()
        fire.delegate = progress
        fire.uploadData(url: urlVideo)
        fire.metadataFigura = metadataFigura
        picker.dismiss(animated: true, completion: nil)
        progress.fireUploadTask = fire
        progress.imageForBlur = captureScreen()
        present(progress, animated: true, completion: nil)
    }
}

extension String {
  var isValidEmailAddress: Bool {
  let types: NSTextCheckingResult.CheckingType = [.link]
  let linkDetector = try? NSDataDetector(types: types.rawValue)
  let range = NSRange(location: 0, length: self.characters.count)
  let result = linkDetector?.firstMatch(in: self, options: .reportCompletion, range: range)
  let scheme = result?.url?.scheme ?? ""
  return scheme == "mailto" && result?.range.length == self.characters.count
    }
}


