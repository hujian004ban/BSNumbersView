//
//  BSNumbersView.m
//  BSNumbersSample
//
//  Created by 张亚东 on 16/4/6.
//  Copyright © 2016年 blurryssky. All rights reserved.
//

#import "BSNumbersView.h"
#import "BSNumbersCollectionCell.h"
#import "BSNumbersCollectionFooterView.h"
#import "NSObject+BSNumbersExtension.h"
#import "BSNumbersDataManager.h"

NSString * const CellReuseIdentifer = @"BSNumbersCollectionCell";
NSString * const FooterReuseIdentifer = @"BSNumbersCollectionFooterView";

@interface BSNumbersView () <UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout, UIScrollViewDelegate>

@property (strong, nonatomic) BSNumbersDataManager *dataManager;

@property (strong, nonatomic) UICollectionView *headerFreezeCollectionView;
@property (strong, nonatomic) UICollectionView *headerSlideCollectionView;

@property (strong, nonatomic) UICollectionView *freezeCollectionView;
@property (strong, nonatomic) UICollectionView *slideCollectionView;

@property (strong, nonatomic) UIScrollView *slideScrollView;

@property (strong, nonatomic) CAShapeLayer *horizontalDivideShadowLayer;
@property (strong, nonatomic) CAShapeLayer *verticalDivideShadowLayer;

- (void)setup;
- (void)setupVars;
- (void)setupViews;

- (void)handleNotification:(NSNotification *)noti;

- (void)updateFrame;

- (void)showHorizontalDivideShadowLayer;
- (void)dismissHorizontalDivideShadowLayer;

- (void)showVerticalDivideShadowLayer;
- (void)dismissVerticalDivideShadowLayer;

- (UICollectionView *)initializeCollectionView;
- (CAShapeLayer *)initializeLayer;

@end

@implementation BSNumbersView
#pragma mark - Override

- (void)awakeFromNib {
    [super awakeFromNib];
    [self setup];
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setup];
    }
    return self;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self setup];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    [self updateFrame];
}

#pragma mark - Notification

- (void)handleNotification:(NSNotification *)noti {
    UIDeviceOrientation orientation = [UIDevice currentDevice].orientation;
    
    if (orientation != UIDeviceOrientationPortraitUpsideDown) {
        [UIView animateWithDuration:0.3 animations:^{
            [self updateFrame];
        }];
    }
    
}

#pragma mark - Private

- (void)setup {
    [self setupVars];
    [self setupViews];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleNotification:) name:UIDeviceOrientationDidChangeNotification object:nil];
}

- (void)setupVars {
    self.minItemWidth = 100;
    self.maxItemWidth = 150;
    self.itemHeight = 50;
    self.itemTextHorizontalMargin = 10;
    self.freezeColumn = 1;
    self.headerFont = [UIFont systemFontOfSize:17];
    self.headerTextColor = [UIColor whiteColor];
    self.headerBackgroundColor = [UIColor grayColor];
    self.slideBodyFont = self.headerFont;
    self.slideBodyTextColor = [UIColor blackColor];
    self.slideBodyBackgroundColor = [UIColor whiteColor];
    self.freezeBodyFont = self.headerFont;
    self.freezeBodyTextColor = [UIColor whiteColor];
    self.freezeBodyBackgroundColor = [UIColor lightGrayColor];
}

- (void)setupViews {
    self.layer.borderColor = [UIColor lightGrayColor].CGColor;
    self.layer.borderWidth = 0.5;
    
    [self addSubview:self.headerFreezeCollectionView];
    [self addSubview:self.freezeCollectionView];
    
    [self addSubview:self.slideScrollView];
    [self.slideScrollView addSubview:self.headerSlideCollectionView];
    [self.slideScrollView addSubview:self.slideCollectionView];
    
    [self.layer addSublayer:self.horizontalDivideShadowLayer];
    [self.slideScrollView.layer addSublayer:self.verticalDivideShadowLayer];
}

