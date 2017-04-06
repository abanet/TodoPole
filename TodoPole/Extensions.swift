//
//  Extensions.swift
//  TodoPole
//
//  Created by Alberto Banet on 5/12/16.
//  Copyright © 2016 Alberto Banet. All rights reserved.
//

import UIKit
import Parse

extension UIView {
    func addConstraintsWithFormat(format: String, views: UIView...) {
        var viewsDictionary = [String:UIView]()
        for (index, view) in views.enumerated() {
            let key = "v\(index)"
            view.translatesAutoresizingMaskIntoConstraints = false
            viewsDictionary[key] = view
        }
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: format, options: NSLayoutFormatOptions(), metrics: nil, views: viewsDictionary))
    }
}



let imageCache = NSCache<NSString, UIImage>()
class CustomImageView: UIImageView {
    
    var imageUrlString: String?
    var pffileFoto: PFFile?
    
    func loadImageUsingUrlString(urlString: String) {
        imageUrlString = urlString
        
        let url = URL(string: urlString)
        
        image = nil
        
        if let imageFromCache = imageCache.object(forKey: urlString as NSString) {
            self.image = imageFromCache
            return
        }
        URLSession.shared.dataTask(with: url!) {
            (data, response, error) in
            
            if error != nil {
                print(error!); return
            }
            DispatchQueue.main.async {
                let imageToCache = UIImage(data:data!)
                
                if self.imageUrlString == urlString {
                    self.image = imageToCache
                }
                
                imageCache.setObject(imageToCache!, forKey: urlString as NSString)
                self.image = imageToCache
            }
            
            }.resume()
    }
    
    func loadImageUsingPFFile(fileFoto: PFFile?, completion:@escaping ()->Void) {
        if let ficheroOriginal = fileFoto {
            pffileFoto = ficheroOriginal
            image = nil
            
            ficheroOriginal.getDataInBackground {
                (imageData: Data?, error: Error?) -> Void in
                if error == nil {
                    DispatchQueue.main.async {
                        if self.pffileFoto == ficheroOriginal {
                            if let imageData = imageData {
                              if let img = UIImage(data:imageData) {
                                self.image = self.imageWithGradient(img: img)
                                completion()
                              }
                            }
                        }
                        
                    }
                }
            }
        }
    }
    
    func imageWithGradient(img:UIImage!) -> UIImage {
        
        // Oscurecemos la parte de abajo
        UIGraphicsBeginImageContext(img.size)
        let context = UIGraphicsGetCurrentContext()
        
        img.draw(at: CGPoint(x: 0, y: 0))
        
        let colorSpace = CGColorSpaceCreateDeviceRGB()
        let locations:[CGFloat] = [0.7, 1.0]
        
        let bottom = UIColor(red: 0, green: 0, blue: 0, alpha: 0.5).cgColor
        let top = UIColor(red: 0, green: 0, blue: 0, alpha: 0).cgColor
        
        let colors = [top, bottom] as CFArray
        
        let gradient = CGGradient(colorsSpace: colorSpace, colors: colors, locations: locations)
        
        let startPoint = CGPoint(x: img.size.width/2, y: 0)
        let endPoint = CGPoint(x: img.size.width/2, y: img.size.height)
        
        // Aplicamos gradiente para la parte inferior
        context!.drawLinearGradient(gradient!, start: startPoint, end: endPoint, options: CGGradientDrawingOptions(rawValue: UInt32(0)))
        
        // Aplicamos gradiente para la parte superior
        context!.drawLinearGradient(gradient!, start: endPoint, end: startPoint, options: CGGradientDrawingOptions(rawValue: UInt32(0)))
        
        let image = UIGraphicsGetImageFromCurrentImageContext()
        
        UIGraphicsEndImageContext()
        
        
        return image!
    }
    
}
