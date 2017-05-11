# BSNumbersView

## Overview

###### if the view did not add constraints, you need to rotate the view manually when screen's orientation changed.

![BSNumbersViewGIF.gif](https://github.com/blurryssky/BSNumbers/blob/master/Screenshots/BSNumbersGIF.gif)

## Installation

> pod 'BSNumbersView'

## Usage

### Supply an array with models as datasource

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
### Set the datasource
```objective-c
self.numbersView.bodyData = flights;
```
### Set optional property 
```objective-c
self.numbersView.headerData = @[@"Flight Company", @"Flight Number", @"Type Of Aircraft", @"Date", @"Place Of Departure", @"Place Of Destination", @"Departure Time", @"Arrive Time", @"Price"];
self.numbersView.freezeColumn = 1;
self.numbersView.bodyFont = [UIFont systemFontOfSize:14];
```
### Display
```objective-c
[self.numbersView reloadData];
```

### All Properties
```objective-c
@interface BSNumbersView : UIView

@property (assign, nonatomic) id<BSNumbersViewDelegate> delegate;

///min width for each item
@property (assign, nonatomic) CGFloat itemMinWidth;

///max width for each item
@property (assign, nonatomic) CGFloat itemMaxWidth;

///height for each item
@property (assign, nonatomic) CGFloat itemHeight;

///text horizontal margin for each item, default is 10.0
@property (assign, nonatomic) CGFloat horizontalItemTextMargin;

///the column need to freeze
@property (assign, nonatomic) NSInteger freezeColumn;

///header font
@property (strong, nonatomic) UIFont *headerFont;

///header text color
@property (strong, nonatomic) UIColor *headerTextColor;

///header background color
@property (strong, nonatomic) UIColor *headerBackgroundColor;

///body font
@property (strong, nonatomic) UIFont *slideBodyFont;

///body text color
@property (strong, nonatomic) UIColor *slideBodyTextColor;

///body background color
@property (strong, nonatomic) UIColor *slideBodyBackgroundColor;

///body font
@property (strong, nonatomic) UIFont *freezeBodyFont;

///body text color
@property (strong, nonatomic) UIColor *freezeBodyTextColor;

///body background color
@property (strong, nonatomic) UIColor *freezeBodyBackgroundColor;

///separator
@property (assign, nonatomic) BSNumbersSeparatorStyle horizontalSeparatorStyle;

///default is [UIColor LightGrayColor]
@property (strong, nonatomic) UIColor *horizontalSeparatorColor;
@property (strong, nonatomic) UIColor *verticalSeparatorColor;

///data
@property (strong, nonatomic) NSArray<NSString *> *headerData;
@property (strong, nonatomic) NSArray<NSObject *> *bodyData;

@end
```

### Use delegate

###### every line is a section, and every column is a row

```objective-c
#pragma mark -- BSNumbersViewDelegate

- (UIView *)numbersView:(BSNumbersView *)numbersView viewAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.row == 0 && indexPath.section != 0) {
        CGSize size = [numbersView sizeForRow:indexPath.row];
        NSString *text = [numbersView textAtIndexPath:indexPath];
        
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
    return nil;
}

- (NSAttributedString *)numbersView:(BSNumbersView *)numbersView attributedStringAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 1 && indexPath.section != 0) {
        NSString *text = [numbersView textAtIndexPath:indexPath];
        NSMutableAttributedString *string = [[NSMutableAttributedString alloc]initWithString:text];
        
        [string addAttributes:@{NSForegroundColorAttributeName: [UIColor redColor],
                                NSFontAttributeName: [UIFont systemFontOfSize:11]} range:NSMakeRange(0, 2)];
        [string addAttributes:@{NSFontAttributeName: [UIFont systemFontOfSize:19]} range:NSMakeRange(2, text.length - 2)];
        return string;
    }
    return nil;
}

- (void)numbersView:(BSNumbersView *)numbersView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    NSLog(@"section = %ld, row = %ld", (long)indexPath.section, (long)indexPath.row);
}
```
