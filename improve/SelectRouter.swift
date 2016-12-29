//
//  SelectRouter.swift
//  improve
//
//  Created by Denis Bezrukov on 25.08.16.
//  Copyright © 2016 Denis Bezrukov. All rights reserved.
//

import Foundation


class SelectRouter {
    weak var view :  SelectView?
}

extension SelectRouter: SelectRouterInput {
    
    func openDetail(WithChannel channel: ChannelModel, AndExtended extended: Bool) {
        let channelModule = ChannelModule.initializer(WithChannelObject: channel, AndExtended: extended)
        RootPresenter.rootPresenter()?.navigationPushNext(channelModule.view)
    }
    func showAlert(WithAlertController controller:UIViewController, Animated animated:Bool, Completion completionBlock:() -> Void) {
        RootPresenter.rootPresenter()?.presentController(controller, Animated: animated, Completion: completionBlock)
    }
    
}
