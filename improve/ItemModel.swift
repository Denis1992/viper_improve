//
//  ItemModel.swift
//  improve
//
//  Created by Denis Bezrukov on 12.08.16.
//  Copyright © 2016 Denis Bezrukov. All rights reserved.
//

import Foundation
import UIKit

// MARK: - Initialization -

class ItemModel:NSObject, NSCoding {
    
    private static let dateFormatter:NSDateFormatter = {
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        return dateFormatter
    }()
    
    private(set) var channelURL:    String?
    private(set) var date:          NSDate?
    private(set) var info:          String?
    private(set) var link:          String?
    private(set) var title:         String?
    
    init(ChannelURL _channelURL:String?=nil, Date _date:NSDate?=nil,
                    Info _info:String?=nil, Link _link:String?=nil, Title _title:String?=nil) {
        
        super.init()
        channelURL  = _channelURL
        date        = _date
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

extension ItemModel: NSCopying {
    
    func copyWithZone(zone: NSZone) -> AnyObject
    {
        return ItemModel(ChannelURL: self.channelURL, Date: self.date,
                         Info: self.info, Link: self.link, Title: self.title)
    }
}

// MARK: - Public Methods -

extension ItemModel {
    
    var dateText:String? {
        get {
            guard let date = date else { return nil }
            return ItemModel.dateFormatter.stringFromDate(date)
        }
    }
}

// MARK: - Key -

extension ItemModel:Key {
    
    var key:String {
        get {
            return (link ?? "") + (title ?? "")
        }
    }
}
