//
//  ChannelView.swift
//  improve
//
//  Created by Denis Bezrukov on 01.09.16.
//  Copyright © 2016 Denis Bezrukov. All rights reserved.
//

import Foundation
import UIKit

// MARK: - Initialization -

class ChannelView:UITableViewController {
    
    var output:ChannelViewOutput?
    
    convenience init(Extended extended:Bool) {
        self.init(style: .Grouped)
        tableView.estimatedRowHeight = 50.0
        tableView.rowHeight = UITableViewAutomaticDimension
        title = "Новости"
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.registerNib(UINib.init(nibName:"NormalViewCell", bundle:nil), forCellReuseIdentifier:"NormalViewCell")
    }
}

// MARK: - UITableViewDelegate, UITableViewDataSource -

extension ChannelView {
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        
        var sections:Int = 1
        output?.requireSections(&sections)
        return sections
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        var rows:Int = 5
        output?.requireRows(&rows, ForSection:section)
        return rows
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCellWithIdentifier("NormalViewCell", forIndexPath:indexPath) as? NormalViewCell else { return UITableViewCell() }
        cell.labelText?.numberOfLines = 0
        cell.labelTitle?.numberOfLines = 0
        var object:ItemModel = ItemModel()
        output?.requireObject(&object, ForIndexPath:indexPath)
        cell.labelTitle?.text = object.title
        cell.labelText?.text = object.info
        cell.labelDate?.text = object.dateText
        return cell
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        output?.selectItem(AtIndexPath: indexPath)
    }
    
    override func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        
        var title:String = ""
        output?.requireTitleForHeader(&title, InSection: section)
        return title

    }
}


extension ChannelView: ChannelViewInput {
    
    func actionDataUpdated(updates:DataUpdates?) {
        guard let updates = updates else { return }
        tableView.beginUpdates()
        for set in updates.sections.delete { tableView.deleteSections(set, withRowAnimation:.Fade) }
        for set in updates.sections.insert { tableView.insertSections(set, withRowAnimation:.Fade) }
        if updates.rows.delete.count > 0 { tableView.deleteRowsAtIndexPaths(updates.rows.delete, withRowAnimation:.Fade) }
        if updates.rows.insert.count > 0 { tableView.insertRowsAtIndexPaths(updates.rows.insert, withRowAnimation:.Fade) }
        if updates.rows.reload.count > 0 { tableView.reloadRowsAtIndexPaths(updates.rows.reload, withRowAnimation:.Fade) }
        tableView.endUpdates()
    }
}

   
