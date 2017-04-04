//
//  VideoCell.swift
//  TodoPole
//
//  Created by Alberto Banet on 5/12/16.
//  Copyright © 2016 Alberto Banet. All rights reserved.
//

import UIKit
import Parse



class FiguraCell: BaseCell {
   
    var figura: Figura? {
        didSet {
            setupImagenFigura()
        }
    }
   

    let thumbnailImageView: CustomImageView = {
        let imageView = CustomImageView()
        imageView.backgroundColor = ColoresApp.lightPrimary
        imageView.contentMode = .scaleAspectFill
        imageView.layer.cornerRadius = 5
        imageView.layer.masksToBounds = true
        imageView.clipsToBounds = true
        return imageView
    }()
    
    let autorLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "Avenir-Medium", size:15)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Ciro Esposito"
        label.textColor = UIColor.white //ColoresApp.primaryText
        return label
    }()
    
    let nombreEscuelaLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "Avenir-Light", size: 13)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Escuela de Pole Dance"
        label.textColor = UIColor.white
        return label
    }()
    
    let provinciaPaisLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "Avenir-Light", size: 12)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = UIColor.white
        label.text = "provincia - país"
        return label
    }()
    
    
    let nombreLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "Avenir-Medium", size:15)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Bombero loco"
        label.textColor = UIColor.white //ColoresApp.primaryText
        label.adjustsFontSizeToFitWidth = true
        return label
    }()
    
    let nivelLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "Avenir-Medium", size:12)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Level 1"
        label.textColor = UIColor.white //ColoresApp.primaryText
        return label
    }()
    
    let likesLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "Avenir-Medium", size: 12)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "0 likes"
        label.textColor = .white
        return label
    }()
    
    let tipoLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "Avenir-Medium", size:12)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Giro"
        label.textColor = UIColor.white //ColoresApp.primaryText
        return label
    }()
  
    
    
    override func setupViews() {
        addSubview(thumbnailImageView)
        //  Gradientes superior e inferior
        //setupGradientLayer()
        
        addSubview(autorLabel)
        addSubview(nombreLabel)
        // addSubview(tipoLabel) // Por ahora no ponemos el tipo
        addSubview(nivelLabel)
        addSubview(likesLabel)
        addSubview(nombreEscuelaLabel)
        addSubview(provinciaPaisLabel)
        
        //  Imagen de la figura. Ocupa todo el fondo de la celda
        
        addConstraintsWithFormat(format: "V:|[v0]|", views: thumbnailImageView)
        addConstraintsWithFormat(format: "H:|[v0]|", views: thumbnailImageView)

        
        //  Nombre del autor
        let margins = self.layoutMarginsGuide
        autorLabel.trailingAnchor.constraint(equalTo: margins.trailingAnchor).isActive = true
        addConstraint(NSLayoutConstraint(item: autorLabel, attribute: .top, relatedBy: .equal, toItem: self, attribute: .top, multiplier: 1, constant: 8))
        
        //  Nombre de la escuela
        nombreEscuelaLabel.trailingAnchor.constraint(equalTo: margins.trailingAnchor).isActive = true
        addConstraint(NSLayoutConstraint(item: nombreEscuelaLabel, attribute: .top, relatedBy: .equal, toItem: autorLabel, attribute: .firstBaseline, multiplier: 1, constant: 0))
        
        //  Provincia y País
        provinciaPaisLabel.trailingAnchor.constraint(equalTo: margins.trailingAnchor).isActive = true
        addConstraint(NSLayoutConstraint(item: provinciaPaisLabel, attribute: .top, relatedBy: .equal, toItem: nombreEscuelaLabel, attribute: .firstBaseline, multiplier: 1.0, constant: 0))
        
        //  Nombre de la figura
        nombreLabel.leadingAnchor.constraint(equalTo: margins.leadingAnchor).isActive = true
        nombreLabel.trailingAnchor.constraint(equalTo: margins.trailingAnchor).isActive = true
        addConstraint(NSLayoutConstraint(item: nombreLabel, attribute: .bottom, relatedBy: .equal, toItem: self, attribute: .bottom, multiplier:1, constant: 0))
        
        // tipo de figura
        // tipoLabel.leadingAnchor.constraint(equalTo: nombreLabel.leadingAnchor).isActive = true
        //addConstraint(NSLayoutConstraint(item: tipoLabel, attribute: .bottom, relatedBy: .equal, toItem: nombreLabel, attribute: .top, multiplier:1, constant: 0))
        
        //  número de likes
        likesLabel.leadingAnchor.constraint(equalTo: nombreLabel.leadingAnchor).isActive = true
        addConstraint(NSLayoutConstraint(item: likesLabel, attribute: .bottom, relatedBy: .equal, toItem: nombreLabel, attribute: .top, multiplier: 1, constant: 4))
        
        //  nivel de la figura
        nivelLabel.leadingAnchor.constraint(equalTo: nombreLabel.leadingAnchor).isActive = true
        addConstraint(NSLayoutConstraint(item: nivelLabel, attribute: .bottom, relatedBy: .equal, toItem: likesLabel, attribute: .top, multiplier: 1, constant: 4))
  
    }
    
    // Establecemos un gradiente en la parte inferior de la fotografía para que se vea mejor la información que pondemos.
    private func setupGradientLayer(){
        let gradienteInferior = CAGradientLayer()
        let gradienteSuperior = CAGradientLayer()
        gradienteInferior.frame = self.bounds
        gradienteSuperior.frame = self.bounds
        gradienteInferior.colors = [UIColor.clear.cgColor, ColoresApp.lightPrimary.cgColor]
        gradienteSuperior.colors = [ColoresApp.lightPrimary.cgColor, UIColor.clear.cgColor]

        gradienteInferior.locations = [0.8, 1.0]
        gradienteSuperior.locations = [0.0, 0.3]
        
        self.layer.addSublayer(gradienteInferior)
        self.layer.addSublayer(gradienteSuperior)
        self.layer.cornerRadius = 5
        self.layer.masksToBounds = true
        
    }
    
    
    func setupTextosFigura(){
        autorLabel.text  =  figura?.autor ?? ""
        nombreLabel.text =  figura?.englishName ?? "" // De momento todo en inglés.
        tipoLabel.text   =  figura?.tipo ?? ""
      
      // Si es profesional mostramos el nivel. Si es amateur la fecha de subida.
      let esProfesional = figura?.profesional
      if esProfesional != nil, esProfesional!  {
        if let nivel = figura?.nivel {
            nivelLabel.text  =  "Level \(nivel)"
        } else {
            nivelLabel.text  = ""
        }
      } else {
          let date = (figura?.createdAt)!
          nivelLabel.text = date.timeAgoDisplay() //dateToString(date: date)
      }
        if let likes = figura?.likes {
            likesLabel.text = "\(likes) likes"
        } else {
            likesLabel.text = "0 likes"
        }
        
        nombreEscuelaLabel.text = figura?.escuela?.nombre ?? ""
        
        // rellenamos la pronvincia y el país
        let provincia = figura?.escuela?.provincia
        //let pais      = figura?.escuela?.pais
        // De momento como sólo hay de España quitamos el pais. En un futuro [provincia, pais].flatMap...
        provinciaPaisLabel.text = [provincia].flatMap{$0}.joined(separator: " - ")
    }
    
    func resetearTextosCelda(){
        self.autorLabel.text = ""
        self.nivelLabel.text = ""
        self.nombreLabel.text = ""
        self.tipoLabel.text = ""
        self.nombreEscuelaLabel.text = ""
        self.provinciaPaisLabel.text = ""
        self.likesLabel.text = ""
    }
    
    func setupImagenFigura() {
        // actualizar la imagen de la figura
        thumbnailImageView.loadImageUsingPFFile(fileFoto: figura?.fileFoto){
            self.setupTextosFigura()
        }
    }
    
  func dateToString(date: Date) -> String {
    let formatter = DateFormatter()
    formatter.dateStyle = .long
    formatter.timeStyle = .none
    return formatter.string(from: date)
  }
}
