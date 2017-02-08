//
//  UploadViewController.swift
//  TodoPole
//
//  Created by Alberto Banet on 8/2/17.
//  Copyright © 2017 Alberto Banet. All rights reserved.
//

import UIKit
import SwiftForms
import KDCircularProgress



class UploadViewController: FormViewController {

    let picker: UIImagePickerController = {
        let p = UIImagePickerController()
        p.sourceType = .photoLibrary
        p.mediaTypes = UIImagePickerController.availableMediaTypes(for: .photoLibrary)!
        return p
    }()
    
    lazy var progress: KDCircularProgress = {
        let p = KDCircularProgress(frame: CGRect(x: 0, y: 0, width: 300, height: 300))
        p.startAngle = -90
        p.progressThickness = 0.2
        p.trackThickness = 0.6
        p.clockwise = true
        p.gradientRotateSpeed = 2
        p.roundedCorners = false
        p.glowMode = .forward
        p.glowAmount = 0.9
        p.set(colors: UIColor.cyan ,UIColor.white, UIColor.magenta, UIColor.white, UIColor.orange)
        p.center = CGPoint(x: self.view.center.x, y: self.view.center.y + 25)
        return p
    }()
    
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
        let section1 = FormSectionDescriptor(headerTitle: "Mandatory data", footerTitle: nil)
        
        var row = FormRowDescriptor(tag: "moveName", type: .asciiCapable, title: "Move name")
        section1.rows.append(row)
        
        row = FormRowDescriptor(tag: "email", type: .email , title: "Email")
        section1.rows.append(row)
        
        // Define second section
        let section2 = FormSectionDescriptor(headerTitle: "Optional data", footerTitle: nil)
        
        row = FormRowDescriptor(tag: "author", type: .name, title: "Your name")
        section2.rows.append(row)
        row = FormRowDescriptor(tag: "studio", type: .name, title: "Studio name")
        section2.rows.append(row)
        
        let section3 = FormSectionDescriptor(headerTitle: "Choose the video", footerTitle: nil)
        row = FormRowDescriptor(tag: "elegir", type: .button, title: "Tap to choose the video")
        row.configuration.button.didSelectClosure = { _ in
            self.present(self.picker, animated: true, completion: nil)
        }
        section3.rows.append(row)
        
        
        row = FormRowDescriptor(tag: "cancel", type: .button, title: "Cancel")
        row.configuration.button.didSelectClosure = { _ in
            self.dismiss(animated: true, completion: nil)
        }

        section3.rows.append(row)

        form.sections = [section1, section2, section3]

        self.form = form
    
    }
}

extension UploadViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        let urlVideo = info[UIImagePickerControllerMediaURL] as! URL
        let fire = Firebase()
        fire.delegate = self
        fire.uploadData(url: urlVideo)
        picker.dismiss(animated: true, completion: nil)
        
        view.addSubview(progress)
    }
}

extension UploadViewController: FirebaseProgress {
    func progressHappened(progress: Progress) {
        print(progress)
        self.progress.angle = progress.fractionCompleted * 360
    }
}


