//
//  Delay.swift
//  improve
//
//  Created by Denis Bezrukov on 13.08.16.
//  Copyright © 2016 Denis Bezrukov. All rights reserved.
//

import Foundation

protocol Delay {
    
    func performWithDelay(delay:Double, queue:dispatch_queue_t, @autoclosure(escaping) closure:() -> Void) -> Void
}

extension Delay {
    
    func performWithDelay(delay:Double, queue:dispatch_queue_t, @autoclosure(escaping) closure:() -> Void) {
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, Int64(delay * Double(NSEC_PER_SEC))), queue, closure)
    }
}
