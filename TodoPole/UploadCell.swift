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
    
    lazy var txtNombreVideo: UITextField = {
        let txt = UITextField(frame: CGRect(x: 0, y: 0, width: 200, height: 50))
        txt.keyboardType = .asciiCapable
        txt.attributedPlaceholder = NSAttributedString(string: "The move's name", attributes: [NSForegroundColorAttributeName: UIColor.lightGray])
        txt.translatesAutoresizingMaskIntoConstraints = false
        txt.textColor = ColoresApp.darkPrimary
        txt.borderStyle = .roundedRect
        txt.clearsOnBeginEditing = true
        txt.delegate = self
       
        return txt
    }()
    
    lazy var txtMailAutor: UITextField = {
        let txt = UITextField(frame: CGRect(x: 0, y: 0, width: 200, height: 50))
        txt.keyboardType = .emailAddress
        txt.attributedPlaceholder = NSAttributedString(string: "Your mail", attributes: [NSForegroundColorAttributeName: UIColor.lightGray])
        txt.translatesAutoresizingMaskIntoConstraints = false
        txt.textColor = ColoresApp.darkPrimary
        txt.borderStyle = .roundedRect
        txt.clearsOnBeginEditing = true
        txt.delegate = self
        return txt
    }()
    
    lazy var txtNombreAutor: UITextField = {
        let txt = UITextField(frame: CGRect(x: 0, y: 0, width: 200, height: 50))
        txt.keyboardType = .asciiCapable
        txt.attributedPlaceholder = NSAttributedString(string: "Your name (optional)", attributes: [NSForegroundColorAttributeName: UIColor.lightGray])
        txt.translatesAutoresizingMaskIntoConstraints = false
        txt.textColor = ColoresApp.darkPrimary
        txt.borderStyle = .roundedRect
        txt.clearsOnBeginEditing = true
        txt.delegate = self
        return txt
    }()
    
    lazy var txtNombreEscuela: UITextField = {
        let txt = UITextField(frame: CGRect(x: 0, y: 0, width: 200, height: 50))
        txt.keyboardType = .asciiCapable
        txt.attributedPlaceholder = NSAttributedString(string: "Your studio name (optional)", attributes: [NSForegroundColorAttributeName: UIColor.lightGray])
        txt.translatesAutoresizingMaskIntoConstraints = false
        txt.textColor = ColoresApp.darkPrimary
        txt.borderStyle = .roundedRect
        txt.clearsOnBeginEditing = true
        txt.delegate = self
        return txt
    }()
    
    var scrollView: UIScrollView = {
        let v = UIScrollView()
        v.translatesAutoresizingMaskIntoConstraints = false
        v.backgroundColor = .blue
        return v
    }()
    
    var viewBackground: UIView = {
        let v = UIView()
        v.translatesAutoresizingMaskIntoConstraints = false
        v.backgroundColor = .red
        return v
    }()
    
    let btnOpenPicker: UIButton = {
        let btn = UIButton(type: .contactAdd)
        btn.translatesAutoresizingMaskIntoConstraints = false
        return btn
    }()
    
    var heightConstraint = NSLayoutConstraint()
    
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
        
        self.contentView.addSubview(scrollView)
        scrollView.contentSize = CGSize(width: 200, height: 600)
        scrollView.addSubview(btnOpenPicker)
        scrollView.addSubview(viewBackground)
        
        scrollView.addSubview(txtNombreVideo)
        scrollView.addSubview(txtMailAutor)
        scrollView.addSubview(txtNombreAutor)
        scrollView.addSubview(txtNombreEscuela)
        
        
        addConstraintsWithFormat(format: "H:|[v0]|", views: scrollView)
        addConstraintsWithFormat(format: "V:|[v0]|", views: scrollView)
       addConstraintsWithFormat(format: "H:|[v0]|", views: viewBackground)
       addConstraintsWithFormat(format: "V:|[v0]|", views: viewBackground)
        btnOpenPicker.centerXAnchor.constraint(equalTo: viewBackground.centerXAnchor).isActive = true
        btnOpenPicker.centerYAnchor.constraint(equalTo: viewBackground.centerYAnchor).isActive = true
        
        // Colocación de los campos de texto
        addConstraintsWithFormat(format: "H:|-[v0]-|", views: txtNombreVideo)
        addConstraintsWithFormat(format: "H:|-[v0]-|", views: txtMailAutor)
        addConstraintsWithFormat(format: "H:|-[v0]-|", views: txtNombreAutor)
        addConstraintsWithFormat(format: "H:|-[v0]-|", views: txtNombreEscuela)
        
        //let mitad = Int(self.frame.size.height / 2)
        addConstraintsWithFormat(format: "V:|-[v0]-[v1]-[v2]-[v3]", views: txtNombreVideo, txtMailAutor, txtNombreAutor, txtNombreEscuela)
        
        txtNombreVideo.heightAnchor.constraint(equalToConstant: 25).isActive = true
        txtMailAutor.heightAnchor.constraint(equalToConstant: 25).isActive = true
        txtNombreAutor.heightAnchor.constraint(equalToConstant: 25).isActive = true
        txtNombreEscuela.heightAnchor.constraint(equalToConstant: 25).isActive = true
        
        // Observación de las notificaciones del teclado
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
        
        // Tap para esconder el teclado
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(hideKeyboard))
        self.addGestureRecognizer(tapGesture)
    }
    
    @objc private func keyboardWillShow(notification: Notification){
        print("showing keyboard: \(self.frame.origin.y)")
        let userInfo:Dictionary = notification.userInfo!
        let keyboardFrame:NSValue = userInfo[UIKeyboardFrameEndUserInfoKey] as! NSValue
        let keyboardRectangle = keyboardFrame.cgRectValue
        let keyboardHeight = keyboardRectangle.height
        print("Altura del teclado mostrado: \(keyboardHeight)")
        viewBackground.layoutMargins = UIEdgeInsetsMake(keyboardHeight / 2, 0, 0, 0)
        
        
    }
    
    @objc private func keyboardWillHide(notification: Notification){
        print("hidding keyboard \(self.frame.origin.y)")
        viewBackground.layoutMargins = UIEdgeInsetsMake(0, 0, 0, 0)
        
       
    }

    @objc private func hideKeyboard(){
        self.endEditing(true)
        print("hideKeyboard \(self.frame.origin.y)")
        self.setNeedsDisplay()
    }
    
    override func willRemoveSubview(_ subview: UIView) {
        print("----- Se va a mover")
        print(".......")
    }
    
    
}

extension UploadCell: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        let urlVideo = info[UIImagePickerControllerMediaURL] as! URL
        let fire = Firebase()
        fire.delegate = self
        fire.uploadData(url: urlVideo)
        picker.dismiss(animated: true, completion: nil)
    }
}

extension UploadCell: FirebaseProgress {
    func progressHappened(progress: Progress) {
        print(progress)
    }
}

extension UploadCell: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        for textField in self.subviews where textField is UITextField {
            textField.resignFirstResponder()
        }
        return true
        
    }
}
