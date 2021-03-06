//
//  FolderOperation.swift
//  CNBlogsClient
//
//  Created by 王焕强 on 15/6/5.
//  Copyright (c) 2015年 &#29579;&#28949;&#24378;. All rights reserved.
//

import UIKit

/**
*  在Documents文件夹下的操作子文件夹
*/
class FolderOperation: NSObject {
   
    func gainDocumentPath() -> String {
        return (NSHomeDirectory() as NSString).stringByAppendingPathComponent("Documents")
    }
    
    func gainFolderPath(folderName: String) -> String {
        return (self.gainDocumentPath() as NSString).stringByAppendingPathComponent(folderName)
    }
    
    // *********** 文件操作 **********
    
    func gainImageFromFolder(folderName: String, imageName: String) -> UIImage {
        let folderPath: String = self.gainFolderPath(folderName)
        // 这里不能加 .png 后缀，因为之前在存的时候就是直接存在url 的lastPathComponent
        let imagePath: String = folderPath.stringByAppendingString("/\(imageName)")

        return UIImage(contentsOfFile: imagePath)!
    }
    
    /**
    保存图片
    
    - parameter folderName: 文件夹名称
    - parameter imageData:  图片数据
    - parameter imageName:  图片名
    
    - returns: 图片路径
    */
    func saveImageToFolder(folderName: String, image: UIImage, imageName: String) -> String{
        // 将图片转化成data
        let imageData = UIImagePNGRepresentation(image)
        // 设置目录
        let folderPath: String = self.gainFolderPath(folderName)
        let imagePath: String = folderPath.stringByAppendingString("/\(imageName)")
        // 创建图片操作器
        let fileManager: NSFileManager = NSFileManager.defaultManager()
        //把刚刚图片转换的data对象保存至沙盒中
        fileManager.createFileAtPath(imagePath, contents: imageData, attributes: nil)
        return imagePath
    }
    
    
    // ***********  文件夹操作 *********
    /**
    先判断一个指定文件夹存不存在，如果不存在就创建它
    
    - parameter folderName: folderName 文件夹名称
    */
    func createFolderWhenNon(folderName: String) {
        if !self.isExitsWithTheFolder(folderName) {
            self.createFolderInDocuments(folderName)
        }
    }
    
    /**
    创建指定文件夹(单层）
    
    - parameter folderName: 文件夹名称
    */
    func createFolderInDocuments(folderName: String) {
        let path: String = self.gainFolderPath(folderName)
        let bo: Bool
        do {
            try NSFileManager.defaultManager().createDirectoryAtPath(path, withIntermediateDirectories: true, attributes: nil)
            bo = true
        } catch _ {
            bo = false
        }
        assert(bo, "创建文件夹失败")
    }

    
    /**
    判断在Documents文件夹下是否存在指定文件夹
    
    - parameter folderName: 文件夹名称
    
    - returns: 存在返回ture；不存在返回false
    */
    func isExitsWithTheFolder(folderName: String) -> Bool {
        let path: String = self.gainFolderPath(folderName)
        return NSFileManager.defaultManager().fileExistsAtPath(path)
    }

    /**
    删除指定文件夹下的所有文件
    
    - parameter folderName: 文件夹名称
    */
    func removeFileInTheFolder(folderName: String) {
        let path: String = self.gainFolderPath(folderName)
        
        let fileManager: NSFileManager = NSFileManager.defaultManager()
        let contents: NSArray = try! fileManager.contentsOfDirectoryAtPath(path)
        let enumerator: NSEnumerator = contents.objectEnumerator()
        
        var fileName: AnyObject? = enumerator.nextObject()
        while ((fileName) != nil) {
            do {
                try fileManager.removeItemAtPath((path as NSString).stringByAppendingPathComponent(fileName as! String))
            } catch _ {
            }
            fileName = enumerator.nextObject()
        }
    }

}
