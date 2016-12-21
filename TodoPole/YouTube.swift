//
//  YouTube.swift
//  ppp
//
//  Created by Alberto Banet on 5/11/16.
//  Copyright © 2016 Alberto Banet. All rights reserved.
//

import Foundation


// API KEY DE YOUTUBE ALBERTO BANET
let APIKeyYouTube = "AIzaSyAB1bIwaCZWF752wuf6FLY4dZLF2foDoow"

// Url de llamada a youtube
// Parámetros utilizados:
// playlistId -> identificador de la lista de la que se van a obtener los vídeos
// part -> snippet, proporciona la información que necesitamos.
// maxResults -> número máximo de registros devuelto. El máximo es de 50.
let urlStringYouTube = "https://www.googleapis.com/youtube/v3/playlistItems?part=snippet&maxResults=20&playlistId=PL2C3A82173841E427&key=AIzaSyAB1bIwaCZWF752wuf6FLY4dZLF2foDoow"



class YouTube: NSObject {
    
    static let sharedInstance = YouTube()
        
    func cargarVideos(completion: @escaping ([Video]) -> ()) {
        
        let url = URL(string:urlStringYouTube)!
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        
        let sessionConfiguration = URLSessionConfiguration.default
        
        let session = URLSession(configuration: sessionConfiguration)
        
        session.dataTask(with: request) {
            (data, response, error)  in
            
            guard error == nil else {
                print(error!)
                return
            }
            
            var videos: [Video] = [Video]()
            let json = JSON(data: data!)
                if let items = json["items"].array {
                    
                    for item in items {
                        let video = Video()
                        let thumbnail = Thumbnail()
                        
                        video.videoId   = item["snippet"]["resourceId"]["videoId"].string
                        video.kind      = item["snippet"]["resourceId"]["kind"].string
                        video.title     = item["snippet"]["title"].string
                        video.descriptionVideo = item["snippet"]["description"].string
                        video.publishedAt      = item["snippet"]["publishedAt"].string
                        video.channelTitle     = item["snippet"]["channelTitle"].string
                       
                        thumbnail.url = item["snippet"]["thumbnails"]["high"]["url"].string
                        print("Añadiendo thumbnail: \(thumbnail.url)")
                        thumbnail.width = item["snippet"]["thumbnails"]["high"]["width"].int
                        thumbnail.height = item["snippet"]["thumbnails"]["high"]["height"].int
                        video.thumbnailStandard = thumbnail
                        
                        videos.append(video)
     
                    }
                }
            DispatchQueue.main.async {
                completion(videos)
            }
                
            }.resume()
    }
}
