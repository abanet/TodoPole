//
//  Firebase.swift
//  TodoPole
//
//  Created by Alberto Banet on 6/2/17.
//  Copyright © 2017 Alberto Banet. All rights reserved.
//

import Foundation
import FirebaseStorage



class Firebase: NSObject {
    
    let storage = {
        return FIRStorage.storage()
    }()
    
    
    var storageRef: FIRStorageReference
    
    //  Creamos referencia a Firebase
    override init() {
        storageRef = storage.reference(forURL: "gs://chromatic-being-87921.appspot.com")
        super.init()
    }
    
    func uploadData(data: Data){
        let videoRef = storageRef.child("figuras/video.mov")
        
        // Upload the file
        let uploadTask = videoRef.put(data, metadata: nil) { metadata, error in
            if (error != nil) {
                // Uh-oh, an error occurred!
            } else {
                // Metadata contains file metadata such as size, content-type, and download URL.
                let downloadURL = metadata!.downloadURL
            }
        }
    }
    
    func uploadData(url: URL){
        let videoRef = storageRef.child("figuras/video.mov")
        
        // Upload the file
        let uploadTask = videoRef.putFile(url)
        let observer = uploadTask.observe(.progress) {
            snapshot in
            if let progress = snapshot.progress {
                let percentComplete = 100.0 * Double(progress.completedUnitCount) / Double(progress.totalUnitCount)
                print(percentComplete)
            }
        }
        
        uploadTask.observe(.success) { snapshot in
            print("FIN")
            uploadTask.removeAllObservers()
        }
    }
    
    
    
}
