//
//  RootView.swift
//  improve
//
//  Created by Denis Bezrukov on 24.08.16.
//  Copyright © 2016 Denis Bezrukov. All rights reserved.
//

import UIKit
import AsyncDisplayKit

class RootView: ASNavigationController {
    
    var backgroundColor: UIColor?
    var output: RootViewOutput!
    
    override func loadView() {
        super.loadView()
        output.didLoadView()
    }

    
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        title = "Root"
//        self.view.backgroundColor = backgroundColor
////        debugPrint("RootView viewDidLoad")
//        debugPrint(output)
//        output.didLoadView()
//        // Do any additional setup after loading the view.
//    }
//
//    override func didReceiveMemoryWarning() {
//        super.didReceiveMemoryWarning()
//        // Dispose of any resources that can be recreated.
//    }
    
}


extension RootView: RootViewInput {
    
}
