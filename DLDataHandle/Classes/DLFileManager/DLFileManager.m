//
//  DLFileManager.m
//  DLDataHandle_Example
//
//  Created by jamelee on 2021/3/29.
//  Copyright © 2021 lee_weiqiong@163.com. All rights reserved.
//

#import "DLFileManager.h"

@implementation DLFileManager

/// 获取沙盒目录下基类件夹路劲
+ (NSString *)getSandboxBaseFolderPath:(DLSandboxFolderType)folderType {
    NSArray *paths;
    switch (folderType) {
        case DLSandboxFolderTypeDocuments:
        {
            paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        }
            break;
        case DLSandboxFolderTypeLibrary:
        {
            paths = NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES);
        }
            break;
        case DLSandboxFolderTypeLibraryCache:
        {
            paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
        }
            break;
        case DLSandboxFolderTypeTemp:
        {
            paths = @[NSTemporaryDirectory()];
        }
            break;
        default:
            break;
    }
    return paths.firstObject;
}

/// 文件/文件夹是否存在
+ (BOOL)isFileExist:(NSString *)path isDirectory:(BOOL)isDirectory {
    if (!path || path.length == 0) {
        return NO;
    }
    return [[NSFileManager defaultManager] fileExistsAtPath:path isDirectory:&isDirectory];
}

/// 创建文件/文件夹
+ (BOOL)createFile:(NSString *)path isDirectory:(BOOL)isDirectory {
    if (!path || path.length == 0) {
        return NO;
    }
    if  (![self isFileExist:path isDirectory:isDirectory]) {
        BOOL res;
        if (isDirectory) {
            res = [[NSFileManager defaultManager] createDirectoryAtPath:path withIntermediateDirectories:YES attributes:nil error:nil];
        } else {
            res = [[NSFileManager defaultManager] createFileAtPath:path contents:nil attributes:nil];
        }
        return res;
    } else return YES;
}

/// 创建文件夹
+ (BOOL)createDocumentsDirectory:(NSString *)dirName {
    if (!dirName || dirName.length == 0) {
        return NO;
    }
    NSString *documentsDirectory = [self getSandboxBaseFolderPath:DLSandboxFolderTypeDocuments];
    NSString *path = [documentsDirectory stringByAppendingPathComponent:dirName];
    return [self createFile:path isDirectory:YES];
}

+ (BOOL)createDirectoryNames:(NSArray *)dirNames baseType:(DLSandboxFolderType)baseType {
    if (dirNames.count == 0) {
        return NO;
    }
    NSString *folderPath = [self getSandboxBaseFolderPath:baseType];
    for (NSString *dirName in dirNames) {
        folderPath = [folderPath stringByAppendingPathComponent:dirName];
        BOOL ret = [self createFile:folderPath isDirectory:YES];
        if (!ret) {
            return ret;
        }
    }
    return YES;
}

/// 删除文件
+ (BOOL)deleteFilePath:(NSString *)filePath {
    if (!filePath || filePath.length == 0) {
        return NO;
    }
    NSError *error;
    BOOL ret = [[NSFileManager defaultManager] removeItemAtPath:filePath error:&error];
    if (!ret) {
        NSLog(@"删除文件错误：%@", error);
    }
    return ret;
}

/// 获取文件及目录的大小
+ (float)sizeOfDirectory:(NSString *)dirPath {
    NSDirectoryEnumerator *direnum = [[NSFileManager defaultManager] enumeratorAtPath:dirPath];
    NSString *pname;
    int64_t s = 0;
    while (pname = [direnum nextObject]){
        //NSLog(@"pname   %@",pname);
        NSDictionary *currentdict = [direnum fileAttributes];
        NSString *filesize = [NSString stringWithFormat:@"%@",[currentdict objectForKey:NSFileSize]];
        NSString *filetype = [currentdict objectForKey:NSFileType];
        
        if ([filetype isEqualToString:NSFileTypeDirectory]) continue;
        s = s+[filesize longLongValue];
    }
    return s*1.0;
}

/// 文件属性
+ (NSDictionary *)fileAttributes:(NSString *)filePath {
    if (!filePath || filePath.length == 0) {
        return nil;
    }
    if ([self isFileExist:filePath isDirectory:NO]) {
        NSError *error;
        NSDictionary *info = [[NSFileManager defaultManager] attributesOfItemAtPath:filePath error:&error];
        if (error) {
            NSLog(@"query file attributes error:%@", error);
        } else {
            return info;
        }
    }
    return nil;
}

/// 根据路径复制文件
+ (BOOL)copyFile:(NSString *)filePath toPath:(NSString *)toPath {
    if (!filePath || filePath.length == 0) {
        NSLog(@"filePath不能为空");
        return NO;
    }
    if (!toPath || toPath.length == 0) {
        NSLog(@"toPath不能为空");
        return NO;
    }
    BOOL result = NO;
    NSError * error = nil;
    result = [[NSFileManager defaultManager] copyItemAtPath:filePath toPath:toPath error:&error];
    if (error) {
        NSLog(@"copy失败：%@",error);
    }
    return result;
}

/// 写数据到文件
- (BOOL)writeFile:(NSString *)path {
    NSString *testPath = [path stringByAppendingPathComponent:@"test.c"];
    NSString *content=@"将数据写入到文件！";
    BOOL res=[content writeToFile:testPath atomically:YES encoding:NSUTF8StringEncoding error:nil];
    return res;
}

@end
