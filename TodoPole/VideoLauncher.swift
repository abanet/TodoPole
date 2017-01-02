//
//  VideoLauncher.swift
//  TodoPole
//
//  Created by Alberto Banet on 2/1/17.
//  Copyright © 2017 Alberto Banet. All rights reserved.
//

import UIKit
import AVFoundation
import AVKit

class VideoPlayerView: UIView {
    override init(frame: CGRect) {
        super.init(frame: frame)
        

    }
    
    convenience init(frame: CGRect, figura:Figura) {
        self.init(frame: frame)
        backgroundColor = UIColor.green
        let urlString = figura.urlStringVideo
        if let url = URL(string: urlString!) {
//            let player = AVPlayer(url: url)
//            let playerLayer = AVPlayerLayer(player: player)
//            self.layer.addSublayer(playerLayer)
//            playerLayer.frame = UIApplication.shared.keyWindow!.frame
//            player.play()
            
            let player = AVPlayer(url: url)
            let playerLayer = AVPlayerLayer(player: player)
            playerLayer.frame = self.bounds
            playerLayer.videoGravity = AVLayerVideoGravityResizeAspectFill
            self.layer.addSublayer(playerLayer)
            player.play()
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}


class VideoLauncher: NSObject {
    func showVideoPlayer(figura: Figura) {
        print("Mostrando vídeo")
        if let keyWindow = UIApplication.shared.keyWindow {
            let view = UIView(frame: .zero)
            view.frame = CGRect(x: keyWindow.frame.width - 10 , y: keyWindow.frame.height - 10, width: 10, height: 10)
            view.backgroundColor = ColoresApp.lightPrimary
            
            let videoPlayer = VideoPlayerView(frame: keyWindow.frame, figura: figura)
            view.addSubview(videoPlayer)
            
            keyWindow.addSubview(view)
            
            UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1.0, initialSpringVelocity: 1.0, options: .curveEaseOut, animations: {
                view.frame = keyWindow.frame
            }, completion: {(animacionCompletada) in
                UIApplication.shared.setStatusBarHidden(true, with: .fade)
                
            })
            
            
        }
    }
}
