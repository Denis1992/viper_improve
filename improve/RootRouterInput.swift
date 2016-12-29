//
//  RootRouterInput.swift
//  improve
//
//  Created by Denis Bezrukov on 24.08.16.
//  Copyright © 2016 Denis Bezrukov. All rights reserved.
//

import Foundation

protocol RootRouterInput:class {
    
    func presentSelect()
    func navigationPushNext(controller:UIViewController)
    func presentController(controller:UIViewController, Animated animated:Bool, Completion completionBlock:() -> Void)
    func presentController(WithUrl url:NSURL)
}
