//
//  MenuViewModel.swift
//  CNBlogsClient
//
//  Created by 王焕强 on 15/5/31.
//  Copyright (c) 2015年 &#29579;&#28949;&#24378;. All rights reserved.
//

import UIKit

class MenuItem {
    var menuImageName:String = ""
    var menuTitle:String = ""
    var menuNextVC:UIViewController = UIViewController()
    
    init(imageName: String, title: String) {
        self.menuImageName = imageName
        self.menuTitle     = title
    }
}

class MenuViewModel: NSObject {
    var menuViewController: MenuViewController!
    var menuKeys = ["推荐阅读", "我的资讯", "设置"]
    var menuItems:Dictionary<String, [MenuItem]>!
    
    var bloggerSelf: Blogger?
    
    override init() {
        super.init()
        
        self.setMenuItem()
        self.bloggerSelf = self.gainBloggerInfo()
    }
    
    // 设置菜单项
    func setMenuItem() {
        var newsItem        = MenuItem(imageName: "menuNews", title: "最新新闻")
        newsItem.menuNextVC = self.gainVCInStoryBoard("NewsViewController") as! NewsViewController
        
        var blogItem        = MenuItem(imageName: "menuBlog", title: "热门博客")
        blogItem.menuNextVC = self.gainVCInStoryBoard("BlogViewController") as! BlogViewController
        
        var myBlogItem      = MenuItem(imageName: "menuMyBlog", title: "我的博客")
        var myAttentionItem = MenuItem(imageName: "menuMyAttention", title: "我的关注人")
        myAttentionItem.menuNextVC = self.gainVCInStoryBoard("MyAttentionerViewController") as! MyAttentionerViewController
        
        var myOfflineInfo   = MenuItem(imageName: "menuMyOffline", title: "我的离线")
        myOfflineInfo.menuNextVC = self.gainVCInStoryBoard("OfflineInfoViewController") as! OfflineInfoViewController
        
        var settingItem     = MenuItem(imageName: "menuSetting", title: "设置")
        settingItem.menuNextVC = self.gainVCInStoryBoard("SettingTableViewController") as! SettingTableViewController
        
        menuItems = ["推荐阅读": [newsItem, blogItem],
            "我的资讯": [myBlogItem, myAttentionItem, myOfflineInfo],
            "设置": [settingItem]];
    }
    
    // 获取主StoryBoard里的视图
    func gainVCInStoryBoard(vcId: String) -> UIViewController {
        return UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier(vcId) as! UIViewController
    }
    
    // 获取博主数据
    func gainBloggerInfo() ->Blogger {
        var blogger: Blogger = BloggerOwned()
        if blogger.isLoginSelf() {
            blogger = blogger.gainBloggerSelfInfo()
        }
        return blogger
    }
    
    // 获取博主名称
    
    // 获取博主头像
}
