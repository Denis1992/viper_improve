//
//  InfoView.swift
//  improve
//
//  Created by Denis Bezrukov on 14.08.16.
//  Copyright © 2016 Denis Bezrukov. All rights reserved.
//

import UIKit

// MARK: - Initialization -

class InfoView:UIViewController {
    
    @IBOutlet weak var textView:UITextView?
    
    var output:InfoViewOutput?
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        output?.actionViewDidLoad()

    }
}


extension InfoView: InfoViewInput {
    
    func recieve(WithItem item:ItemModel) {
        
        let date = item.dateText ?? ""
        let title = item.title ?? ""
        let text = item.info ?? ""
        textView?.text = "\(date)\n\n\(title)\n\n\(text)"
    }
}

// MARK: - Public Methods -

extension InfoView {
    
    @IBAction func openInBrowser() {
        output?.openInBrowser()
    }
}
