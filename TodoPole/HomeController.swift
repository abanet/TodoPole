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
import FBSDKLoginKit



class HomeController: UICollectionViewController, UICollectionViewDelegateFlowLayout {

    var videos: [Video]?
    
    /* -MENU- */
    let titles = ["Pole Dictionary", "Amateurs", "Favorites", "Help Us"]
    let cellId = "cellId"
    let dictionaryCellId = "dictionaryCellId"
    let favoritosCellId  = "favoritosCellId"
    let colaboraCellId   = "colaboraCellId"
    let amateursCellId   = "amateursCellId"
    
    var menuSideController: MenuLateralViewController?
    
    var opcionMenuSeleccionada: Int = 0
    var opcionMenuOrigen: Int? 
        
    
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
        collectionView?.register(AmateursCell.self, forCellWithReuseIdentifier: amateursCellId)

        
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
        setMoreButton()
        // setAuthorButton() // De entrada aparece.
        setFilterButton() // De entrada aparece.
    }
    
    override func scrollViewDidScroll(_ scrollView: UIScrollView) {
        menuBar.horizontalBarLeftAnchorConstraint?.constant = scrollView.contentOffset.x / CGFloat(ConfiguracionMenu.numOpciones)
    }
    
    override func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        let index = Int(targetContentOffset.pointee.x / view.frame.width)
        let indexPath = IndexPath(item: index, section: 0)
        menuBar.collectionView.selectItem(at: indexPath, animated: true, scrollPosition: .left)
        
        setTitleForIndex(index: Int(index))
        opcionMenuOrigen = opcionMenuSeleccionada
        opcionMenuSeleccionada = Int(index) // actualizamos la opción de menú seleccionada
        
    }
    
    func handleSearch(){
        //Mostrar el menú
        settingsLauncher.showSettings()
    }
    
    func handleAuthor(){
        // Show author selection
        print("Show author selection")
    }
    
    func handleMore() {
        // sacar menú lateral
        present(SideMenuManager.menuRightNavigationController!, animated: true, completion: nil)
    }
    
    func showControllerForSetting(_ setting: Setting) {
        let celda = collectionView?.cellForItem(at: IndexPath(item: 0, section: 0)) as! DictionaryCell
        
        if let ultimoSetting = settingsLauncher.actualSetting, ultimoSetting == setting {
            return //  no ha habido cambio de setting y no hay q refrescar.
        }
        
        if settingsLauncher.actualSetting == nil && setting.name == .Cancel {
            return //  No había selección previa y se sale con cancel. Nada cambia.
        }
        
        settingsLauncher.actualSetting = setting
        settingsLauncher.collectionView.reloadData()
        
        switch setting.name {
        case .Giros:
            celda.tipo = .giro
        case .Figuras:
            celda.tipo = .figura
        case .Subidas:
            celda.tipo = .subida
        case .Suelo:
            celda.tipo = .suelo
        case .Transiciones:
            celda.tipo = .transicion
        case .Combos:
            celda.tipo = .combos
        case .Cancel:
            celda.tipo = nil
        }
        celda.cargarFigurasDeParse(red: false)
    }

    
    func scrollToMenuIndex(menuIndex: Int) {
        //  Si el índice en el que se pulsa es en el que estamos no hay que hacer nada.
        guard let opcionMenuActual = opcionMenuOrigen, opcionMenuActual != menuIndex else {
            return
        }
        let indexPath = IndexPath(item: menuIndex, section: 0)
        collectionView?.scrollToItem(at: indexPath, at: [], animated: true)
        setTitleForIndex(index: menuIndex)
        if indexPath.item == 0 {
            //setAuthorButton()
            setFilterButton()
        } else {
            removeFilterButton()
            existsFilterButton = false
        }
    }
    
    var existsFilterButton = false
   // var existsAuthorButton = false
    
    private func setFilterButton() {
        if !existsFilterButton {
            let searchImage = UIImage(named:"search_icon")?.withRenderingMode(.alwaysOriginal)
            let searchBarButtonItem = UIBarButtonItem(image: searchImage, style: .plain, target: self, action: #selector(handleSearch))
            navigationItem.rightBarButtonItems?.append(searchBarButtonItem)
            existsFilterButton = true
        }
    }
    
//    private func setAuthorButton(){
//        if !existsAuthorButton {
//            let authorImage = UIImage(named:"author")?.withRenderingMode(.alwaysOriginal)
//            let authorBarButtonItem = UIBarButtonItem(image: authorImage, style: .plain, target: self, action: #selector(handleAuthor))
//            navigationItem.rightBarButtonItems?.append(authorBarButtonItem)
//        }
//    }
    
    private func removeFilterButton() {
        navigationItem.rightBarButtonItems = nil
        setMoreButton()
    }
    
    
    private func setMoreButton() {
        let moreButton = UIBarButtonItem(image: UIImage(named: "menu50")?.withRenderingMode(.alwaysOriginal), style: .plain, target: self, action: #selector(handleMore))
        navigationItem.rightBarButtonItems = [moreButton]
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
    
    var cell: UICollectionViewCell
    
    switch indexPath.item {
    case 0:
      cell = collectionView.dequeueReusableCell(withReuseIdentifier: dictionaryCellId, for: indexPath)
    case 1:
      cell = collectionView.dequeueReusableCell(withReuseIdentifier: amateursCellId, for: indexPath)
    case 2:
      cell = collectionView.dequeueReusableCell(withReuseIdentifier: favoritosCellId, for: indexPath) as! FavoritosCell
    case 3:
      cell = collectionView.dequeueReusableCell(withReuseIdentifier: colaboraCellId, for: indexPath)
    default:
      cell = collectionView.dequeueReusableCell(withReuseIdentifier: colaboraCellId, for: indexPath)
    }
    return cell
  }
  
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        //print("--> Tamaño para \(indexPath): \(view.frame.width), \(self.view.frame.height - (50 + 8))")
        return CGSize(width: view.frame.width, height: self.view.frame.height - (50 + 8))
    }

    // se ejecuta cuando la celda va a aparecer
    override func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if indexPath.item == 2 {
            let celda = cell as! FavoritosCell
            celda.setupViews() // ¡para que refresque los datos de favoritos!
        }
        
    }
    
 
    
}


