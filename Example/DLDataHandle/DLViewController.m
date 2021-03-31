//
//  CPDViewController.m
//  PROJECT
//
//  Created by PROJECT_OWNER on TODAYS_DATE.
//  Copyright (c) TODAYS_YEAR PROJECT_OWNER. All rights reserved.
//

#import "DLViewController.h"
#import "TestFileManager.h"
#import "TestUserDefaults.h"

@interface DLViewController ()

/// string
@property (nonatomic, strong) NSMutableString *logString;

@end

@implementation DLViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    [self testUserDefaults];
}

- (void)testFileManager {
    [TestFileManager testBaseFolder];
    [TestFileManager testCreateFolder];
    [TestFileManager testFolderSize];
}

- (void)testUserDefaults {
//    [TestUserDefaults defaultModel].name = @"hello world";
    [TestUserDefaults defaultModel].age = 15;

    NSLog(@"%@", NSHomeDirectory());
//    NSLog(@"%@", [TestUserDefaults defaultModel].name);
}

- (NSMutableString *)logString {
    if (!_logString) {
        _logString = [[NSMutableString alloc] init];
    }
    return _logString;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
