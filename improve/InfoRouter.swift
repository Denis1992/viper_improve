//
//  InfoRouter.swift
//  improve
//
//  Created by Denis Bezrukov on 01.09.16.
//  Copyright © 2016 Denis Bezrukov. All rights reserved.
//

import Foundation


class InfoRouter {
    weak var view : InfoView?
}


extension InfoRouter: InfoRouterInput {
    
    func openInBrowser(WithUrl url: NSURL) {
        RootPresenter.rootPresenter()?.presentController(WithUrl: url)
    }
}
