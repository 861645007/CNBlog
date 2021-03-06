//
//  XMLOperation.swift
//  CNBlogsClient
//
//  Created by 王焕强 on 15/6/2.
//  Copyright (c) 2015年 &#29579;&#28949;&#24378;. All rights reserved.
//

import UIKit
import AEXML

let CNBlogDateFormatForApi = "yyyy-MM-dd'T'HH:mm:sszzz"

class XMLOperation: NSObject {
    var xmlElements: [AnyObject] = []
    
    /**
    解析完整 API的 XML 信息（处理 XML 入口）
    
    - parameter xmlData: 网络操作的NSData数据
    
    - returns: OnlineInformation 数组
    */
    func gainXmlInfoLists(xmlData: NSData) -> [AnyObject] {
        xmlElements = []

        do {
            let xmlDoc = try AEXMLDocument(xmlData: xmlData)
            self.gainXmlDoc(xmlDoc)
        } catch _ {
        }
        
        return xmlElements
    }
    
    /**
    开始处理处理整个 XML 格式
    
    - parameter xmlDoc: XML 信息
    */
    func gainXmlDoc(xmlDoc: AEXMLDocument) { }
    
    /**
    获取单个 OnlineInformation 的信息
    
    - parameter newsList: 单个XMl信息组
    
    - returns: 单个 OnlineInformation 的信息
    */
    func gainOnlineInfoElement(infoList: AEXMLElement) -> OnlineInformation {
        return OnlineInformation()
    }
    
    /**
    获取单个的博主信息
    
    - parameter newsList: 单个XML信息组
    
    - returns: 单个的博主信息
    */
    func gainBloggerElement(newsList: AEXMLElement) -> Blogger {
        return Blogger()
    }
}

// 新闻解析类
class NewsXmlOperation: XMLOperation {
    
    override func gainXmlDoc(xmlDoc: AEXMLDocument) {
        let newsLists = xmlDoc.root["entry"].all
        for newsList in newsLists! {
            xmlElements.append(self.gainOnlineInfoElement(newsList))
        }
    }

    override func gainOnlineInfoElement(infoList: AEXMLElement) -> OnlineInformation {
        let onlineInfo: OnlineNews = OnlineNews()
        
        onlineInfo.id      = infoList["id"].stringValue
        onlineInfo.title   = infoList["title"].stringValue
        onlineInfo.summary = infoList["summary"].stringValue
        onlineInfo.diggs   = Int(infoList["diggs"].stringValue)!
        onlineInfo.views   = Int(infoList["views"].stringValue)!
        if infoList["topicIcon"].stringValue.characters.elementsEqual("".characters) {
            onlineInfo.hasIcon = false
        }else {
            onlineInfo.hasIcon = true
            onlineInfo.iconURL = infoList["topicIcon"].stringValue
        }
        onlineInfo.author  = infoList["sourceName"].stringValue
        
        let dateStr: String = infoList["published"].stringValue
        onlineInfo.publishTime =  dateStr.stringToDateWithDateFormat(CNBlogDateFormatForApi)

        return onlineInfo
    }
}

class NewsContentXmlOperation: XMLOperation {
    override func gainXmlDoc(xmlDoc: AEXMLDocument) {
        let newsLists = xmlDoc.root["Content"].all
        for newsList in newsLists! {
            xmlElements.append(self.gainOnlineInfoElement(newsList))
        }
    }
    
    override func gainOnlineInfoElement(infoList: AEXMLElement) -> OnlineInformation {
        let onlineInfo: OnlineInformation = OnlineNews()
        onlineInfo.content = infoList.stringValue
        return onlineInfo
    }
}

// 博客解析类
class BlogXmlOperation: XMLOperation {
    override func gainXmlDoc(xmlDoc: AEXMLDocument) {
        let blogLists = xmlDoc.root["entry"].all
        for blogList in blogLists! {
            xmlElements.append(self.gainOnlineInfoElement(blogList))
        }
    }
    
    override func gainOnlineInfoElement(infoList: AEXMLElement) -> OnlineInformation {
        let onlineInfo: OnlineBlog = OnlineBlog()
        onlineInfo.id          = infoList["id"].stringValue
        onlineInfo.title       = infoList["title"].stringValue
        onlineInfo.summary     = infoList["summary"].stringValue
        onlineInfo.diggs       = Int(infoList["diggs"].stringValue)!
        onlineInfo.views       = Int(infoList["views"].stringValue)!
        onlineInfo.authorUrl   = infoList["author"]["uri"].stringValue
        onlineInfo.author      = infoList["author"]["name"].stringValue

        let dateStr: String    = infoList["published"].stringValue
        onlineInfo.publishTime = dateStr.stringToDateWithDateFormat(CNBlogDateFormatForApi)
        
        return onlineInfo
    }
}

class BlogContentXmlOperation: XMLOperation {
    override func gainXmlDoc(xmlDoc: AEXMLDocument) {
        let blogLists = xmlDoc.root.all
        for blogList in blogLists! {
            xmlElements.append(self.gainOnlineInfoElement(blogList))
        }
    }
    
    override func gainOnlineInfoElement(infoList: AEXMLElement) -> OnlineInformation {
        let onlineInfo: OnlineInformation = OnlineNews()
        onlineInfo.content = infoList.stringValue
        return onlineInfo
    }
}


// 搜索博主网络操作 解析类
class SearchBloggerXmlOperation: XMLOperation {
    override func gainXmlDoc(xmlDoc: AEXMLDocument) {
        let newsLists = xmlDoc.root["entry"].all
        if (newsLists != nil) {
            for newsList in newsLists! {
                xmlElements.append(self.gainBloggerElement(newsList))
            }
        }
    }
    
    override func gainBloggerElement(newsList: AEXMLElement) -> Blogger {
        let blogger: Blogger = Blogger()
        blogger.bloggerId           = newsList["blogapp"].stringValue
        blogger.bloggerIconURL      = newsList["avatar"].stringValue
        blogger.bloggerName         = newsList["title"].stringValue
        blogger.bloggerArticleCount = Int(newsList["postcount"].stringValue)!

        let dateStr: String         = newsList["updated"].stringValue
        blogger.bloggerUpdatedTime  = dateStr.stringToDateWithDateFormat(CNBlogDateFormatForApi)
        return blogger
    }
}
