# BSNumbersView

## Overview

if the view did not add constraints, you need to rotate the view manually when screen's orientation changed.

![BSNumbersViewGIF.gif](https://github.com/blurryssky/BSNumbers/blob/master/Screenshots/BSNumbersGIF.gif)

## Installation

> pod 'BSNumbersView', '~> 0.1.6'

## Usage

### Supple an array with models as datasource

```objective-c
NSArray<NSDictionary *> *flightsInfo = [NSArray arrayWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"flightsInfo" ofType:@"plist"]];
NSMutableArray<Flight *> *flights = @[].mutableCopy;
for (NSDictionary *flightInfo in flightsInfo) {
    Flight *flight = [[Flight alloc]initWithDictionary:flightInfo];
    [flights addObject:flight];
}
```
    
### This is the model: Flight
```objective-c
@interface Flight : NSObject

@property (strong, nonatomic) NSString *company;
@property (strong, nonatomic) NSString *number;
@property (strong, nonatomic) NSString *typeOfAircraft;
@property (strong, nonatomic) NSString *date;
@property (strong, nonatomic) NSString *placeOfDeparture;
@property (strong, nonatomic) NSString *placeOfDestination;
@property (strong, nonatomic) NSString *departureTime;
@property (strong, nonatomic) NSString *arriveTime;
@property (strong, nonatomic) NSString *price;

- (instancetype)initWithDictionary:(NSDictionary *)dic;

@end
```
###Set the datasource and the other optional attribute
```objective-c
self.numbersView.bodyData = flights;
```
######optional attribute
```objective-c
self.numbersView.headerData = @[@"Flight Company", @"Flight Number", @"Type Of Aircraft", @"Date", @"Place Of Departure", @"Place Of Destination", @"Departure Time", @"Arrive Time", @"Price"];
self.numbersView.freezeColumn = 1;
self.numbersView.bodyFont = [UIFont systemFontOfSize:14];
```
###Display
```objective-c
[self.numbersView reloadData];
```
###Use delegate

```objective-c
#pragma mark -- BSNumbersViewDelegate

- (UIView *)numbersView:(BSNumbersView *)numbersView viewForBodyFreezeInColumn:(NSInteger)column text:(NSString *)text {
    CGSize size = [numbersView sizeForFreezeColumn:column];
    
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
```
