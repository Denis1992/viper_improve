//
//  RootPresenter.swift
//  improve
//
//  Created by Denis Bezrukov on 24.08.16.
//  Copyright © 2016 Denis Bezrukov. All rights reserved.
//

import Foundation


class RootPresenter {
    
    weak var view: RootViewInput!
    var interactor: RootInteractorInput!
    var router: RootRouterInput!

}


extension RootPresenter: RootViewOutput {

    func didLoadView() {
        interactor?.requestInitial()
        router?.presentSelect()
    }
}

extension RootPresenter: RootInteractorOutput {
    
}


extension RootPresenter: RootModuleInput {
    func presentController(controller:UIViewController, Animated animated:Bool, Completion completionBlock:() -> Void) {
        router.presentController(controller, Animated: animated, Completion: completionBlock)
    }
    func presentController(WithUrl url:NSURL) {
        router.presentController(WithUrl: url)
    }
    func navigationPushNext(controller:UIViewController) {
        router.navigationPushNext(controller)
    }
}

extension RootPresenter {
    class func rootPresenter() -> RootModuleInput? {
        guard let delegate = UIApplication.sharedApplication().delegate as? AppDelegate else { return nil }
        guard let rootNavigation = delegate.window?.rootViewController as? RootView else { return nil }
        return rootNavigation.output as? RootModuleInput
    }
}
