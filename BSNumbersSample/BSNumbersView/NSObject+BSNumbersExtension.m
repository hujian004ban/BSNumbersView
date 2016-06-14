//
//  NSObject+BSNumbersExtension.m
//  BSNumbersSample
//
//  Created by 张亚东 on 16/4/6.
//  Copyright © 2016年 blurryssky. All rights reserved.
//

#import "NSObject+BSNumbersExtension.h"
#import <objc/runtime.h>

@implementation NSObject (BSNumbersExtension)

- (NSArray<NSString *> *)bs_propertyValues {
    
    NSArray<NSString *> *propertyValues = objc_getAssociatedObject(self, @selector(bs_propertyValues));
    if (propertyValues) {
        return propertyValues;
    }
    
    propertyValues = [self getPropertyValues];
    objc_setAssociatedObject(self, @selector(bs_propertyValues), propertyValues, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    return propertyValues;
}

- (NSArray<NSString *> *)getPropertyValues {
    
    unsigned int count;
    objc_property_t *cProperties = class_copyPropertyList(self.class, &count);
    
    NSMutableArray *values = [NSMutableArray array];
    for (NSInteger i = 0; i < count; i++) {
        objc_property_t cProperty = cProperties[i];
        
        const char *cName = property_getName(cProperty);
        
        NSString *name = [NSString stringWithCString:cName encoding:NSUTF8StringEncoding];
        
        [values addObject:[NSString stringWithFormat:@"%@",[self valueForKey:name]]];
    }
    
    return values.copy;
}

@end
