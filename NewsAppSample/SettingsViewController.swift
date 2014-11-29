//
//  SettingsViewController.swift
//  NewsAppSample
//
//  Created by jun on 2014/11/29.
//  Copyright (c) 2014年 edu.self. All rights reserved.
//

import UIKit

class SettingsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var dataArray: NSArray = NSArray()
    let paddingTop: CGFloat = 20.0
    

    @IBOutlet weak var tableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()

        self.dataArray  = [
            ["title": "あとで見る", "icon": "bookmark_icon.png"],
            ["title": "お知らせ", "icon": "notification_icon.png"],
            ["title": "スタッフリスト", "icon": "people_icon.png"],
        ]
        
        self.tableView.contentInset = UIEdgeInsetsMake(self.paddingTop, 0, 0, 0)
        
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
  

    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        
        return self.dataArray.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell{

//        var cell: UITableViewCell = UITableViewCell(style: UITableViewCellStyle.Subtitle, reuseIdentifier: "Cell")
        var cell:SettingsViewCell = self.tableView.dequeueReusableCellWithIdentifier("cell") as SettingsViewCell
        var rowData = self.dataArray[indexPath.row] as NSDictionary
        var title = rowData["title"] as String
        var image = rowData["icon"] as String
        
        
//        cell.textLabel.text = title

        cell.titleLabel?.text = title
        cell.icon?.image = UIImage(named: image)
        
        return cell
    }
    



    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
