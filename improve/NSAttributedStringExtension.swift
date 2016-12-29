//
//  NSAttributedStringExtension.swift
//  improve
//
//  Created by Denis Bezrukov on 02.09.16.
//  Copyright © 2016 Denis Bezrukov. All rights reserved.
//

import Foundation


extension NSAttributedString {
    
    class func attributedBoldText(string:String) -> NSAttributedString {
        
        return NSAttributedString.init(string:string, attributes:[NSForegroundColorAttributeName:UIColor.blackColor(),
            NSFontAttributeName:UIFont.boldSystemFontOfSize(10.0)])
    }
    
    class func attributedText(string:String) -> NSAttributedString {
        
        return NSAttributedString.init(string:string, attributes:[NSForegroundColorAttributeName:UIColor.blackColor(),
            NSFontAttributeName:UIFont.systemFontOfSize(10.0)])
    }
}
