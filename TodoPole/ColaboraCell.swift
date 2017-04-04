//
//  ColaboraCell.swift
//  TodoPole
//
//  Created by Alberto Banet on 5/1/17.
//  Copyright © 2017 Alberto Banet. All rights reserved.
//

import UIKit
import WebKit

class ColaboraCell: BaseCell {
    
    let webColabora: WKWebView? = {
        if let keyWindow = UIApplication.shared.keyWindow {
            let web = WKWebView(frame: keyWindow.frame)
            return web
        }
        return nil
    }()
    
    override func setupViews() {
        if let web = webColabora {
            addSubview(web)
            let url = Bundle.main.url(forResource: "app", withExtension: "html")
            let request = URLRequest(url: url!)
            web.load(request)
        }
        backgroundColor = .green
    }
  
}
