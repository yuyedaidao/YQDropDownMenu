//
//  YQDropDownMenu.h
//  YQDropDownMenu
//
//  Created by Wang on 2017/5/3.
//  Copyright © 2017年 Wang. All rights reserved.
//

#import <UIKit/UIKit.h>

@class YQDropDownMenu;

@protocol YQDropDownMenuDelegate <NSObject>

- (void)dropDownMenu:(YQDropDownMenu *)menu didClickRow:(NSInteger)row;
- (void)dropDownMenuMoreAction:(YQDropDownMenu *)menu;
@end

@interface YQDropDownMenu : UIView

@property (strong, nonatomic) NSArray<NSString *> *titleArray;
@property (assign, nonatomic) CGFloat rowHeight;
@property (weak, nonatomic) UIView *locationReferView;
@property (weak, nonatomic) id<YQDropDownMenuDelegate> delegate;
@property (assign, nonatomic) CGFloat margin;
@property (assign, nonatomic) CGFloat arrowScale;
@property (strong, nonatomic) UIFont *titleFont;
@property (strong, nonatomic) UIColor *titleColor;
@property (strong, nonatomic) UIFont *moreActionFont;
@property (strong, nonatomic) UIColor *moreActionColor;
+ (instancetype)create;
- (void)show;
- (void)hide;

@end
