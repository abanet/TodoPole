//
//  ViewController.swift
//  TodoPole
//
//  Created by Alberto Banet on 25/11/16.
//  Copyright © 2016 Alberto Banet. All rights reserved.
//

import UIKit

struct ColoresApp {
    static let darkPrimary = UIColor(red: 36/255, green: 122/255, blue: 107/255, alpha: 1)
    static let primary = UIColor(red: 47/255, green: 151/255, blue: 136/255, alpha: 1)
    static let lightPrimary = UIColor(red: 183/255, green: 224/255, blue: 219/255, alpha: 1)
    static let accent = UIColor(red: 248/255, green: 196/255, blue: 49/255, alpha: 1)
    static let primaryText = UIColor(red: 33/255, green: 33/255, blue: 33/255, alpha: 1)
    static let secondaryText = UIColor(red: 117/255, green: 117/255, blue: 117/255, alpha: 1)
    static let divider = UIColor(red: 189/255, green: 189/255, blue: 189/255, alpha: 1)
}
class HomeController: UICollectionViewController, UICollectionViewDelegateFlowLayout {

    
    override func viewDidLoad() {
        super.viewDidLoad()
       
        // Configuración del navigation
        let titulo = UILabel(frame: CGRect(x: 0, y: 0, width: view.frame.width - 2 * view.layoutMargins.left, height: view.frame.height))
        titulo.text = "Pole Dictionary"
        titulo.font = UIFont.systemFont(ofSize: 20)
        titulo.textColor = ColoresApp.primaryText
        
        navigationItem.titleView = titulo
        navigationController?.navigationBar.isTranslucent = false
       
        //Configuración del collectionView
        collectionView?.backgroundColor = ColoresApp.lightPrimary
        
        collectionView?.register(VideoCell.self, forCellWithReuseIdentifier: "cellId")
    }

   
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 5
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cellId", for: indexPath)
        
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let margin = view.layoutMargins
        let  heigth = 9 / 16 * (view.frame.width - margin.left - margin.right) + margin.top + 2 * margin.bottom + 68
        return CGSize(width: view.frame.width, height: heigth)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
}

