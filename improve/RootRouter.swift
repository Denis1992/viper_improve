//
//  RootRouter.swift
//  improve
//
//  Created by Denis Bezrukov on 24.08.16.
//  Copyright © 2016 Denis Bezrukov. All rights reserved.
//

import Foundation
import UIKit

class RootRouter {
    weak var view :  RootView?
}


private extension RootRouter {
    
    func navigationPush(controller:UIViewController, RemoveRest remove:Bool, Animated animate:Bool) {
        guard let navigation = view else { return }
        UIApplication.sharedApplication().beginIgnoringInteractionEvents()
        navigation.pushViewController(controller, animated:animate, completion: { [weak navigation] in
            defer { UIApplication.sharedApplication().endIgnoringInteractionEvents() }
            guard let navigationStrong = navigation else { return }
            guard remove == true else { return }
            navigationStrong.viewControllers = [navigationStrong.viewControllers.last!]
            }
        )
    }
    
}

extension RootRouter: RootRouterInput {
    
    func presentSelect() {
        let selecModule = SelectModule.initializer()
        navigationPush(selecModule.view, RemoveRest: true, Animated: false)
    }
    
    func navigationPushNext(controller:UIViewController) {
        self.navigationPush(controller, RemoveRest: false, Animated: true)
    }
    
    func presentController(controller:UIViewController, Animated animated:Bool,
                           Completion completionBlock:() -> Void) {
        guard let rootView = self.view else { return }
        UIApplication.sharedApplication().beginIgnoringInteractionEvents()
        func presentView(rootView:UIViewController?) {
            guard rootView != nil else {
                UIApplication.sharedApplication().endIgnoringInteractionEvents()
                return
            }
            rootView!.presentViewController(controller, animated: animated) {
                UIApplication.sharedApplication().endIgnoringInteractionEvents()
                completionBlock()
            }
        }
        if rootView.presentedViewController != nil {
            rootView.dismissViewControllerAnimated(animated, completion: { [weak rootView] in
                presentView(rootView) })
        } else {
            presentView(rootView)
        }
    }
    func presentController(WithUrl url:NSURL) {
        guard UIApplication.sharedApplication().canOpenURL(url) else { return }
        UIApplication.sharedApplication().openURL(url)
    }
}


