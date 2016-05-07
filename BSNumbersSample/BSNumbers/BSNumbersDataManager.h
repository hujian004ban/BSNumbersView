//
//  BSNumbersDataManager.h
//  BSNumbersSample
//
//  Created by 张亚东 on 16/4/6.
//  Copyright © 2016年 blurryssky. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BSNumbersDataManager : NSObject

@property (assign, nonatomic) CGFloat minItemWidth;
@property (assign, nonatomic) CGFloat maxItemWidth;
@property (assign, nonatomic) CGFloat itemHeight;
@property (assign, nonatomic) CGFloat itemTextHorizontalMargin;
@property (assign, nonatomic) NSInteger freezeColumn;
@property (assign, nonatomic) UIFont *headerFont;
@property (assign, nonatomic) UIFont *slideBodyFont;

@property (strong, nonatomic) NSArray<NSString *> *headerData;
@property (strong, nonatomic) NSArray<NSObject *> *bodyData;

- (void)caculate;

@property (strong, nonatomic, readonly) NSArray<NSString *> *headerFreezeCollectionViewFlatData;
@property (strong, nonatomic, readonly) NSArray<NSString *> *headerSlideCollectionViewFlatData;

@property (strong, nonatomic, readonly) NSArray<NSArray<NSString *> *> *freezeCollectionViewFlatData;
@property (strong, nonatomic, readonly) NSArray<NSArray<NSString *> *> *slideCollectionViewFlatData;

@property (assign, nonatomic, readonly) CGFloat freezeCollectionViewWidth;
@property (assign, nonatomic, readonly) CGFloat slideCollectionViewWidth;

@property (strong, nonatomic, readonly) NSArray<NSString *> *freezeCollectionViewColumnsItemSize;
@property (strong, nonatomic, readonly) NSArray<NSString *> *slideCollectionViewColumnsItemSize;

@end
