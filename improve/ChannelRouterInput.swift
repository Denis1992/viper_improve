//
//  ChannelRouterInput.swift
//  improve
//
//  Created by Denis Bezrukov on 01.09.16.
//  Copyright © 2016 Denis Bezrukov. All rights reserved.
//

import Foundation

protocol ChannelRouterInput {
    func openInfo(WithUrl url:NSURL)
    func openInfo(WithObject object:ItemModel)
}
