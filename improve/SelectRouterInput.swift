//
//  SelectRouterInput.swift
//  improve
//
//  Created by Denis Bezrukov on 25.08.16.
//  Copyright © 2016 Denis Bezrukov. All rights reserved.
//

import Foundation

protocol SelectRouterInput:class {
    func openDetail(WithChannel channel:ChannelModel, AndExtended extended: Bool)
    func showAlert(WithAlertController controller:UIViewController, Animated animated:Bool, Completion completionBlock:() -> Void)
}