- (void)updateFrame {
    CGFloat width = self.bounds.size.width;
    CGFloat height = self.bounds.size.height;
    
    
    if (self.headerData) {
        CGFloat headerHeight = self.itemHeight + 1;
        
        self.headerFreezeCollectionView.frame = CGRectMake(0,
                                                           0,
                                                           self.dataManager.freezeCollectionViewWidth ,
                                                           headerHeight);
        self.freezeCollectionView.frame = CGRectMake(0,
                                                     headerHeight,
                                                     self.dataManager.freezeCollectionViewWidth,
                                                     height - headerHeight);
        
        self.slideScrollView.frame = CGRectMake(self.dataManager.freezeCollectionViewWidth,
                                                  0,
                                                  width - self.dataManager.freezeCollectionViewWidth,
                                                  height);
        self.slideScrollView.contentSize = CGSizeMake(self.dataManager.slideCollectionViewWidth,
                                                        height);
        
        self.headerSlideCollectionView.frame = CGRectMake(0,
                                                            0,
                                                            self.dataManager.slideCollectionViewWidth,
                                                            headerHeight);
        self.slideCollectionView.frame = CGRectMake(0,
                                                      headerHeight,
                                                      self.dataManager.slideCollectionViewWidth,
                                                      height - headerHeight);
        
    } else {
        
        self.freezeCollectionView.frame = CGRectMake(0,
                                                     0,
                                                     self.dataManager.freezeCollectionViewWidth,
                                                     height);
        self.slideScrollView.frame = CGRectMake(self.dataManager.freezeCollectionViewWidth,
                                                  0,
                                                  width - self.dataManager.freezeCollectionViewWidth,
                                                  height);
        self.slideScrollView.contentSize = CGSizeMake(self.dataManager.slideCollectionViewWidth,
                                                        height);
        self.slideCollectionView.frame = CGRectMake(0,
                                                      0,
                                                      self.dataManager.slideCollectionViewWidth,
                                                      height);
    }

}

- (void)showHorizontalDivideShadowLayer {
    if (self.horizontalDivideShadowLayer.path == nil) {
        CGFloat width = self.bounds.size.width;
        UIBezierPath *path = [UIBezierPath bezierPath];
        [path moveToPoint:CGPointMake(0, self.itemHeight)];
        [path addLineToPoint:CGPointMake(width, self.itemHeight)];
        path.lineWidth = 0.5;
        
        self.horizontalDivideShadowLayer.path = path.CGPath;
    }
}

- (void)dismissHorizontalDivideShadowLayer {
    self.horizontalDivideShadowLayer.path = nil;
}

- (void)showVerticalDivideShadowLayer {
    if (self.verticalDivideShadowLayer.path == nil) {
        
        CGFloat height = self.freezeCollectionView.contentSize.height;
        UIBezierPath *path = [UIBezierPath bezierPath];
        [path moveToPoint:CGPointMake(0, self.slideScrollView.frame.origin.y)];
        [path addLineToPoint:CGPointMake(0, height)];
        path.lineWidth = 0.5;
        
        self.verticalDivideShadowLayer.path = path.CGPath;
    }
}

- (void)dismissVerticalDivideShadowLayer {
    self.verticalDivideShadowLayer.path = nil;
}

#pragma mark - Public

- (void)reloadData {
    [self.dataManager caculate];
    [self updateFrame];
    
    [self.headerFreezeCollectionView reloadData];
    [self.headerSlideCollectionView reloadData];
    [self.freezeCollectionView reloadData];
    [self.slideCollectionView reloadData];
}

- (CGSize)sizeForFreezeColumn:(NSInteger)column {
    CGSize size = CGSizeFromString(self.dataManager.freezeCollectionViewColumnsItemSize[column]);
    return size;
}

- (CGSize)sizeForSlideColumn:(NSInteger)column {
    CGSize size = CGSizeFromString(self.dataManager.slideCollectionViewColumnsItemSize[column]);
    return size;
}

#pragma mark - Setter

- (void)setMinItemWidth:(CGFloat)minItemWidth {
    _minItemWidth = minItemWidth;
    
    self.dataManager.minItemWidth = minItemWidth;
}

- (void)setMaxItemWidth:(CGFloat)maxItemWidth {
    _maxItemWidth = maxItemWidth;
    
    self.dataManager.maxItemWidth = maxItemWidth;
}

- (void)setFreezeColumn:(NSInteger)freezeColumn {
    _freezeColumn = freezeColumn;
    
    self.dataManager.freezeColumn = freezeColumn;
}

- (void)setItemHeight:(CGFloat)itemHeight {
    _itemHeight = itemHeight;
    
    self.dataManager.itemHeight = itemHeight;
}

- (void)setItemHorizontalMargin:(CGFloat)itemTextHorizontalMargin {
    _itemTextHorizontalMargin = itemTextHorizontalMargin;
    
    self.dataManager.itemTextHorizontalMargin = itemTextHorizontalMargin;
}

- (void)setHeaderFont:(UIFont *)headerFont {
    _headerFont = headerFont;
    
    self.dataManager.headerFont = headerFont;
}

- (void)setSlideBodyFont:(UIFont *)slideBodyFont {
    _slideBodyFont = slideBodyFont;
    
    self.dataManager.slideBodyFont = slideBodyFont;
}

- (void)setHeaderData:(NSArray<NSString *> *)headerData {
    _headerData = headerData;
    
    self.dataManager.headerData = headerData;
}

- (void)setBodyData:(NSArray<NSObject *> *)bodyData {
    _bodyData = bodyData;
    
    self.dataManager.bodyData = bodyData;
}

