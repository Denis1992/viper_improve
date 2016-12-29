//
//  ChannelModule.swift
//  improve
//
//  Created by Denis Bezrukov on 01.09.16.
//  Copyright © 2016 Denis Bezrukov. All rights reserved.
//

import Foundation
import Swinject

class ChannelModule {
    var view: UIViewController!
    
    class func initializer(WithChannelObject channelObject: ChannelModel, AndExtended extended:Bool) -> ChannelModule {
        let assembler = try! Assembler(assemblies: [
            ChannelModuleAssembly(WithChannelObject: channelObject, AndExtended: extended)
            ])
        let module = assembler.resolver.resolve(ChannelModule.self)!
        return module
    }
    
}
