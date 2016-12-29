//
//  ChannelRouter.swift
//  improve
//
//  Created by Denis Bezrukov on 01.09.16.
//  Copyright © 2016 Denis Bezrukov. All rights reserved.
//

import Foundation

class ChannelRouter {
    weak var view :  ChannelViewInput?
}

extension ChannelRouter: ChannelRouterInput {
    func openInfo(WithUrl url:NSURL) {
        RootPresenter.rootPresenter()?.presentController(WithUrl: url)
    }
    func openInfo(WithObject object:ItemModel) {
        let infoModule = InfoModule.initializer(WithItemObject: object)
        RootPresenter.rootPresenter()?.navigationPushNext(infoModule.view)
    }
}
