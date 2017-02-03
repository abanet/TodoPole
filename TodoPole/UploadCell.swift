//
//  UploadCell.swift
//  TodoPole
//
//  Created by Alberto Banet on 3/2/17.
//  Copyright © 2017 Alberto Banet. All rights reserved.
//

import UIKit

class UploadCell: BaseCell {
 
    let picker: UIImagePickerController = {
        let p = UIImagePickerController()
        return p
    }()
    
    
    override func setupViews() {
        // setup de las vistas
        picker.delegate = self
        
    }
}

extension UploadCell: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        print ("subiendo video")
    }
}
