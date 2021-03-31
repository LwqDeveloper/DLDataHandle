//
//  TestUserDefaults.h
//  DLDataHandle_Example
//
//  Created by jamelee on 2021/3/31.
//  Copyright © 2021 lee_weiqiong@163.com. All rights reserved.
//

#import <DLDataHandle/DLDataHandle.h>

NS_ASSUME_NONNULL_BEGIN

@interface TestUserDefaults : DLUserDefaultsModel

/// na
@property (nonatomic, strong) NSString *name;
/// ag
@property (nonatomic, assign) NSInteger age;
/// he
@property (nonatomic, assign) float height;

@end

NS_ASSUME_NONNULL_END
