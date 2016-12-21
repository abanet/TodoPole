//
//  VideoViewController.swift
//  TodoPole
//
//  Created by Alberto Banet on 13/12/16.
//  Copyright © 2016 Alberto Banet. All rights reserved.
//

import UIKit


class VideoPlayerController: UIViewController {

    // player del vídeo
    var videoPlayer: YouTubePlayerView!
    var videoId: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if let id = videoId {
            videoPlayer.loadVideoID(id)
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func loadView() {
        videoPlayer = YouTubePlayerView(frame: UIScreen.main.bounds)
        videoPlayer.backgroundColor = UIColor.red
        view = videoPlayer
    }
}
