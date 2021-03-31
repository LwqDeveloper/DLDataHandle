//
//  DLFileManager.h
//  DLDataHandle_Example
//
//  Created by jamelee on 2021/3/29.
//  Copyright © 2021 lee_weiqiong@163.com. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger, DLSandboxFolderType) {
    DLSandboxFolderTypeDocuments = 0,
    DLSandboxFolderTypeLibrary,
    DLSandboxFolderTypeLibraryCache,
    DLSandboxFolderTypeTemp
};

@interface DLFileManager : NSObject

/**
 [[NSFilemanager alloc] init] 使用实例保证线程安全
 */
/**
 * 默认情况下，每个沙盒含有3个文件夹：Documents, Library 和 tmp和一个应用程序文件（也是一个文件）。因为应用的沙盒机制，应用只能在几个目录下读写文件
 * Documents：苹果建议将程序中建立的或在程序中浏览到的文件数据保存在该目录下，iTunes备份和恢复的时候会包括此目录
 * Library：存储程序的默认设置或其它状态信息；
 * Library/Caches：存放缓存文件，iTunes不会备份此目录，此目录下文件不会在应用退出删除
 * tmp：提供一个即时创建临时文件的地方。
 * iTunes在与iPhone同步时，备份所有的Documents和Library文件。
 * iPhone在重启时，会丢弃所有的tmp文件。
 */
/// 获取沙盒目录下基类件夹路劲
+ (NSString *)getSandboxBaseFolderPath:(DLSandboxFolderType)folderType;

/// 文件/文件夹是否存在
+ (BOOL)isFileExist:(NSString *)path isDirectory:(BOOL)isDirectory;
/// 创建文件/文件夹
+ (BOOL)createFile:(NSString *)path isDirectory:(BOOL)isDirectory;

/// 创建文件夹
+ (BOOL)createDocumentsDirectory:(NSString *)dirName;
/// 创建文件夹 /test01/test02/test03 -> @[@"test01", @"test02", @"test03"]
+ (BOOL)createDirectoryNames:(NSArray *)dirNames baseType:(DLSandboxFolderType)baseType;

/// 删除文件
+ (BOOL)deleteFilePath:(NSString *)filePath;

/// 获取文件及目录的大小 返回byte数
+ (float)sizeOfDirectory:(NSString *)dirPath;

/// 文件属性
+ (NSDictionary *)fileAttributes:(NSString *)filePath;

/// 根据路径复制文件
+ (BOOL)copyFile:(NSString *)filePath toPath:(NSString *)toPath;

/// 写数据到文件
- (BOOL)writeFile:(NSString *)path;

@end
