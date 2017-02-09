//
//  Firebase.swift
//  TodoPole
//
//  Created by Alberto Banet on 6/2/17.
//  Copyright © 2017 Alberto Banet. All rights reserved.
//

import Foundation
import FirebaseStorage
import FirebaseDatabase

//  Protocolo para informar del progreso en operaciones de carga/descarga con Firebase.
protocol FirebaseProgress {
    func progressHappened(progress: Progress)
    func uploadEndedWithSuccess()
    func uploadFailure()
}

class Firebase: NSObject {
    
    var delegate: FirebaseProgress?
    
    let storage = {
        return FIRStorage.storage()
    }()
    
    
    var storageRef: FIRStorageReference
    
    var databaseRef: FIRDatabaseReference
    
    var uploadTask: FIRStorageUploadTask?
    
    var metadataFigura: FiguraFirebase!
    
    //  Creamos referencia a Firebase
    override init() {
        storageRef = storage.reference(forURL: "gs://chromatic-being-87921.appspot.com")
        databaseRef = FIRDatabase.database().reference(withPath: "figuras")
        super.init()
    }
    
    func uploadData(data: Data){
        let videoRef = storageRef.child("figuras/video.mov")
        
        // Upload the file
        uploadTask = videoRef.put(data, metadata: nil) { metadata, error in
            if (error != nil) {
                // Uh-oh, an error occurred!
            } else {
                // Metadata contains file metadata such as size, content-type, and download URL.
                let downloadURL = metadata!.downloadURL
            }
        }
    }
    
    func uploadData(url: URL){
        let uuid = UUID().uuidString
        let videoRef = storageRef.child("figuras/\(uuid)")
        
        // Upload the file
        uploadTask = videoRef.putFile(url)
        let observer = uploadTask?.observe(.progress) {
            snapshot in
            if let progress = snapshot.progress {
                let percentComplete = 100.0 * Double(progress.completedUnitCount) / Double(progress.totalUnitCount)
                //print(percentComplete)
                self.delegate?.progressHappened(progress: progress)
            }
        }
        
        uploadTask?.observe(.success) { snapshot in
            print("FIN")
            // La figura se ha subido, grabamos sus datos
            let figuraRef = self.databaseRef.child(uuid).setValue(self.metadataFigura)
            
            
            self.uploadTask?.removeAllObservers()
            self.delegate?.uploadEndedWithSuccess()
        }
        
        uploadTask?.observe(.failure) { snapshot in
            print("Upload Cancelado")
            self.uploadTask?.removeAllObservers()
        }
        
    }
    
    func cancelUpload(){
        uploadTask?.cancel()
        uploadTask?.removeAllObservers()
    }
    
}
