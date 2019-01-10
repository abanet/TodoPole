//
//  AppDelegate.swift
//  TodoPole
//
//  Created by Alberto Banet on 25/11/16.
//  Copyright © 2016 Alberto Banet. All rights reserved.
//

import UIKit
import Parse
import Bolts
import Firebase


@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        // Configurar conexión con el backend back4app
        configurarConexionBackend()
        UIApplication.shared.statusBarStyle = .lightContent
        
        window = UIWindow(frame:UIScreen.main.bounds)
        window?.makeKeyAndVisible()
        
        let layout = UICollectionViewFlowLayout()
        window?.rootViewController = UINavigationController(rootViewController: HomeController(collectionViewLayout: layout))
        
        UINavigationBar.appearance().barTintColor = ColoresApp.primary
        
        // Eliminar sombreado de la parte inferior del navigationBar
        UINavigationBar.appearance().shadowImage = UIImage()
        UINavigationBar.appearance().setBackgroundImage(UIImage(), for: .default)
        
        let statusBarBackgroundView = UIView()
        statusBarBackgroundView.backgroundColor = ColoresApp.darkPrimary
        window?.addSubview(statusBarBackgroundView)
        window?.addConstraintsWithFormat(format: "H:|[v0]|", views: statusBarBackgroundView)
        window?.addConstraintsWithFormat(format: "V:|[v0(20)]", views: statusBarBackgroundView)
        
        // Configuramos Firebase
        FirebaseApp.configure()
        
        // Reading author list from network just first time.
//      ParseData.sharedInstance.listOfAuthors(red: true) { (result:[String]) in
//            print("Lista autores leida")
//            for author in result {
//                PFCloud.callFunction(inBackground: "numFigurasPoleDancer", withParameters: ["autor": author], block: { (response: Any?, error: Error?) in
//                print("\(author)->numFigurasPoleDancer: \(response as? Float)")
//                })
//                PFCloud.callFunction(inBackground: "numLikesPoleDancer", withParameters: ["autor": author], block: { (response: Any?, error: Error?) in
//                    print("\(author)->numLikesPoleDancer: \(response as? Float)")
//                })
//            }
//        }
      
        return true
    }
    


    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }

    func configurarConexionBackend(){
        let configuration = ParseClientConfiguration {
            $0.applicationId = "ILah5fOqSJX6nMu7JwIYkwDO4A6YoKiqCXVllFho"
            $0.clientKey = "WbVNLWMVLFSPH4vmxDlscOKBQ4vY2m4ERdOe1M2E"
            $0.server = "https://parseapi.back4app.com"
        }
        Parse.initialize(with: configuration)
    }
}

// extensión de UIApplication para conoceer el controlador que está a cargo en un momento dado
extension UIApplication {
    class func topViewController(controller: UIViewController? = UIApplication.shared.keyWindow?.rootViewController) -> UIViewController? {
        if let navigationController = controller as? UINavigationController {
            return topViewController(controller: navigationController.visibleViewController)
        }
        if let tabController = controller as? UITabBarController {
            if let selected = tabController.selectedViewController {
                return topViewController(controller: selected)
            }
        }
        if let presented = controller?.presentedViewController {
            return topViewController(controller: presented)
        }
        return controller
    }
}
