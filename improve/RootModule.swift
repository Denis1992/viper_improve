//
//  RootModuleInitializer.swift
//  improve
//
//  Created by Denis Bezrukov on 23.08.16.
//  Copyright © 2016 Denis Bezrukov. All rights reserved.
//

import Swinject


class RootModule {
    var view: RootView!
    
    class func initializer() -> RootModule {
        let assembler = try! Assembler(assemblies: [
            RootModuleAssembly()
            ])
        
        return assembler.resolver.resolve(RootModule.self)!
    }
}
