//
//  ViewController.swift
//  TodoPole
//
//  Created by Alberto Banet on 25/11/16.
//  Copyright © 2016 Alberto Banet. All rights reserved.
//

import UIKit
import Parse
import SideMenu


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
    
    /* -MENU- */
    let titles = ["Pole Dictionary", "Favorites", "Help Us"]
    let cellId = "cellId"
    let dictionaryCellId = "dictionaryCellId"
    let favoritosCellId  = "favoritosCellId"
    let colaboraCellId   = "colaboraCellId"
    let uploadCellId    = "uploadCellId"
    
    var videoPlayerController: VideoPlayerController?
    
    var menuSideController: MenuLateralViewController?
    
    
        
    func cargarVideosDeYoutube() {
        YouTube.sharedInstance.cargarVideos {
            (videos:[Video]) in
            self.videos = videos
            self.collectionView?.reloadData()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // menú lateral
        menuSideController = MenuLateralViewController()
        let menuRightNavigationController = UISideMenuNavigationController(rootViewController: menuSideController!)
        SideMenuManager.menuRightNavigationController = menuRightNavigationController
        
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
         setupNavBarButtons()
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
        collectionView?.register(ColaboraCell.self, forCellWithReuseIdentifier: colaboraCellId)
        collectionView?.register(UploadCell.self, forCellWithReuseIdentifier: uploadCellId)
        
        collectionView?.isPagingEnabled = true

    }
    
    
    lazy var menuBar: MenuBar = {
        let mb = MenuBar()
        mb.homeController = self
        return mb
    }()
    
    lazy var settingsLauncher: SettingsLauncher = {
        let launcher = SettingsLauncher()
        launcher.homeController = self
        return launcher
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
        //  Botón d buscar de momento no lo utilamos.
        // let searchImage = UIImage(named:"search_icon")?.withRenderingMode(.alwaysOriginal)
        // let searchBarButtonItem = UIBarButtonItem(image: searchImage, style: .plain, target: self, action: #selector(handleSearch))
    
        let moreButton = UIBarButtonItem(image: UIImage(named: "menu50")?.withRenderingMode(.alwaysOriginal), style: .plain, target: self, action: #selector(handleMore))
        navigationItem.rightBarButtonItems = [moreButton]
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
    
    func handleMore() {
        //Mostrar el menú
        //settingsLauncher.showSettings()
        // sacar menú lateral
        present(SideMenuManager.menuRightNavigationController!, animated: true, completion: nil)
    }
    
    func showControllerForSetting(_ setting: Setting) {
        let dummySettingsViewController = UIViewController()
        dummySettingsViewController.view.backgroundColor = UIColor.white
        dummySettingsViewController.navigationItem.title = setting.name.rawValue
        navigationController?.navigationBar.tintColor = UIColor.white
        navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.white]
        navigationController?.pushViewController(dummySettingsViewController, animated: true)
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
        
        if indexPath.item == 1 {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: favoritosCellId, for: indexPath) as! FavoritosCell
            return cell
        }
        
        if indexPath.item == 2 {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: uploadCellId, for: indexPath) as! UploadCell
            return cell
        }
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: colaboraCellId, for: indexPath)
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        //print("--> Tamaño para \(indexPath): \(view.frame.width), \(self.view.frame.height - (50 + 8))")
        return CGSize(width: view.frame.width, height: self.view.frame.height - (50 + 8))
    }

    // se ejecuta cuando la celda va a aparecer
    override func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        
        if indexPath.item == 1 {
            let celda = cell as! FavoritosCell
            celda.setupViews() // ¡para que refresque los datos de favoritos!
        }
        
    }
    
    
    override func collectionView(_ collectionView: UICollectionView, didEndDisplaying cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        print("Dejando de ver celda: \(indexPath.item)")
        cell.contentView.endEditing(true)
        
        cell.setNeedsLayout()
        cell.setNeedsDisplay()
        
    }
    
    
}