#pragma mark - Getter

- (BSNumbersDataManager *)dataManager {
    if (!_dataManager) {
        _dataManager = [BSNumbersDataManager new];
    }
    return _dataManager;
}

- (UICollectionView *)headerFreezeCollectionView {
    if (!_headerFreezeCollectionView) {
        _headerFreezeCollectionView = [self initializeCollectionView];
    }
    return _headerFreezeCollectionView;
}

- (UICollectionView *)headerSlideCollectionView {
    if (!_headerSlideCollectionView) {
        _headerSlideCollectionView = [self initializeCollectionView];
    }
    return _headerSlideCollectionView;
}

- (UICollectionView *)freezeCollectionView {
    if (!_freezeCollectionView) {
        _freezeCollectionView = [self initializeCollectionView];
    }
    return _freezeCollectionView;
}

- (UICollectionView *)slideCollectionView {
    if (!_slideCollectionView) {
        _slideCollectionView = [self initializeCollectionView];
    }
    return _slideCollectionView;
}

- (UIScrollView *)slideScrollView {
    if (!_slideScrollView) {
        _slideScrollView = [UIScrollView new];
        _slideScrollView.bounces = NO;
        _slideScrollView.showsHorizontalScrollIndicator = NO;
        _slideScrollView.delegate = self;
    }
    return _slideScrollView;
}

- (CAShapeLayer *)horizontalDivideShadowLayer {
    if (!_horizontalDivideShadowLayer) {
        _horizontalDivideShadowLayer = [self initializeLayer];
        _horizontalDivideShadowLayer.shadowOffset = CGSizeMake(0, 3);
    }
    return _horizontalDivideShadowLayer;
}

- (CAShapeLayer *)verticalDivideShadowLayer {
    if (!_verticalDivideShadowLayer) {
        _verticalDivideShadowLayer = [self initializeLayer];
    }
    return _verticalDivideShadowLayer;
}

#pragma mark - Helper

- (UICollectionView *)initializeCollectionView {
    UICollectionViewFlowLayout *flowLayout = [UICollectionViewFlowLayout new];
    flowLayout.minimumLineSpacing = 0;
    flowLayout.minimumInteritemSpacing = 0;
    flowLayout.footerReferenceSize = CGSizeMake([UIScreen mainScreen].bounds.size.width, 1);
    
    UICollectionView *c = [[UICollectionView alloc]initWithFrame:CGRectZero collectionViewLayout:flowLayout];
    c.dataSource = self;
    c.delegate = self;
    [c registerClass:[BSNumbersCollectionCell class] forCellWithReuseIdentifier:CellReuseIdentifer];
    [c registerClass:[BSNumbersCollectionFooterView class] forSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:FooterReuseIdentifer];
    c.backgroundColor = [UIColor clearColor];
    c.showsVerticalScrollIndicator = NO;
    c.bounces = NO;
    c.translatesAutoresizingMaskIntoConstraints = NO;
    return c;
}

- (CAShapeLayer *)initializeLayer {
    CAShapeLayer *s = [CAShapeLayer new];
    s.strokeColor = [UIColor lightGrayColor].CGColor;
    s.shadowColor = [UIColor blackColor].CGColor;
    s.shadowOffset = CGSizeMake(2, 0);
    s.shadowOpacity = 1;
    return s;
}

- (BOOL)didImplementation:(SEL)aSelector {
    if ([self.delegate conformsToProtocol:@protocol(BSNumbersViewDelegate)]) {
        if ([self.delegate respondsToSelector:aSelector]) {
            return YES;
        }
        return NO;
    }
    return NO;
}

#pragma mark - CellConfiguration

- (void)configureHeaderFreezeCell:(BSNumbersCollectionCell *)cell indexPath:(NSIndexPath *)indexPath {
    NSString *text = self.dataManager.headerFreezeCollectionViewFlatData[indexPath.row];
    
    cell.label.textColor = self.headerTextColor;
    cell.backgroundColor = self.headerBackgroundColor;
    cell.label.font = self.headerFont;
    cell.label.text = text;
}

- (void)configureHeaderSlideCell:(BSNumbersCollectionCell *)cell indexPath:(NSIndexPath *)indexPath {
    NSString *text = self.dataManager.headerSlideCollectionViewFlatData[indexPath.row];
    
    cell.label.textColor = self.headerTextColor;
    cell.backgroundColor = self.headerBackgroundColor;
    cell.label.font = self.headerFont;
    cell.label.text = text;
}

