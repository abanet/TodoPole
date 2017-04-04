//
//  MenuLateralViewController.swift
//  TodoPole
//
//  Created by Alberto Banet on 8/2/17.
//  Copyright © 2017 Alberto Banet. All rights reserved.
//

import UIKit

struct MenuLateral {
    var opciones = ["Upload your move!", "Set filters"]
    let imagenes = ["upload50", "filter50"]
    let info     = ["Upload your moves!", "Set filters"]
}

class MenuLateralViewController: UITableViewController {

    var menu = MenuLateral()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        tableView.backgroundColor = ColoresApp.lightPrimary
         self.tableView.tableFooterView = UIView()
        
        self.tableView.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")
       
        
       //  if we'd like to show the version number.
       // let appVersion = Bundle.main.infoDictionary!["CFBundleShortVersionString"] as! String
       // menu.opciones[1] = "v. \(appVersion)"
        
        
    }

    override func viewWillAppear(_ animated: Bool) {
        print("menu lateral will appear")
        super.viewWillAppear(animated)
        
        // this will be non-nil if a blur effect is applied
        guard tableView.backgroundView == nil else {
            return
        }
        
        // Set up a cool background image for demo purposes
        let imageView = UIImageView(image: UIImage(named: "fondoMenuLateral"))
        imageView.contentMode = .scaleAspectFit
        imageView.backgroundColor = UIColor.black.withAlphaComponent(0.2)
        tableView.backgroundView = imageView
        tableView.separatorColor = ColoresApp.divider
        tableView.isScrollEnabled = false
    }
    
}

//  UITableViewDelegate
extension MenuLateralViewController {
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let item = indexPath.item
        switch item {
        case 0:
            let uploadViewController = UploadViewController()
            present(uploadViewController, animated: true, completion: nil)
        case 1:
            let setFilterViewController = SetFilterViewController()
            //self.navigationController?.pushViewController(setFilterViewController, animated: true) // necesario si queremos utilizar tablas anidadas
            present(setFilterViewController, animated: true, completion: nil)

        default:
            print("Never here!")
        }
        
        
    }
    
}


//  UITableViewDataSource
extension MenuLateralViewController {
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return menu.opciones.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as UITableViewCell
        cell.backgroundColor = .clear
        cell.textLabel?.text = menu.opciones[indexPath.item]
        cell.textLabel?.textColor = ColoresApp.darkPrimary
        if indexPath.item == menu.opciones.count - 1 { // last option
            cell.textLabel?.textAlignment = .center
        } else {
            cell.textLabel?.textAlignment = .right
        }
        cell.detailTextLabel?.text = menu.info[indexPath.item]
        cell.imageView?.image = UIImage(named: menu.imagenes[indexPath.item])?.withRenderingMode(.alwaysTemplate)
        cell.tintColor = ColoresApp.darkPrimary
        return cell
    }
}
