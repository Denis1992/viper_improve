//
//  DatabaseObject.swift
//  improve
//
//  Created by Denis Bezrukov on 12.08.16.
//  Copyright © 2016 Denis Bezrukov. All rights reserved.
//

import Foundation

// MARK: - Initialization -

class ChannelModel:NSObject, NSCoding {
    
    private(set) var channelURL:    String?
    private(set) var date:          NSDate?
    private(set) var info:          String?
    private(set) var link:          String?
    private(set) var title:         String?
    
    
    init(ChannelURL _channelURL:String?=nil, Info _info:String?=nil,
                    Link _link:String?=nil, Title _title:String?=nil) {
        
        super.init()
        channelURL  = _channelURL
        date        = NSDate()
        info        = _info
        link        = _link
        title       = _title
    }
    
    required init(coder aDecoder: NSCoder) {
        
        channelURL  = aDecoder.decodeObjectForKey("channelURL") as? String
        date        = aDecoder.decodeObjectForKey("date")       as? NSDate
        info        = aDecoder.decodeObjectForKey("info")       as? String
        link        = aDecoder.decodeObjectForKey("link")       as? String
        title       = aDecoder.decodeObjectForKey("title")      as? String
    }
    
    func encodeWithCoder(aCoder: NSCoder) {
        
        if channelURL != nil    { aCoder.encodeObject(channelURL!,  forKey:"channelURL") }
        if date != nil          { aCoder.encodeObject(date!,        forKey:"date") }
        if info != nil          { aCoder.encodeObject(info!,        forKey:"info") }
        if link != nil          { aCoder.encodeObject(link!,        forKey:"link") }
        if title != nil         { aCoder.encodeObject(title!,       forKey:"title") }
    }
}

extension ChannelModel: NSCopying {
    
    func copyWithZone(zone: NSZone) -> AnyObject
    {
        return ChannelModel(ChannelURL: self.channelURL, Info: self.info, Link: self.link, Title: self.title)
    }
}

// MARK: - Key -

extension ChannelModel:Key {
    
    var key:String {
        get {
            return channelURL ?? ""
        }
    }
}

