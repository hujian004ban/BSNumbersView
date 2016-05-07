//
//  BSNumbersDataManager.m
//  BSNumbersSample
//
//  Created by 张亚东 on 16/4/6.
//  Copyright © 2016年 blurryssky. All rights reserved.
//

#import "BSNumbersDataManager.h"
#import "NSObject+BSNumbersExtension.h"
#import "NSString+BSNumbersExtension.h"
@interface BSNumbersDataManager ()

@property (strong, nonatomic) NSArray<NSArray<NSString *> *> *flatData;

- (void)setupFlatData;

- (void)configureFlatData;
- (void)caculateWidths;

@end

@implementation BSNumbersDataManager

#pragma mark - Override


#pragma mark - Private

- (void)setupFlatData {
    NSMutableArray *flatData = @[].mutableCopy;
    if (self.headerData) {
        [flatData addObject:self.headerData];
    }
    if (self.bodyData) {
        for (NSObject *bodyData in self.bodyData) {
            [flatData addObject:[bodyData getPropertiesValues]];
        }
    }
    self.flatData = flatData.copy;
}

- (void)configureFlatData {
    NSMutableArray *freezeCollectionViewFlatData = @[].mutableCopy;
    NSMutableArray *slideCollectionViewFlatData = @[].mutableCopy;
    
    for (NSInteger i = 0; i < self.flatData.count; i ++) {
        
        NSMutableArray *freezeCollectionViewSectionFlatData = @[].mutableCopy;
        NSMutableArray *slideCollectionViewSectionFlatData = @[].mutableCopy;
        
        NSArray<NSString *> *flatData = self.flatData[i];
        
        for (NSInteger j = 0; j < flatData.count; j ++) {
            
            NSString *value = flatData[j];
            
            if (j < self.freezeColumn) {
                [freezeCollectionViewSectionFlatData addObject:value];
            } else {
                [slideCollectionViewSectionFlatData addObject:value];
            }
        }
        [freezeCollectionViewFlatData addObject:freezeCollectionViewSectionFlatData];
        [slideCollectionViewFlatData addObject:slideCollectionViewSectionFlatData];
        
    }
    
    if (self.headerData) {
        _headerFreezeCollectionViewFlatData = freezeCollectionViewFlatData.firstObject;
        _headerSlideCollectionViewFlatData = slideCollectionViewFlatData.firstObject;
        
        _freezeCollectionViewFlatData = [freezeCollectionViewFlatData subarrayWithRange:NSMakeRange(1, freezeCollectionViewFlatData.count - 1)];
        _slideCollectionViewFlatData = [slideCollectionViewFlatData subarrayWithRange:NSMakeRange(1, freezeCollectionViewFlatData.count - 1)];
    } else {
        _freezeCollectionViewFlatData = freezeCollectionViewFlatData.copy;
        _slideCollectionViewFlatData = slideCollectionViewFlatData.copy;
    }

}

- (void)caculateWidths {
    NSMutableArray<NSString *> *freezeCollectionViewColumnsItemSize = @[].mutableCopy;
    NSMutableArray<NSString *> *slideCollectionViewColumnsItemSize = @[].mutableCopy;

    NSInteger columnsCount = self.flatData.firstObject.count;
    
    //遍历列
    for (NSInteger i = 0; i < columnsCount; i ++) {
        
        CGFloat columnMaxWidth = 0;
        
        //遍历行
        for (NSInteger j = 0; j < self.flatData.count; j ++) {
            
            NSString *columnValue = self.flatData[j][i];
            
            CGSize size = [columnValue sizeWithFont:self.slideBodyFont constraint:CGSizeMake(self.maxItemWidth, self.itemHeight)];
            if (j == 0) {
                size = [columnValue sizeWithFont:self.headerFont constraint:CGSizeMake(self.maxItemWidth, self.itemHeight)];
            }
            
            CGFloat targetWidth = size.width + 2 * self.itemTextHorizontalMargin;
            
            if (targetWidth >= columnMaxWidth) {
                columnMaxWidth = targetWidth;
            }
            
            columnMaxWidth = MAX(self.minItemWidth, MIN(self.maxItemWidth, columnMaxWidth));
        }
        
        if (i < self.freezeColumn) {
            [freezeCollectionViewColumnsItemSize addObject:NSStringFromCGSize(CGSizeMake(columnMaxWidth, self.itemHeight))];
            _freezeCollectionViewWidth += columnMaxWidth;
        } else {
            [slideCollectionViewColumnsItemSize addObject:NSStringFromCGSize(CGSizeMake(columnMaxWidth, self.itemHeight))];
            _slideCollectionViewWidth += columnMaxWidth;
        }
    }
    
    _freezeCollectionViewColumnsItemSize = freezeCollectionViewColumnsItemSize.copy;
    _slideCollectionViewColumnsItemSize = slideCollectionViewColumnsItemSize.copy;
}

#pragma mark - Public

- (void)caculate {
    [self configureFlatData];
    [self caculateWidths];
}

#pragma mark - Setter

- (void)setHeaderData:(NSArray<NSString *> *)headerData {
    _headerData = headerData;
    
    [self setupFlatData];
}

- (void)setBodyData:(NSArray<NSObject *> *)bodyData {
    _bodyData = bodyData;
    
    [self setupFlatData];
}

#pragma mark - Getter
@end
