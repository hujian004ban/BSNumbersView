//
//  BSNumbersView.h
//  BSNumbersSample
//
//  Created by 张亚东 on 16/4/6.
//  Copyright © 2016年 blurryssky. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, BSNumbersSeparatorStyle) {
    BSNumbersSeparatorStyleNone,
    BSNumbersSeparatorStyleSolid,
    BSNumbersSeparatorStyleDotted
};

@class BSNumbersView;

NS_ASSUME_NONNULL_BEGIN


@protocol BSNumbersViewDelegate <NSObject>

@optional

- (nullable UIView *)numbersView:(BSNumbersView *)numbersView
                 viewAtIndexPath:(NSIndexPath *)indexPath;

- (nullable NSAttributedString *)numbersView:(BSNumbersView *)numbersView
        attributedStringAtIndexPath:(NSIndexPath *)indexPath;

- (void)numbersView:(BSNumbersView *)numbersView
                 didSelectItemAtIndexPath:(NSIndexPath *)indexPath;

@end

@interface BSNumbersView : UIView

@property (assign, nonatomic) id<BSNumbersViewDelegate> delegate;

///min width for each item
@property (assign, nonatomic) IBInspectable CGFloat itemMinWidth;

///max width for each item
@property (assign, nonatomic) IBInspectable CGFloat itemMaxWidth;

///height for each item
@property (assign, nonatomic) IBInspectable CGFloat itemHeight;

///text horizontal margin for each item, default is 10.0
@property (assign, nonatomic) IBInspectable CGFloat horizontalItemTextMargin;

///the column need to freeze
@property (assign, nonatomic) IBInspectable NSInteger freezeColumn;

///header font
@property (strong, nonatomic) IBInspectable UIFont *headerFont;

///header text color
@property (strong, nonatomic) IBInspectable UIColor *headerTextColor;

///header background color
@property (strong, nonatomic) IBInspectable UIColor *headerBackgroundColor;

///body font
@property (strong, nonatomic) IBInspectable UIFont *slideBodyFont;

///body text color
@property (strong, nonatomic) IBInspectable UIColor *slideBodyTextColor;

///body background color
@property (strong, nonatomic) IBInspectable UIColor *slideBodyBackgroundColor;

///body font
@property (strong, nonatomic) IBInspectable UIFont *freezeBodyFont;

///body text color
@property (strong, nonatomic) IBInspectable UIColor *freezeBodyTextColor;

///body background color
@property (strong, nonatomic) IBInspectable UIColor *freezeBodyBackgroundColor;

///separator
@property (assign, nonatomic) IBInspectable BSNumbersSeparatorStyle horizontalSeparatorStyle;

///default is [UIColor LightGrayColor]
@property (strong, nonatomic) IBInspectable UIColor *horizontalSeparatorColor;
@property (strong, nonatomic) IBInspectable UIColor *verticalSeparatorColor;

///data
@property (strong, nonatomic) NSArray<NSString *> *headerData;
@property (strong, nonatomic) NSArray<NSObject *> *bodyData;


- (NSString *)textAtIndexPath:(NSIndexPath *)indexPath;

- (CGSize)sizeForRow:(NSInteger)row;

- (void)reloadData;
- (void)reloadItemsAtIndexPaths:(NSArray<NSIndexPath *> *)indexPaths;

NS_ASSUME_NONNULL_END

@end
