//
//  UINavigationViewExtension.swift
//  improve
//
//  Created by Denis Bezrukov on 31.08.16.
//  Copyright © 2016 Denis Bezrukov. All rights reserved.
//

import Foundation

extension UINavigationController {
    
    func pushViewController(viewController:UIViewController, animated:Bool, completion:() -> Void) -> Void {
        
        pushViewController(viewController, animated: animated)
        if let coordinator = transitionCoordinator() where animated {
            coordinator.animateAlongsideTransition(nil) { _ in
                completion()
            }
        } else {
            completion()
        }
    }
}
