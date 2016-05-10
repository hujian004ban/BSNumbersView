//
//  ViewController.m
//  BSNumbersSample
//
//  Created by 张亚东 on 16/4/6.
//  Copyright © 2016年 blurryssky. All rights reserved.
//

#import "ViewController.h"
#import "Flight.h"
#import "BSNumbersView.h"
#import "NSObject+BSNumbersExtension.h"

@interface ViewController () <BSNumbersViewDelegate>

@property (weak, nonatomic) IBOutlet BSNumbersView *numbersView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    self.title = @"航班信息";
    
    NSArray<NSDictionary *> *flightsInfo = [NSArray arrayWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"flightsInfo" ofType:@"plist"]];
    
    NSMutableArray<Flight *> *flights = @[].mutableCopy;
    for (NSDictionary *flightInfo in flightsInfo) {
        Flight *flight = [[Flight alloc]initWithDictionary:flightInfo];
        [flights addObject:flight];
    }
    
    self.numbersView.delegate = self;
    
    self.numbersView.bodyData = flights;
    
    self.numbersView.headerData = @[@"Flight Company", @"Flight Number", @"Type Of Aircraft", @"Date", @"Place Of Departure", @"Place Of Destination", @"Departure Time", @"Arrive Time", @"Price"];
    self.numbersView.freezeColumn = 1;
    self.numbersView.slideBodyFont = [UIFont systemFontOfSize:14];
    
    [self.numbersView reloadData];
}

#pragma mark -- BSNumbersViewDelegate

- (UIView *)numbersView:(BSNumbersView *)numbersView viewForBodyFreezeAtIndexPath:(NSIndexPath *)indexPath {
    
    CGSize size = [numbersView sizeForFreezeAtColumn:indexPath.row];
    NSString *text = [numbersView textForBodyFreezeAtIndexPath:indexPath];
    
    UIView *view = [UIView new];
    view.backgroundColor = [UIColor lightGrayColor];
    
    UIView *square = [UIView new];
    square.backgroundColor = [UIColor orangeColor];
    square.frame = CGRectMake(0, 0, 15, 15);
    square.center = CGPointMake(size.width/2 - 35, size.height/2);
    [view addSubview:square];
    
    UILabel *label = [UILabel new];
    label.text = text;
    label.textColor = [UIColor whiteColor];
    label.font = [UIFont systemFontOfSize:14];
    label.frame = CGRectMake(0, 0, 100, 100);
    label.center = CGPointMake(size.width/2 + 10, size.height/2);
    label.textAlignment = NSTextAlignmentCenter;
    [view addSubview:label];
    
    return view;
}

- (NSAttributedString *)numbersView:(BSNumbersView *)numbersView attributedStringForBodySlideAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 0) {
        NSString *text = [numbersView textForBodySlideAtIndexPath:indexPath];
        NSMutableAttributedString *string = [[NSMutableAttributedString alloc]initWithString:text];
        
        [string addAttributes:@{NSForegroundColorAttributeName: [UIColor redColor],
                                NSFontAttributeName: [UIFont systemFontOfSize:11]} range:NSMakeRange(0, 2)];
        [string addAttributes:@{NSFontAttributeName: [UIFont systemFontOfSize:19]} range:NSMakeRange(2, text.length - 2)];
        return string;
    }
    return nil;
}



@end
