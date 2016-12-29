//
//  RootModuleInput.swift
//  improve
//
//  Created by Denis Bezrukov on 26.08.16.
//  Copyright © 2016 Denis Bezrukov. All rights reserved.
//

import Foundation

protocol RootModuleInput:class {
    func presentController(controller:UIViewController, Animated animated:Bool, Completion completionBlock:() -> Void)
    func navigationPushNext(controller:UIViewController)
    func presentController(WithUrl url:NSURL)
}

