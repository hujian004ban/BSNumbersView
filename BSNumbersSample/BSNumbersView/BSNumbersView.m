//
//  BSNumbersView.m
//  BSNumbersSample
//
//  Created by 张亚东 on 16/4/6.
//  Copyright © 2016年 blurryssky. All rights reserved.
//

#import "BSNumbersView.h"
#import "BSNumbersCollectionCell.h"
#import "BSNumbersCollectionHeaderView.h"
#import "NSObject+BSNumbersExtension.h"
#import "BSNumbersDataManager.h"

NSString * const CellReuseIdentifer = @"BSNumbersCollectionCell";
NSString * const HeaderReuseIdentifer = @"BSNumbersCollectionHeaderView";

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

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self setup];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    [self updateFrame];
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
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
    self.itemMinWidth = 100;
    self.itemMaxWidth = 150;
    self.itemHeight = 50;
    self.horizontalItemTextMargin = 10;
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
    self.horizontalSeparatorStyle = BSNumbersSeparatorStyleDotted;
    self.horizontalSeparatorColor = [UIColor lightGrayColor];
    self.verticalSeparatorColor = [UIColor lightGrayColor];
}

- (void)setupViews {

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
        CGFloat headerHeight = self.itemHeight;
        
        self.headerFreezeCollectionView.frame = CGRectMake(0,
                                                           0,
                                                           self.dataManager.freezeWidth ,
                                                           headerHeight);
        self.freezeCollectionView.frame = CGRectMake(0,
                                                     headerHeight,
                                                     self.dataManager.freezeWidth,
                                                     height - headerHeight);
        
        self.slideScrollView.frame = CGRectMake(self.dataManager.freezeWidth,
                                                  0,
                                                  width - self.dataManager.freezeWidth,
                                                  height);
        self.slideScrollView.contentSize = CGSizeMake(self.dataManager.slideWidth,
                                                        height);
        
        self.headerSlideCollectionView.frame = CGRectMake(0,
                                                            0,
                                                            self.dataManager.slideWidth,
                                                            headerHeight);
        self.slideCollectionView.frame = CGRectMake(0,
                                                      headerHeight,
                                                      self.dataManager.slideWidth,
                                                      height - headerHeight);
        
    } else {
        
        self.freezeCollectionView.frame = CGRectMake(0,
                                                     0,
                                                     self.dataManager.freezeWidth,
                                                     height);
        self.slideScrollView.frame = CGRectMake(self.dataManager.freezeWidth,
                                                  0,
                                                  width - self.dataManager.freezeWidth,
                                                  height);
        self.slideScrollView.contentSize = CGSizeMake(self.dataManager.slideWidth,
                                                        height);
        self.slideCollectionView.frame = CGRectMake(0,
                                                      0,
                                                      self.dataManager.slideWidth,
                                                      height);
    }

}

- (void)showHorizontalDivideShadowLayer {
    if (self.horizontalDivideShadowLayer.path == nil) {
        
        UIBezierPath *path = [UIBezierPath bezierPath];
        [path moveToPoint:CGPointMake(0, self.itemHeight)];
        [path addLineToPoint:CGPointMake(MIN(self.bounds.size.width, self.dataManager.freezeWidth + self.dataManager.slideWidth), self.itemHeight)];
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
        [path moveToPoint:CGPointMake(0, 0)];
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

- (CGSize)sizeForRow:(NSInteger)row {
    
    if (row < self.freezeColumn) {
        return CGSizeFromString(self.dataManager.freezeItemSize[row]);
    } else {
        return CGSizeFromString(self.dataManager.slideItemSize[row - self.freezeColumn]);
    }
}

- (NSString *)textAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.section == 0) {
        if (indexPath.row < self.freezeColumn) {
            return self.dataManager.headerFreezeData[indexPath.row];
        } else {
            return self.dataManager.headerSlideData[indexPath.row - self.freezeColumn];
        }
    } else {
        if (indexPath.row < self.freezeColumn) {
            return self.dataManager.bodyFreezeData[indexPath.section - 1][indexPath.row];
        } else {
            return self.dataManager.bodySlideData[indexPath.section - 1][indexPath.row- self.freezeColumn];
        }
    }
}

