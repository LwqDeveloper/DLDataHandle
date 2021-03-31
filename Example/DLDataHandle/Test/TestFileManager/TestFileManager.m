//
//  TestFileManager.m
//  DLDataHandle_Example
//
//  Created by jamelee on 2021/3/29.
//  Copyright © 2021 lee_weiqiong@163.com. All rights reserved.
//

#import "TestFileManager.h"
#import <DLDataHandle/DLDataHandle.h>

@implementation TestFileManager

+ (void)testBaseFolder {
    NSLog(@"---------------- testBaseFolder ----------------\n");
    NSLog(@"%@", [DLFileManager getSandboxBaseFolderPath:DLSandboxFolderTypeDocuments]);
    NSLog(@"%@", [DLFileManager getSandboxBaseFolderPath:DLSandboxFolderTypeLibrary]);
    NSLog(@"%@", [DLFileManager getSandboxBaseFolderPath:DLSandboxFolderTypeLibraryCache]);
    NSLog(@"%@", [DLFileManager getSandboxBaseFolderPath:DLSandboxFolderTypeTemp]);
    NSLog(@"---------------- end ----------------\n");
}

+ (void)testCreateFolder {
    NSLog(@"---------------- TestData ----------------\n");
//    NSString *dirName = @"TestData";
//    NSString *fileName = [[DLFileManager getSandboxBaseFolderPath:DLSandboxFolderTypeDocuments] stringByAppendingPathComponent:dirName];
//    BOOL ret = [DLFileManager createDocumentsDirectory:dirName];
//    BOOL exist = [DLFileManager isFileExist:fileName isDirectory:YES];
//    NSLog(@"%@ %@", @(ret), @(exist));
    
    NSArray *dirNames = @[@"TestData0", @"TestData1", @"TestData2"];
    BOOL ret = [DLFileManager createDirectoryNames:dirNames baseType:DLSandboxFolderTypeDocuments];
    NSString *fileName = [[[[DLFileManager getSandboxBaseFolderPath:DLSandboxFolderTypeDocuments] stringByAppendingPathComponent:@"TestData0"] stringByAppendingPathComponent:@"TestData1"] stringByAppendingPathComponent:@"TestData2"];
    BOOL exist = [DLFileManager isFileExist:fileName isDirectory:YES];
    NSLog(@"%@ %@", @(ret), @(exist));
    
    fileName = [fileName stringByAppendingPathComponent:@"test.c"];
    [DLFileManager createFile:fileName isDirectory:NO];
    NSLog(@"---------------- end ----------------\n");
}

+ (void)testFolderSize {
    NSLog(@"---------------- TestData ----------------\n");
    NSString *dirName = @"TestData0";
    NSString *fileName = [[DLFileManager getSandboxBaseFolderPath:DLSandboxFolderTypeDocuments] stringByAppendingPathComponent:dirName];
    float size = [DLFileManager sizeOfDirectory:fileName];
    NSLog(@"fileName:%@ size:%@", fileName, @(size));
    NSLog(@"---------------- end ----------------\n");
}

@end
