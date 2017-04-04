//
//  FeedCell.swift
//  TodoPole
//
//  Created by Alberto Banet on 21/12/16.
//  Copyright © 2016 Alberto Banet. All rights reserved.
//

import UIKit

class FeedCell: BaseCell, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {

    var refresh: UIRefreshControl = {
        let r = UIRefreshControl()
        r.tintColor = .white
        let atributosString = [NSForegroundColorAttributeName: UIColor.white, NSFontAttributeName: UIFont(name: "Avenir-medium", size: 17.0)]
        r.attributedTitle = NSAttributedString(string: "Getting the newest data!", attributes: atributosString)
        return r
    }()
    
    lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.delegate = self
        cv.dataSource = self
        cv.contentInset = UIEdgeInsets(top: 0, left: 4 ,bottom: 0 ,right: 4)
        cv.backgroundColor = ColoresApp.lightPrimary
        if #available(iOS 10.0, *){
            cv.refreshControl = self.refresh
            self.refresh.addTarget(self, action: #selector(refreshData), for: .valueChanged)
        } else {
            cv.addSubview(self.refresh)
        }
        return cv
    }()
    
    var figuras: [Figura]?
    
    let cellId = "cellId"
    
    override func setupViews() {
        super.setupViews()
        
        cargarFigurasDeParse(red: false)
        
        addSubview(collectionView)
        addConstraintsWithFormat(format: "H:|[v0]|", views: collectionView)
        addConstraintsWithFormat(format: "V:|[v0]|", views: collectionView)
        
        collectionView.register(FiguraCell.self, forCellWithReuseIdentifier: cellId)
    }
    
    // Función que carga las figuras de Parse
    
    func cargarFigurasDeParse(red: Bool){
        ParseData.sharedInstance.cargarFigurasVisibles(red: red){
                (figuras:[Figura]) -> Void in
                self.figuras = figuras
                self.collectionView.reloadData()
                self.refresh.endRefreshing()
            }
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
            print("Número de figuras encontradas: \(figuras?.count ?? 0)")
            return figuras?.count ?? 0
        }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cellId", for: indexPath) as! FiguraCell 
            cell.resetearTextosCelda()
            cell.figura = figuras?[indexPath.item]
            return cell
        }
    
        func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
    
            let height = 300
            let anchoPantalla = frame.width//view.frame.width
            let width  = Int((anchoPantalla  - 4 - 4 - 4) / 2)
    
            return CGSize(width: width, height: height)
        }
    
        func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
            return 4
        }
    
        func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
            return 4
        }
    
    
       func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
            let cellPulsada = collectionView.cellForItem(at: indexPath) as! FiguraCell
            if let figuraTratada = cellPulsada.figura {
                self.collectionView.allowsSelection = false // evitar doble click
                if let _ = figuraTratada.urlStringVideo {
                    let videoLauncher = VideoLauncher()
                    videoLauncher.showVideoPlayer(figura: figuraTratada)
                    videoLauncher.videoPlayer.delegate = self
                } else {
                    // No hay url de Video. No hacemos nada.
                }
            }
        }
    
    //  UIRefreshControl
    func refreshData(){
        // Cuando refresca siempre tiramos de red para hacer la query.
        self.cargarFigurasDeParse(red:true)
    }
  
    

}

// La clase FeedCell responderá al protocolo VideoPlayerViewProtocol
// Este protocolo determinará qué hacer al volver de la pantalla tras visualizar un vídeo.
extension FeedCell: VideoPlayerViewProtocol {
    func didCloseVideoPlayer() {
        print("Llamando protocolo desde FeedCell")
        self.collectionView.allowsSelection = true // activamos de nuevo la selección.
    }
}