#pragma mark - Setter

- (void)setHeaderData:(NSArray<NSString *> *)headerData {
    _headerData = headerData;
    
    [self.dataManager setupFlatData];
}

- (void)setBodyData:(NSArray<NSObject *> *)bodyData {
    _bodyData = bodyData;
    
    [self.dataManager setupFlatData];
    [self reloadData];
}

#pragma mark - Getter

- (BSNumbersDataManager *)dataManager {
    if (!_dataManager) {
        _dataManager = [BSNumbersDataManager new];
        _dataManager.numbersView = self;
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
    flowLayout.headerReferenceSize = CGSizeMake([UIScreen mainScreen].bounds.size.width, 1);
    
    UICollectionView *c = [[UICollectionView alloc]initWithFrame:CGRectZero collectionViewLayout:flowLayout];
    c.dataSource = self;
    c.delegate = self;
    [c registerClass:[BSNumbersCollectionCell class] forCellWithReuseIdentifier:CellReuseIdentifer];
    [c registerClass:[BSNumbersCollectionHeaderView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:HeaderReuseIdentifer];
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
    
    if (self.delegate && [self.delegate conformsToProtocol:@protocol(BSNumbersViewDelegate)]) {
        if ([self.delegate respondsToSelector:aSelector]) {
            return YES;
        }
        return NO;
    }
    return NO;
}

- (void)_useCustomViewIfNeededInCell:(BSNumbersCollectionCell *)cell indexPath:(NSIndexPath *)indexPath {
    if ([self didImplementation:@selector(numbersView:viewAtIndexPath:)]) {
        UIView *customView = [self.delegate numbersView:self viewAtIndexPath:indexPath];
        if (customView) {
            cell.customView = customView;
        }
    }
}

- (void)_useAttributedStringIfNeededInCell:(BSNumbersCollectionCell *)cell indexPath:(NSIndexPath *)indexPath {
    if ([self didImplementation:@selector(numbersView:attributedStringAtIndexPath:)]) {
        NSAttributedString *attributedString = [self.delegate numbersView:self attributedStringAtIndexPath:indexPath];
        if (attributedString) {
            cell.label.attributedText = attributedString;
            return;
        }
    }
}

#pragma mark - Cell Configuration

- (void)configureHeaderFreezeCell:(BSNumbersCollectionCell *)cell indexPath:(NSIndexPath *)indexPath {
    NSString *text = self.dataManager.headerFreezeData[indexPath.row];
    cell.label.text = text;
    cell.backgroundColor = self.headerBackgroundColor;
    cell.label.textColor = self.headerTextColor;
    cell.label.font = self.headerFont;
    
    [self _useCustomViewIfNeededInCell:cell indexPath:indexPath];
    
    [self _useAttributedStringIfNeededInCell:cell indexPath:indexPath];
}

- (void)configureHeaderSlideCell:(BSNumbersCollectionCell *)cell indexPath:(NSIndexPath *)indexPath {
    
    NSString *text = self.dataManager.headerSlideData[indexPath.row];
    cell.label.text = text;
    cell.backgroundColor = self.headerBackgroundColor;
    cell.label.textColor = self.headerTextColor;
    cell.label.font = self.headerFont;
    
    NSIndexPath *targetIndexPath = [NSIndexPath indexPathForRow:indexPath.row + self.freezeColumn inSection:indexPath.section];
    
    [self _useCustomViewIfNeededInCell:cell indexPath:targetIndexPath];
    
    [self _useAttributedStringIfNeededInCell:cell indexPath:targetIndexPath];
}

- (void)configureBodyFreezeCell:(BSNumbersCollectionCell *)cell indexPath:(NSIndexPath *)indexPath {

    NSString *text = self.dataManager.bodyFreezeData[indexPath.section][indexPath.row];
    cell.label.text = text;
    cell.backgroundColor = self.freezeBodyBackgroundColor;
    cell.label.textColor = self.freezeBodyTextColor;
    cell.label.font = self.freezeBodyFont;
    
    NSIndexPath *targetIndexPath = [NSIndexPath indexPathForRow:indexPath.row inSection:indexPath.section + 1];
    
    [self _useCustomViewIfNeededInCell:cell indexPath:targetIndexPath];
    
    [self _useAttributedStringIfNeededInCell:cell indexPath:targetIndexPath];
}

- (void)configureBodySlideCell:(BSNumbersCollectionCell *)cell indexPath:(NSIndexPath *)indexPath {
    NSString *text = self.dataManager.bodySlideData[indexPath.section][indexPath.row];
    cell.label.text = text;
    cell.backgroundColor = self.slideBodyBackgroundColor;
    cell.label.textColor = self.slideBodyTextColor;
    cell.label.font = self.slideBodyFont;
    
    NSIndexPath *targetIndexPath = [NSIndexPath indexPathForRow:indexPath.row + self.freezeColumn inSection:indexPath.section + 1];
    
    [self _useCustomViewIfNeededInCell:cell indexPath:targetIndexPath];
    
    [self _useAttributedStringIfNeededInCell:cell indexPath:targetIndexPath];
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
        NSInteger slideColumn = firstBodyData.bs_propertyValues.count - self.freezeColumn;
        return slideColumn;
    }
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    BSNumbersCollectionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:CellReuseIdentifer forIndexPath:indexPath];
    cell.horizontalMargin = self.horizontalItemTextMargin;
    
    if (collectionView == self.headerFreezeCollectionView) {
        [self configureHeaderFreezeCell:cell indexPath:indexPath];
    } else if (collectionView == self.headerSlideCollectionView) {
        [self configureHeaderSlideCell:cell indexPath:indexPath];
    } else if (collectionView == self.freezeCollectionView) {
        [self configureBodyFreezeCell:cell indexPath:indexPath];
    } else {
        [self configureBodySlideCell:cell indexPath:indexPath];
    }
    
    cell.separatorColor = self.verticalSeparatorColor;
    cell.separatorHidden = NO;
    NSInteger valuesCount = self.bodyData.firstObject.bs_propertyValues.count;
    if (valuesCount == self.freezeColumn) {
        if (indexPath.row == self.freezeColumn - 1) {
            cell.separatorHidden = YES;
        }
    } else {
        if (indexPath.row == valuesCount - self.freezeColumn - 1) {
            cell.separatorHidden = YES;
        }
    }
    
    return cell;
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
    
    if (kind == UICollectionElementKindSectionHeader) {
        BSNumbersCollectionHeaderView *headerView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:HeaderReuseIdentifer forIndexPath:indexPath];
        headerView.separatorStyle = self.horizontalSeparatorStyle;
        headerView.separatorColor = self.horizontalSeparatorColor;
        
        if (indexPath.section == 0) {
            if (self.headerData != nil) {
                if (collectionView == self.headerFreezeCollectionView ||
                    collectionView == self.headerSlideCollectionView) {
                    headerView.separatorStyle = BSNumbersSeparatorStyleNone;
                }
            } else {
                headerView.separatorStyle = BSNumbersSeparatorStyleNone;
            }
        }
        return headerView;
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

            return CGSizeFromString(self.dataManager.freezeItemSize[indexPath.row]);
        } else {
            
            return CGSizeFromString(self.dataManager.slideItemSize[indexPath.row]);
        }
    }
}

#pragma mark - UICollectionViewDelegate

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
    if (![self didImplementation:@selector(numbersView:didSelectItemAtIndexPath:)]) {
        return;
    }
    
    NSIndexPath *targetIndexPath = indexPath;
    if (collectionView == self.headerFreezeCollectionView) {
        
    } else if (collectionView == self.headerSlideCollectionView) {
        targetIndexPath = [NSIndexPath indexPathForRow:indexPath.row + self.freezeColumn inSection:indexPath.section];
    } else if (collectionView == self.freezeCollectionView) {
        targetIndexPath = [NSIndexPath indexPathForRow:indexPath.row inSection:indexPath.section + 1];
    } else {
        targetIndexPath = [NSIndexPath indexPathForRow:indexPath.row + self.freezeColumn inSection:indexPath.section + 1];
    }
    [self.delegate numbersView:self didSelectItemAtIndexPath:targetIndexPath];
}

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
