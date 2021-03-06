//
//  MenuViewController.swift
//  CNBlogsClient
//
//  Created by 王焕强 on 15/5/31.
//  Copyright (c) 2015年 &#29579;&#28949;&#24378;. All rights reserved.
//

import UIKit

class MenuViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    @IBOutlet weak var MenuTableView: UITableView!
    @IBOutlet weak var bloggerIcon: UIImageView!
    @IBOutlet weak var bloggerName: UILabel!
    
    var menuViewModel: MenuViewModel = MenuViewModel()

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.bloggerIcon.layer.masksToBounds = true
        self.bloggerIcon.layer.cornerRadius = 15
        self.MenuTableView.clearTableFooterView()
    }
    
    override func viewWillAppear(animated: Bool) {
        self.menuViewModel.bloggerSelf = self.menuViewModel.gainBloggerInfo()
        self.bloggerName.text          = self.menuViewModel.gainBloggerName()
        self.bloggerIcon.image         = self.menuViewModel.gainBloggerIcon()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    // MARK: - TableView 操作
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return menuViewModel.menuKeys.count;
    }
    
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.menuItemsAtSection(section).count
    }
    
    
    func tableView(tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let view = UIView(frame: CGRectMake(0, 0, tableView.frame.size.width, 1))
        
        let topLine:UIView = UIView(frame: CGRectMake(16, 0, self.view.frame.width, 0.3))
        topLine.backgroundColor = UIColor.whiteColor()
        view.addSubview(topLine)
        
        return view
    }
    
    // 设置每一个 section 的标题
    func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = UIView(frame: CGRectMake(0, 0, tableView.frame.size.width, 10))
        view.backgroundColor = UIColor.clearColor()
        
        let label:UILabel = UILabel(frame: CGRectMake(16, 2, 0, 0))
        label.text = menuViewModel.menuKeys[section];
        label.font = UIFont.systemFontOfSize(14);
        label.textColor = UIColor.whiteColor();
        label.backgroundColor = UIColor.clearColor();
        label.sizeToFit()
        view.addSubview(label)
        
        let buttomLine:UIView = UIView(frame: CGRectMake(16, label.frame.height + 7, self.view.frame.width, 0.3))
        buttomLine.backgroundColor = UIColor.whiteColor()
        view.addSubview(buttomLine)

        return view;
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell: UITableViewCell? = tableView.dequeueReusableCellWithIdentifier("MenuTableCell")
        
        self.configurationCellOfIndex(cell!, indexPath: indexPath)
        
        return cell!
    }
    
    
    // MARK: - UITableView Delegate
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        
        // 界面跳转
        let navigationController: UINavigationController = self.frostedViewController.contentViewController as! UINavigationController
        let menuItem:MenuItem = self.menuItemAtIndexPath(indexPath)
        
        navigationController.viewControllers = [menuItem.menuNextVC];
        self.frostedViewController.hideMenuViewController()
    }
    
    //MARK: - 私有方法
    // 设置内容
    func configurationCellOfIndex(cell: UITableViewCell, indexPath:NSIndexPath) {
        let menuItem:MenuItem = self.menuItemAtIndexPath(indexPath)
        
        cell.imageView!.image = UIImage(named: menuItem.menuImageName)
        cell.textLabel!.text = menuItem.menuTitle
    }
    
    // 获取当前单元格对应的菜单信息
    func menuItemsAtSection(section: NSInteger) -> [MenuItem] {
        return menuViewModel.menuItems[menuViewModel.menuKeys[section]]! as [MenuItem]
    }
    
    func menuItemAtIndexPath(indexPath: NSIndexPath) -> MenuItem {
        return self.menuItemsAtSection(indexPath.section)[indexPath.row] as MenuItem
    }
}
