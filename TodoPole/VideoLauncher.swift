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

protocol VideoPlayerViewProtocol: class {
    func didCloseVideoPlayer()
}

class VideoPlayerView: UIView {
    
    weak var delegate: VideoPlayerViewProtocol?
    
    var enFavoritos: Bool?
    
    var figura: Figura? // Figura que estamos visualizando. La iniciamos cuando se llama a reproducir Vídeo
    
    let activityIndicatorView: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView(activityIndicatorStyle: .whiteLarge)
        indicator.translatesAutoresizingMaskIntoConstraints = false
        indicator.startAnimating()
        return indicator
    }()
    
    let controlContainerView: UIView = {
        let view = UIView()
        view.backgroundColor = ColoresApp.darkPrimary  //UIColor(white: 0, alpha: 1.0)
        return view
    }()
    
    let videoLengthLabel: UILabel = {
        let label = UILabel()
        label.text = "00:00"
        label.textColor = .white
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.boldSystemFont(ofSize: 13)
        label.textAlignment = .right
        return label
    }()
    
    let currentTimeLabel: UILabel = {
        let label = UILabel()
        label.text = "00:00"
        label.textColor = .white
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.boldSystemFont(ofSize: 13)
        return label
    }()

    
    lazy var videoSlider: UISlider = {
        let slider = UISlider()
        slider.minimumTrackTintColor = ColoresApp.darkPrimary
        slider.maximumTrackTintColor = ColoresApp.lightPrimary
        slider.translatesAutoresizingMaskIntoConstraints = false
        slider.setThumbImage(UIImage(named:"thumb"), for: .normal)
        
        slider.addTarget(self, action: #selector(handleSliderChange), for: .valueChanged)
        
        return slider
    }()
    
    func handleSliderChange() {
        if let duration = player?.currentItem?.duration {
            let segundosDuracion = CMTimeGetSeconds(duration)
            let posicionVideo = segundosDuracion * Float64(videoSlider.value)
            let seekTime = CMTime(value: Int64(posicionVideo), timescale: 1)
            player?.seek(to: seekTime, completionHandler: { (completed) in
                // por si hacemos algo al completar el posicionamiento
            })
        }
        
    }
    
    lazy var pausePlayButton: UIButton = {
        let button = UIButton(type: .system)
        let image  = UIImage(named: "pause")
        button.setImage(image, for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.tintColor = .white
        button.addTarget(self, action: #selector(handlePause), for: .touchUpInside)
        button.isHidden = true
        button.alpha = 0.7
        return button
    }()
    
    lazy var closeButton: UIButton = {
        let button = UIButton(type: .system)
        let image = UIImage(named: "cancel")
        button.setImage(image, for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.tintColor = .white
        button.addTarget(self, action: #selector(handleClose), for: .touchUpInside)
        button.alpha = 0.7
        return button
    }()
    
    var likeButton: UIButton = {
        let button = UIButton(type: .system)
        let image = UIImage(named: "like")
        button.setImage(image, for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(handleLike), for: .touchUpInside)
        button.alpha = 0.7
        return button

    }()
    
    
    func handleLike() {
        print("Like pulsado")
        
        if let figura = figura, let esFavorita = self.enFavoritos {
            if esFavorita  {
                likeButton.tintColor = .white
                Favoritos.sharedInstance.removeFavorito(id: figura.objectId!)
                self.enFavoritos = false
            } else {
                likeButton.tintColor = .red
                Favoritos.sharedInstance.addFavorito(id: figura.objectId!)
                self.enFavoritos = true
            }
        }
    }
    
    
    func handleClose(){
        player?.pause()
        isPlaying = false
        
        let frame = CGRect(x: self.frame.width - 10 , y: self.frame.height - 10, width: 10, height: 10)
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1.0, initialSpringVelocity: 1.0, options: .curveEaseOut, animations: {
            self.superview?.frame = frame
        }, completion: {(animacionCompletada) in
            self.player = nil
            self.superview?.removeFromSuperview()
            UIApplication.shared.setStatusBarHidden(false, with: .fade)
            
        })
        
        // En el caso de que exista un delegado se llama. 
        // Lo habrá al cerrar la ventana desde Favoritos
        delegate?.didCloseVideoPlayer()
    }
    
    var isPlaying = false
    
    func handlePause() {
        if isPlaying {
            player?.pause()
            pausePlayButton.setImage(UIImage(named: "play"), for: .normal)
        } else {
            player?.play()
            pausePlayButton.setImage(UIImage(named: "pause"), for: .normal)
        }
        isPlaying = !isPlaying
    }
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    convenience init(frame: CGRect, figura:Figura) {
        self.init(frame: frame)
        
        
        setupPlayerView(figura: figura)
        
        setupGradientLayer()
        
        controlContainerView.frame = frame
        addSubview(controlContainerView)
        // añadimos el activity
        controlContainerView.addSubview(activityIndicatorView)
        activityIndicatorView.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        activityIndicatorView.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        
        //  añadimos el botón de pausa
        controlContainerView.addSubview(pausePlayButton)
        pausePlayButton.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        pausePlayButton.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        pausePlayButton.widthAnchor.constraint(equalToConstant: 50.0).isActive = true
        pausePlayButton.heightAnchor.constraint(equalToConstant: 50.0).isActive = true
        
        //  longitud del video
        controlContainerView.addSubview(videoLengthLabel)
        videoLengthLabel.rightAnchor.constraint(equalTo: rightAnchor, constant: -8).isActive = true
        videoLengthLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -2).isActive = true
        videoLengthLabel.widthAnchor.constraint(equalToConstant: 50).isActive = true
        videoLengthLabel.heightAnchor.constraint(equalToConstant: 24).isActive = true
        
        // tiempo actual del video
        controlContainerView.addSubview(currentTimeLabel)
        currentTimeLabel.leftAnchor.constraint(equalTo: leftAnchor, constant: 8).isActive = true
        currentTimeLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -2).isActive = true
        currentTimeLabel.widthAnchor.constraint(equalToConstant: 50).isActive = true
        currentTimeLabel.heightAnchor.constraint(equalToConstant: 24).isActive = true
        
        //  slider
        controlContainerView.addSubview(videoSlider)
        videoSlider.rightAnchor.constraint(equalTo: videoLengthLabel.leftAnchor).isActive = true
        videoSlider.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        videoSlider.leftAnchor.constraint(equalTo: currentTimeLabel.rightAnchor).isActive = true
        videoSlider.heightAnchor.constraint(equalToConstant: 30).isActive = true
        
        //  Botón de cerrar
        controlContainerView.addSubview(closeButton)
        closeButton.leftAnchor.constraint(equalTo: leftAnchor, constant: 8).isActive = true
        closeButton.topAnchor.constraint(equalTo: topAnchor, constant: 8).isActive = true
        closeButton.widthAnchor.constraint(equalToConstant: 50).isActive = true
        closeButton.heightAnchor.constraint(equalToConstant: 50).isActive = true

        //  Añadimos el like
        controlContainerView.addSubview(likeButton)
        likeButton.rightAnchor.constraint(equalTo: videoLengthLabel.leftAnchor).isActive = true
        likeButton.topAnchor.constraint(equalTo: closeButton.bottomAnchor).isActive = true
        likeButton.widthAnchor.constraint(equalToConstant: 50).isActive = true
        likeButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
        // Color del like: blanco si no es favorito, rojo si lo es
        if Favoritos.sharedInstance.isFavorito(id: figura.objectId!) {
            likeButton.tintColor = .red
            self.enFavoritos = true
        } else {
            likeButton.tintColor = .white
            self.enFavoritos = false
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    var player: AVPlayer?
    
    private func setupPlayerView(figura: Figura) {
        self.figura = figura // Inicialización de la figura q vamos a mostrar.
        
        let urlString = figura.urlStringVideo
        if let url = URL(string: urlString!) {
            player = AVPlayer(url: url)
            if #available(iOS 10.0, *) {
                player?.automaticallyWaitsToMinimizeStalling = true
            } else {
                // Fallback on earlier versions
            }
            let playerLayer = AVPlayerLayer(player: player)
            playerLayer.frame = self.bounds
            playerLayer.videoGravity = AVLayerVideoGravityResizeAspectFill
            self.layer.addSublayer(playerLayer)
            player?.play()
        
            // Añadimos observer para que nos avise cuando el vídeo ha empezado
            player?.addObserver(self, forKeyPath: "currentItem.loadedTimeRanges", options: .new, context: nil)
            
            //track player progress
            
            let interval = CMTime(value: 1, timescale: 2)
            player?.addPeriodicTimeObserver(forInterval: interval, queue: DispatchQueue.main, using: { (progressTime) in
                
                let seconds = CMTimeGetSeconds(progressTime)
                let secondsString = String(format: "%02d", Int(seconds.truncatingRemainder(dividingBy: 60)))
                let minutesString = String(format: "%02d", Int(seconds / 60))
                
                self.currentTimeLabel.text = "\(minutesString):\(secondsString)"
                
                //lets move the slider thumb
                if let duration = self.player?.currentItem?.duration {
                    let durationSeconds = CMTimeGetSeconds(duration)
                    self.videoSlider.value = Float(seconds / durationSeconds)
                    
                }
                
            })
        
        }
    }
    
    fileprivate func setupGradientLayer() {
        let gradientLayerInferior = CAGradientLayer()
        gradientLayerInferior.frame = bounds
        gradientLayerInferior.colors = [UIColor.clear.cgColor, UIColor.black.cgColor]
        gradientLayerInferior.locations = [0.7, 1.2]
        controlContainerView.layer.addSublayer(gradientLayerInferior)
        let gradientLayerSuperior = CAGradientLayer()
        gradientLayerSuperior.frame = bounds
        gradientLayerSuperior.colors = [UIColor.black.cgColor, UIColor.clear.cgColor]
        gradientLayerSuperior.locations = [-0.2, 0.2]
        controlContainerView.layer.addSublayer(gradientLayerSuperior)
    }
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        // El video se empeiza a mostrar
        if keyPath == "currentItem.loadedTimeRanges" {
            activityIndicatorView.stopAnimating()
            controlContainerView.backgroundColor = .clear
            pausePlayButton.isHidden = false
            isPlaying = true
            
            // Mostrar duración del vídeo
            if let duracion = player?.currentItem?.duration {
                let segundos = CMTimeGetSeconds(duracion)
                let segundosText = String(format: "%02d", Int(segundos) % 60)
                let minutosText = String(format: "%02d", Int(segundos) / 60)
                videoLengthLabel.text = "\(minutosText):\(segundosText)"
            }
            
        }
    }
}


class VideoLauncher: NSObject {
    
    // Video Player en el que se verá el vídeo.
    // Al llamar a VideoLauncher se establece el delegate del VideoPlayer
    var videoPlayer: VideoPlayerView = VideoPlayerView()
    
    func showVideoPlayer(figura: Figura) {
        print("Mostrando vídeo")
        if let keyWindow = UIApplication.shared.keyWindow {
            let view = UIView(frame: .zero)
            view.frame = CGRect(x: keyWindow.frame.width - 10 , y: keyWindow.frame.height - 10, width: 10, height: 10)
            view.backgroundColor = ColoresApp.lightPrimary
            
            videoPlayer = VideoPlayerView(frame: keyWindow.frame, figura: figura)
            
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
