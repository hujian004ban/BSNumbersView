//
//  BSNumbersDataManager.h
//  BSNumbersSample
//
//  Created by 张亚东 on 16/4/6.
//  Copyright © 2016年 blurryssky. All rights reserved.
//

#import <UIKit/UIKit.h>
@class BSNumbersView;

@interface BSNumbersDataManager : NSObject

@property (weak, nonatomic) BSNumbersView *numbersView;

- (void)caculate;
- (void)setupFlatData;

@property (strong, nonatomic, readonly) NSArray<NSString *> *headerFreezeData;
@property (strong, nonatomic, readonly) NSArray<NSString *> *headerSlideData;

@property (strong, nonatomic, readonly) NSArray<NSArray<NSString *> *> *bodyFreezeData;
@property (strong, nonatomic, readonly) NSArray<NSArray<NSString *> *> *bodySlideData;

@property (assign, nonatomic, readonly) CGFloat freezeWidth;
@property (assign, nonatomic, readonly) CGFloat slideWidth;

@property (strong, nonatomic, readonly) NSArray<NSString *> *freezeItemSize;
@property (strong, nonatomic, readonly) NSArray<NSString *> *slideItemSize;


@end
