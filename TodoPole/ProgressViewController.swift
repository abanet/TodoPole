//
//  ProgressViewController.swift
//  TodoPole
//
//  Created by Alberto Banet on 9/2/17.
//  Copyright © 2017 Alberto Banet. All rights reserved.
//

import UIKit
import KDCircularProgress
import FirebaseStorage

class ProgressViewController: UIViewController {

    var fireUploadTask: Firebase!

    lazy var progress: KDCircularProgress = {
            let p = KDCircularProgress(frame: CGRect(x: 0, y: 0, width: 200, height: 200))
            p.startAngle = -90
            p.progressThickness = 0.1
            p.trackThickness = 0.1
            p.clockwise = true
            p.gradientRotateSpeed = 2
            p.roundedCorners = false
            p.glowMode = .forward
            p.glowAmount = 0.9
            p.set(colors: ColoresApp.lightPrimary, ColoresApp.darkPrimary)
            p.trackColor = ColoresApp.divider
            p.center = CGPoint(x: self.view.center.x, y: self.view.center.y)
            return p
        }()

    lazy var cancelButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Cancel", for: .normal)
        button.titleLabel?.font = UIFont(name: "Avenir-Medium", size:24)!
        button.translatesAutoresizingMaskIntoConstraints = false
        button.tintColor = ColoresApp.darkPrimary
        button.addTarget(self, action: #selector(cancelUpload), for: .touchUpInside)
        
        //button.alpha = 0.7
        return button
    }()

    let percentageLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "Avenir-Medium", size:22)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "00%"
        label.textColor = ColoresApp.primaryText
        return label
    }()
    
    var imageForBlur: UIImage?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .red
        
        // Do any additional setup after loading the view.
    }

    override func viewWillAppear(_ animated: Bool) {
        if let image = imageForBlur {
            self.view.backgroundColor = UIColor(patternImage: image)
        }
        
        let blurEffect = UIBlurEffect(style: UIBlurEffectStyle.light)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.frame = view.bounds
        blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        view.addSubview(blurEffectView)
        view.addSubview(progress)
        view.addSubview(percentageLabel)
        view.addSubview(cancelButton)
        percentageLabel.centerXAnchor.constraint(equalTo: progress.centerXAnchor).isActive = true
        percentageLabel.centerYAnchor.constraint(equalTo: progress.centerYAnchor).isActive = true
        cancelButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        cancelButton.centerYAnchor.constraint(equalTo: progress.bottomAnchor, constant: 200)
    }
    
    @objc func cancelUpload(){
        fireUploadTask.cancelUpload()
        dismiss(animated: true, completion: nil)
    }
    
}

extension ProgressViewController: FirebaseProgress {
    func progressHappened(progress: Progress) {
        print(progress)
        self.progress.angle = progress.fractionCompleted * 360
        let porcentaje = "\(Int(progress.fractionCompleted * 100))%"
        percentageLabel.text = porcentaje
    }
    
    func uploadEndedWithSuccess(){
        dismiss(animated: true, completion: nil)
    }
    
    func uploadFailure() {
        dismiss(animated: true, completion: nil)
    }
}