- (void)configureBodyFreezeCell:(BSNumbersCollectionCell *)cell indexPath:(NSIndexPath *)indexPath {

    NSString *text = self.dataManager.freezeCollectionViewFlatData[indexPath.section][indexPath.row];
    
    if ([self didImplementation:@selector(numbersView:viewForBodyFreezeInColumn:text:)]) {
        UIView *customView = [self.delegate numbersView:self viewForBodyFreezeInColumn:indexPath.row text:text];
        if (customView) {
            cell.label.text = @"";
            customView.frame = cell.bounds;
            [customView removeFromSuperview];
            [cell addSubview:customView];
            
            return;
        }
    }

    cell.label.textColor = self.freezeBodyTextColor;
    cell.backgroundColor = self.freezeBodyBackgroundColor;
    cell.label.font = self.freezeBodyFont;
    cell.label.text = text;
    
}

- (void)configureBodySlideCell:(BSNumbersCollectionCell *)cell indexPath:(NSIndexPath *)indexPath {
    NSString *text = self.dataManager.slideCollectionViewFlatData[indexPath.section][indexPath.row];
    
    if ([self didImplementation:@selector(numbersView:viewForBodySlideInColumn:text:)]) {
        UIView *customView = [self.delegate numbersView:self viewForBodySlideInColumn:indexPath.row text: text];
        if (customView) {
            cell.label.text = @"";
            customView.frame = cell.bounds;
            [customView removeFromSuperview];
            [cell addSubview:customView];
            
            return;
        }
    }
    
    cell.label.textColor = self.slideBodyTextColor;
    cell.backgroundColor = self.slideBodyBackgroundColor;
    cell.label.font = self.slideBodyFont;
    cell.label.text = text;
}

#pragma mark - UICollectionViewDataSource

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    if (collectionView == self.headerFreezeCollectionView ||
        collectionView == self.headerSlideCollectionView) {
        return 1;
    } else {
        return self.bodyData.count;
    }
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {

    if (collectionView == self.headerFreezeCollectionView ||
        collectionView == self.freezeCollectionView) {
        return self.freezeColumn;
    } else {
        NSObject *firstBodyData = self.bodyData.firstObject;
        NSInteger slideColumn = [firstBodyData getPropertiesValues].count - self.freezeColumn;
        return slideColumn;
    }
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    BSNumbersCollectionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:CellReuseIdentifer forIndexPath:indexPath];
    cell.horizontalMargin = self.itemTextHorizontalMargin;
    
    if (collectionView == self.headerFreezeCollectionView) {
        
        [self configureHeaderFreezeCell:cell indexPath:indexPath];
        
    } else if (collectionView == self.headerSlideCollectionView) {
        
        [self configureHeaderSlideCell:cell indexPath:indexPath];
        
    } else if (collectionView == self.freezeCollectionView) {
        
        [self configureBodyFreezeCell:cell indexPath:indexPath];
        
    } else {
        
        [self configureBodySlideCell:cell indexPath:indexPath];
    }
    
    
    
    return cell;
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
    if (kind == UICollectionElementKindSectionFooter) {
        BSNumbersCollectionFooterView *footerView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:FooterReuseIdentifer forIndexPath:indexPath];
        
        if (collectionView == self.headerFreezeCollectionView ||
            collectionView == self.headerSlideCollectionView) {
            footerView.lineStyle = BSNumbersLineStyleReal;
        } else {
            if (indexPath.section != self.bodyData.count - 1) {
                footerView.lineStyle = BSNumbersLineStyleDotted;
            } else {
                footerView.lineStyle = BSNumbersLineStyleReal;
            }
        }
        return footerView;
    } else {
        return nil;
    }
}

#pragma mark - UICollectionViewDelegateFlowLayout

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    if (self.bodyData.count == 0) {
        return CGSizeZero;
    } else {
        if (collectionView == self.headerFreezeCollectionView ||
            collectionView == self.freezeCollectionView) {

            return CGSizeFromString(self.dataManager.freezeCollectionViewColumnsItemSize[indexPath.row]);
        } else {
            
            return CGSizeFromString(self.dataManager.slideCollectionViewColumnsItemSize[indexPath.row]);
        }
    }
}

#pragma mark - UICollectionViewDelegate


#pragma mark - UIScrollViewDelegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if (scrollView != self.slideScrollView) {
        [self.freezeCollectionView setContentOffset:scrollView.contentOffset];
        [self.slideCollectionView setContentOffset:scrollView.contentOffset];
        
        if (scrollView.contentOffset.y > 0) {
            [self showHorizontalDivideShadowLayer];
        } else {
            [self dismissHorizontalDivideShadowLayer];
        }
        
    } else {
        if (scrollView.contentOffset.x > 0) {
            [self showVerticalDivideShadowLayer];
        } else {
            [self dismissVerticalDivideShadowLayer];
        }
        [CATransaction begin];
        [CATransaction setDisableActions:YES];
        self.verticalDivideShadowLayer.transform = CATransform3DMakeTranslation(scrollView.contentOffset.x, 0, 0);
        [CATransaction commit];
        
    }
}

@end
