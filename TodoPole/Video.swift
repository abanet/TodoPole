//
//  Video.swift
//  TodoPole
//
//  Created by Alberto Banet on 12/12/16.
//  Copyright © 2016 Alberto Banet. All rights reserved.
//

import UIKit

class Video: NSObject {
    
    var videoId: String?
    var kind: String?
    var title: String?
    var descriptionVideo: String?
    var numberOfViews: NSNumber?
    var publishedAt: String?
    var channelTitle: String?
    var thumbnailImageName: String?
    var thumbnailStandard: Thumbnail?
    
    var channel: Channel?
    
}

class Channel: NSObject {
    var name: String?
    var profileImageName: String?
}

