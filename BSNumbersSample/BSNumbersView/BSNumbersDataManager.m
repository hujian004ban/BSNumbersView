//
//  BSNumbersDataManager.m
//  BSNumbersSample
//
//  Created by 张亚东 on 16/4/6.
//  Copyright © 2016年 blurryssky. All rights reserved.
//

#import "BSNumbersDataManager.h"
#import "BSNumbersView.h"
#import "NSObject+BSNumbersExtension.h"
#import "NSString+BSNumbersExtension.h"
@interface BSNumbersDataManager ()

@property (strong, nonatomic) NSArray<NSArray<NSString *> *> *flatData;

- (void)setupFlatData;
- (void)configureData;
- (void)caculateWidths;

@end

@implementation BSNumbersDataManager

#pragma mark - Private

- (void)setupFlatData {
    NSMutableArray *flatData = @[].mutableCopy;
    if (self.numbersView.headerData) {
        [flatData addObject:self.numbersView.headerData];
    }
    if (self.numbersView.bodyData) {
        for (NSObject *bodyData in self.numbersView.bodyData) {
            [flatData addObject:bodyData.bs_propertyValues];
        }
    }
    self.flatData = flatData.copy;
}

- (void)configureData {
    NSMutableArray *freezeData = @[].mutableCopy;
    NSMutableArray *slideData = @[].mutableCopy;
    
    for (NSInteger i = 0; i < self.flatData.count; i ++) {
        
        NSMutableArray *freezeCollectionViewSectionFlatData = @[].mutableCopy;
        NSMutableArray *slideCollectionViewSectionFlatData = @[].mutableCopy;
        
        NSArray<NSString *> *flatData = self.flatData[i];
        
        for (NSInteger j = 0; j < flatData.count; j ++) {
            
            NSString *value = flatData[j];
            
            if (j < self.numbersView.freezeColumn) {
                [freezeCollectionViewSectionFlatData addObject:value];
            } else {
                [slideCollectionViewSectionFlatData addObject:value];
            }
        }
        [freezeData addObject:freezeCollectionViewSectionFlatData];
        [slideData addObject:slideCollectionViewSectionFlatData];
    }
    
    if (self.numbersView.headerData) {
        _headerFreezeData = freezeData.firstObject;
        _headerSlideData = slideData.firstObject;
        
        _bodyFreezeData = [freezeData subarrayWithRange:NSMakeRange(1, freezeData.count - 1)];
        _bodySlideData = [slideData subarrayWithRange:NSMakeRange(1, slideData.count - 1)];
    } else {
        _bodyFreezeData = freezeData.copy;
        _bodySlideData = slideData.copy;
    }
}

- (void)caculateWidths {
    NSMutableArray<NSString *> *freezeItemSize = @[].mutableCopy;
    NSMutableArray<NSString *> *slideItemSize = @[].mutableCopy;

    _freezeWidth = 0;
    _slideWidth = 0;
    
    NSInteger columnsCount = self.flatData.firstObject.count;
    
    //遍历列
    for (NSInteger i = 0; i < columnsCount; i ++) {
        
        CGFloat columnMaxWidth = 0;
        
        //遍历行
        for (NSInteger j = 0; j < self.flatData.count; j ++) {
            
            NSString *value = self.flatData[j][i];
            
            CGSize size = [value bs_sizeWithFont:self.numbersView.slideBodyFont constraint:CGSizeMake(self.numbersView.itemMaxWidth, self.numbersView.itemHeight)];
            if (j == 0) {
                size = [value bs_sizeWithFont:self.numbersView.headerFont constraint:CGSizeMake(self.numbersView.itemMaxWidth, self.numbersView.itemHeight)];
            }
            
            CGFloat targetWidth = size.width + 2 * self.numbersView.horizontalItemTextMargin;
            
            if (targetWidth >= columnMaxWidth) {
                columnMaxWidth = targetWidth;
            }
            
            columnMaxWidth = ceil(MAX(self.numbersView.itemMinWidth, MIN(self.numbersView.itemMaxWidth, columnMaxWidth)));
        }
        
        if (i < self.numbersView.freezeColumn) {
            [freezeItemSize addObject:NSStringFromCGSize(CGSizeMake(columnMaxWidth, self.numbersView.itemHeight - 1))];
            _freezeWidth += columnMaxWidth;
        } else {
            [slideItemSize addObject:NSStringFromCGSize(CGSizeMake(columnMaxWidth, self.numbersView.itemHeight - 1))];
            _slideWidth += columnMaxWidth;
        }
    }
    
    _freezeItemSize = freezeItemSize.copy;
    _slideItemSize = slideItemSize.copy;
}

#pragma mark - Public

- (void)caculate {
    [self setupFlatData];
    [self configureData];
    [self caculateWidths];
}

@end
