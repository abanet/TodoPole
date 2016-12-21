//
//  ViewController.swift
//  TodoPole
//
//  Created by Alberto Banet on 25/11/16.
//  Copyright © 2016 Alberto Banet. All rights reserved.
//

import UIKit
import Parse


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

    var videos: [Video]?
    
    let titles = ["Pole Dictionary", "Favoritos", "Colabora"]
    let cellId = "cellId"
    let dictionaryCellId = "dictionaryCellId"
    let favoritosCellId  = "favoritosCellId"
    
    var videoPlayerController: VideoPlayerController?
    
    
        
    func cargarVideosDeYoutube() {
        YouTube.sharedInstance.cargarVideos {
            (videos:[Video]) in
            self.videos = videos
            self.collectionView?.reloadData()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Configuración del navigation
        let titulo = UILabel(frame: CGRect(x: 0, y: 0, width: view.frame.width - 2 * view.layoutMargins.left, height: view.frame.height))
        titulo.text = "Pole Dictionary"
        titulo.textColor = UIColor.white
        titulo.font = UIFont.systemFont(ofSize: 20)
        
        navigationItem.titleView = titulo
        navigationController?.navigationBar.isTranslucent = false
        
        
        // Configuración del collectionView
        setupCollectionView()
        
        // Menú principal
        setupMenuBar()
        
        // Por ahora no implemento la búsqueda
        // TODO: futuras versiones
        // setupNavBarButtons()
    }

    func setupCollectionView(){
        //Configuración del collectionView
        
        if let flowLayout = collectionView?.collectionViewLayout as? UICollectionViewFlowLayout {
            flowLayout.scrollDirection = .horizontal
            flowLayout.minimumLineSpacing = 0
        }
        collectionView?.backgroundColor = ColoresApp.lightPrimary
 
        collectionView?.contentInset = UIEdgeInsets(top: 50 + view.layoutMargins.top, left: 0 ,bottom: 0 ,right: 0)
        
        collectionView?.scrollIndicatorInsets = UIEdgeInsets(top: 50 + view.layoutMargins.top, left: 0, bottom: 0,right: 0)
        collectionView?.register(FeedCell.self, forCellWithReuseIdentifier: cellId)
        collectionView?.register(DictionaryCell.self, forCellWithReuseIdentifier: dictionaryCellId)
        collectionView?.register(FavoritosCell.self, forCellWithReuseIdentifier: favoritosCellId)
        
        collectionView?.isPagingEnabled = true

    }
    
    
    lazy var menuBar: MenuBar = {
        let mb = MenuBar()
        mb.homeController = self
        return mb
    }()
    
    private func setupMenuBar(){
        // Da problemas con el doble desplazamiento. La vista falsa no haría falta con hideBarsOnSwipe desactivado.
        // navigationController?.hidesBarsOnSwipe = true
        
        // vista para tapar hueco al desplazar el collectionview hacia el status bar
        let vistaFalsa = UIView()
        vistaFalsa.backgroundColor = ColoresApp.primary
        view.addSubview(vistaFalsa)
        view.addConstraintsWithFormat(format: "H:|[v0]|", views: vistaFalsa)
        view.addConstraintsWithFormat(format: "V:[v0(50)]", views: vistaFalsa)
        
        view.addSubview(menuBar)
        view.addConstraintsWithFormat(format: "H:|[v0]|", views: menuBar)
        view.addConstraintsWithFormat(format: "V:[v0(50)]", views: menuBar)
        
        menuBar.topAnchor.constraint(equalTo: topLayoutGuide.bottomAnchor).isActive = true
    }
    
    func setupNavBarButtons(){
        let searchImage = UIImage(named:"search_icon")?.withRenderingMode(.alwaysOriginal)
        let searchBarButtonItem = UIBarButtonItem(image: searchImage, style: .plain, target: self, action: #selector(handleSearch))
        navigationItem.rightBarButtonItems = [searchBarButtonItem]
    }
    
    override func scrollViewDidScroll(_ scrollView: UIScrollView) {
        menuBar.horizontalBarLeftAnchorConstraint?.constant = scrollView.contentOffset.x / CGFloat(ConfiguracionMenu.numOpciones)
    }
    
    override func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        let index = Int(targetContentOffset.pointee.x / view.frame.width)
        let indexPath = IndexPath(item: index, section: 0)
        menuBar.collectionView.selectItem(at: indexPath, animated: true, scrollPosition: .left)
        
        setTitleForIndex(index: Int(index))
    }
    
    func handleSearch(){
        
    }
    
    func scrollToMenuIndex(menuIndex: Int) {
        let indexPath = IndexPath(item: menuIndex, section: 0)
        collectionView?.scrollToItem(at: indexPath, at: [], animated: true)
        setTitleForIndex(index: menuIndex)
    }
    
    private func setTitleForIndex(index: Int) {
        if let titleLabel = navigationItem.titleView as? UILabel {
            titleLabel.text = "  \(titles[index])"
        }
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return ConfiguracionMenu.numOpciones
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if indexPath.item == 0 {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: dictionaryCellId, for: indexPath)
            return cell
        }
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: favoritosCellId, for: indexPath)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: view.frame.width, height: self.view.frame.height - (50 + 8))
    }

    
    
}


