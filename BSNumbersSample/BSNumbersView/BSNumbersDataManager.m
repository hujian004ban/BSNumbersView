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

- (void)configureData;
- (void)caculateWidths;

@end

@implementation BSNumbersDataManager

#pragma mark - Override


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
    NSMutableArray *bodyFreezeData = @[].mutableCopy;
    NSMutableArray *bodySlideData = @[].mutableCopy;
    
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
        [bodyFreezeData addObject:freezeCollectionViewSectionFlatData];
        [bodySlideData addObject:slideCollectionViewSectionFlatData];
        
    }
    
    if (self.numbersView.headerData) {
        _headerFreezeData = bodyFreezeData.firstObject;
        _headerSlideData = bodySlideData.firstObject;
        
        _bodyFreezeData = [bodyFreezeData subarrayWithRange:NSMakeRange(1, bodyFreezeData.count - 1)];
        _bodySlideData = [bodySlideData subarrayWithRange:NSMakeRange(1, bodyFreezeData.count - 1)];
    } else {
        _bodyFreezeData = bodyFreezeData.copy;
        _bodySlideData = bodySlideData.copy;
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
            
            NSString *columnValue = self.flatData[j][i];
            
            CGSize size = [columnValue bs_sizeWithFont:self.numbersView.slideBodyFont constraint:CGSizeMake(self.numbersView.itemMaxWidth, self.numbersView.itemHeight)];
            if (j == 0) {
                size = [columnValue bs_sizeWithFont:self.numbersView.headerFont constraint:CGSizeMake(self.numbersView.itemMaxWidth, self.numbersView.itemHeight)];
            }
            
            CGFloat targetWidth = size.width + 2 * self.numbersView.horizontalItemTextMargin;
            
            if (targetWidth >= columnMaxWidth) {
                columnMaxWidth = targetWidth;
            }
            
            columnMaxWidth = floor(MAX(self.numbersView.itemMinWidth, MIN(self.numbersView.itemMaxWidth, columnMaxWidth)));
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
    [self configureData];
    [self caculateWidths];
}

@end
