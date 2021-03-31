//
//  DLUserDefaultsModel.m
//  DLDataHandle
//
//  Created by jamelee on 2021/3/31.
//

#import "DLUserDefaultsModel.h"
#import <objc/runtime.h>

@interface DLUserDefaultsModel ()

@property (nonatomic, strong) NSMutableDictionary *properties;

@end

@implementation DLUserDefaultsModel

+ (instancetype)defaultModel {
    static id model = nil;
    static dispatch_once_t once;
    dispatch_once(&once, ^{
        model = [[[self class] alloc] init];
    });
    return model;
}

- (instancetype)init {
    if (self = [super init]) {
        [self exchangeAccessMethods];
    }
    return self;
}

- (void)exchangeAccessMethods {
    unsigned int count = 0;
    objc_property_t *propertyList = class_copyPropertyList([self class], &count);
    for (int index = 0; index < count; index++) {
        objc_property_t property = propertyList[index];
        const char *propertyName = property_getName(property);
        const char *propertyAttributes = property_getAttributes(property);
        
        NSString *getterKey = [NSString stringWithFormat:@"%s", propertyName];
        NSString *setterKey = [NSString stringWithFormat:@"set%@%@:", [[getterKey substringToIndex:1] uppercaseString], [getterKey substringFromIndex:1]];
        if (getterKey && getterKey.length > 0) {
            SEL getterSelector = NSSelectorFromString(getterKey);
            SEL setterSelector = NSSelectorFromString(setterKey);
            self.properties[getterKey] = getterKey;
            self.properties[setterKey] = getterKey;
            
            IMP getterImp = NULL;
            IMP setterImp = NULL;
            // Data type
            char type = propertyAttributes[1];
            if (type == '@') {
                getterImp = (IMP)getObgectValue;
                setterImp = (IMP)setObjectValue;
            }else if (type == 'B') {
                getterImp = (IMP)getBoolValue;
                setterImp = (IMP)setBoolValue;
            } else if (type == 'i') {
                getterImp = (IMP)getIntegerValue;
                setterImp = (IMP)setIntegerValue;
            } else if (type == 'd') {
                getterImp = (IMP)getDoubleValue;
                setterImp = (IMP)setDoubleValue;
            } else if (type == 'f') {
                getterImp = (IMP)getFloatValue;
                setterImp = (IMP)setFloatValue;
            } else if (type == 's' || type == 'l' || type == 'q' || type == 'S' || type == 'I' || type == 'L' || type == 'Q') {
                getterImp = (IMP)getLongValue;
                setterImp = (IMP)setLongValue;
            } else {
                NSLog(@"Warning:Unsupported type ,property = '%@'", getterKey);
                break;
            }
            
            char getterYypes[3] = "v@:";
            getterYypes[0] = type;
            class_addMethod([self class], getterSelector, getterImp, getterYypes);

            char setterTypes[4] = "v@:";
            setterTypes[3] = type;
            class_addMethod([self class], setterSelector, setterImp, setterTypes);
        }
    }
    free(propertyList); // release
}

#pragma mark - setter && getter
- (NSMutableDictionary *)properties {
    if (!_properties) {
        _properties = [NSMutableDictionary dictionary];
    }
    return _properties;
}

// Object
static id getObgectValue(DLUserDefaultsModel *model, SEL sel) {
    return [[NSUserDefaults standardUserDefaults] objectForKey:model.properties[NSStringFromSelector(sel)]];
}

static void setObjectValue(DLUserDefaultsModel *model, SEL sel, id value) {
    if (value) {
        [[NSUserDefaults standardUserDefaults] setObject:value forKey:model.properties[NSStringFromSelector(sel)]];
    } else {
        [[NSUserDefaults standardUserDefaults] removeObjectForKey:model.properties[NSStringFromSelector(sel)]];
    }
    [[NSUserDefaults standardUserDefaults] synchronize];
}

// Bool
static BOOL getBoolValue(DLUserDefaultsModel *model, SEL sel) {
    return [[NSUserDefaults standardUserDefaults] boolForKey:model.properties[NSStringFromSelector(sel)]];
}

static void setBoolValue(DLUserDefaultsModel *model, SEL sel, BOOL value) {
    [[NSUserDefaults standardUserDefaults] setBool:value forKey:model.properties[NSStringFromSelector(sel)]];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

// Integer
static NSInteger getIntegerValue(DLUserDefaultsModel *model, SEL sel) {
    return [[NSUserDefaults standardUserDefaults] integerForKey:model.properties[NSStringFromSelector(sel)]];
}

static void setIntegerValue(DLUserDefaultsModel *model, SEL sel, NSInteger value) {
    [[NSUserDefaults standardUserDefaults] setInteger:value forKey:model.properties[NSStringFromSelector(sel)]];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

// Double
static double getDoubleValue(DLUserDefaultsModel *model, SEL sel) {
    return [[NSUserDefaults standardUserDefaults] doubleForKey:model.properties[NSStringFromSelector(sel)]];
}

static void setDoubleValue(DLUserDefaultsModel *model, SEL sel, double value) {
    [[NSUserDefaults standardUserDefaults] setDouble:value forKey:model.properties[NSStringFromSelector(sel)]];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

// Float
static float getFloatValue(DLUserDefaultsModel *model, SEL sel) {
    return [[NSUserDefaults standardUserDefaults] doubleForKey:model.properties[NSStringFromSelector(sel)]];
}

static void setFloatValue(DLUserDefaultsModel *model, SEL sel, float value) {
    [[NSUserDefaults standardUserDefaults] setFloat:value forKey:model.properties[NSStringFromSelector(sel)]];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

// Long
static long long getLongValue(DLUserDefaultsModel *model, SEL sel) {
    return [[[NSUserDefaults standardUserDefaults] objectForKey:model.properties[NSStringFromSelector(sel)]] longLongValue];
}

static void setLongValue(DLUserDefaultsModel *model, SEL sel, long long value) {
    [[NSUserDefaults standardUserDefaults] setObject:@(value) forKey:model.properties[NSStringFromSelector(sel)]];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

@end
