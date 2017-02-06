//
//  UploadCell.swift
//  TodoPole
//
//  Created by Alberto Banet on 3/2/17.
//  Copyright © 2017 Alberto Banet. All rights reserved.
//

import UIKit
import Foundation



class UploadCell: BaseCell {
 
    let picker: UIImagePickerController = {
        let p = UIImagePickerController()
        p.sourceType = .photoLibrary
        p.mediaTypes = UIImagePickerController.availableMediaTypes(for: .photoLibrary)!
        return p
    }()
    
    let viewBackground: UIView = {
        let v = UIView()
        v.backgroundColor = .red
        return v
    }()
    
    let btnOpenPicker: UIButton = {
        let btn = UIButton(type: .contactAdd)
        btn.translatesAutoresizingMaskIntoConstraints = false
        return btn
    }()
    
    func openPicker() {
        print("Abriendo picker")
        if let controller = UIApplication.topViewController() {
            controller.present(picker, animated: true, completion: nil)
        }
    }
    
    override func setupViews() {
        // setup de las vistas
        picker.delegate = self
        btnOpenPicker.addTarget(self, action: #selector(openPicker), for: .touchDown)
        
        addSubview(viewBackground)
        addSubview(btnOpenPicker)
        
        addConstraintsWithFormat(format: "H:|[v0]|", views: viewBackground)
        addConstraintsWithFormat(format: "V:|[v0]|", views: viewBackground)
        btnOpenPicker.centerXAnchor.constraint(equalTo: viewBackground.centerXAnchor).isActive = true
        btnOpenPicker.centerYAnchor.constraint(equalTo: viewBackground.centerYAnchor).isActive = true
    }

}

extension UploadCell: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        let urlVideo = info[UIImagePickerControllerMediaURL] as! URL
        let fire = Firebase()
        fire.uploadData(url: urlVideo)
        picker.dismiss(animated: true, completion: nil)
    }
}
