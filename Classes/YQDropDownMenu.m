    //
    //  YQDropDownMenu.m
    //  YQDropDownMenu
    //
    //  Created by Wang on 2017/5/3.
    //  Copyright © 2017年 Wang. All rights reserved.
    //

#import "YQDropDownMenu.h"
#define SINGLE_LINE_WIDTH           (1 / [UIScreen mainScreen].scale)
#define SINGLE_LINE_ADJUST_OFFSET   ((1 / [UIScreen mainScreen].scale) / 2)

#define kTopSpaceConstraint 10.0f

@interface YQDropDownMenu () <UITableViewDelegate, UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) UIColor *lineColor;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *topSpaceConstraint;
@property (weak, nonatomic) UIView *hideHandlerView;
@end

@implementation YQDropDownMenu

/*
 // Only override drawRect: if you perform custom drawing.
 // An empty implementation adversely affects performance during animation.
 - (void)drawRect:(CGRect)rect {
 // Drawing code
 }
 */
+ (instancetype)create {
    YQDropDownMenu *menu = [[[NSBundle bundleForClass:self.class] loadNibNamed:@"YQDropDownMenu" owner:nil options:nil] lastObject];
    menu.rowHeight = 44;
    menu.margin = 15;
    menu.hidden = YES;
    return menu;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    if (self  = [super initWithCoder:aDecoder]) {
        _lineColor = [UIColor colorWithWhite:0.8 alpha:1];
        _arrowScale = 0.25;
        _titleFont = [UIFont systemFontOfSize:15];
        _moreActionFont = [UIFont systemFontOfSize:15];
        _titleColor = [UIColor colorWithRed: 99/255.0f green:114/255.0f blue:131/255.0f alpha:1];
        _moreActionColor = [UIColor colorWithRed: 33/255.0f green:150/255.0f blue:243/255.0f alpha:1];
        _hideWhenTouchOutside = YES;
    }
    return self;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"YQDropDownMenuCell"];
    self.topSpaceConstraint.constant = kTopSpaceConstraint + 1;
    self.tableView.clipsToBounds = YES;
    self.tableView.layer.cornerRadius = 10;
    UIView *footer = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 10, 1)];
    footer.backgroundColor = [UIColor clearColor];
    self.tableView.tableFooterView = footer;
    self.tableView.separatorInset = UIEdgeInsetsMake(0, 15, 0, 15);
}

- (void)show {
    NSAssert(_locationReferView, @"LocationReferView不能为空");
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    CGRect rect = [self.locationReferView.superview convertRect:self.locationReferView.frame toView:window];
    CGRect frame = CGRectMake(self.margin, CGRectGetMaxY(rect), CGRectGetWidth(window.bounds) - 2 * self.margin, self.rowHeight * (self.titleArray.count + 1) + kTopSpaceConstraint + 2);
    self.frame = frame;
    if (_hideWhenTouchOutside) {
        UIView *hideHandlerView = [[UIView alloc] initWithFrame:window.bounds];
        hideHandlerView.userInteractionEnabled = YES;
        hideHandlerView.backgroundColor = [UIColor clearColor];
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hide)];
        [hideHandlerView addGestureRecognizer:tap];
        self.hideHandlerView = hideHandlerView;
        [window addSubview:hideHandlerView];
    }
    [window addSubview:self];
    self.backgroundColor = [UIColor clearColor];
    self.tableView.rowHeight = self.rowHeight;
    [self.tableView reloadData];
    self.tableView.scrollEnabled = NO;
    self.hidden = NO;
}

- (void)hide {
    self.hidden = YES;
    [self.hideHandlerView removeFromSuperview];
    [self removeFromSuperview];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.titleArray.count + 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"YQDropDownMenuCell" forIndexPath:indexPath];
    if (indexPath.row == self.titleArray.count) {
        cell.textLabel.text = @"查看更多";
        cell.textLabel.textColor = _moreActionColor;
        cell.textLabel.font = _moreActionFont;
        cell.textLabel.textAlignment = NSTextAlignmentCenter;
    } else {
        cell.textLabel.text = self.titleArray[indexPath.row];
        cell.textLabel.textColor = _titleColor;
        cell.textLabel.font = _titleFont;
        cell.textLabel.textAlignment = NSTextAlignmentLeft;
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == self.titleArray.count) {
        if ([self.delegate respondsToSelector:@selector(dropDownMenuMoreAction:)]) {
            [self.delegate dropDownMenuMoreAction:self];
        }
    } else {
        if ([self.delegate respondsToSelector:@selector(dropDownMenu:didClickRow:)]) {
            [self.delegate dropDownMenu:self didClickRow:indexPath.row];
        }
    }
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (void)drawRect:(CGRect)rect {
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextBeginPath(context);
    
    CGFloat width = self.bounds.size.width;
    CGFloat height = self.bounds.size.height;
    CGFloat arrowCenterX = width * _arrowScale;
    CGMutablePathRef paths = CGPathCreateMutable();
    
    CGPathMoveToPoint(paths, NULL, arrowCenterX - kTopSpaceConstraint / 2, kTopSpaceConstraint + SINGLE_LINE_ADJUST_OFFSET);
    CGPathAddLineToPoint(paths, NULL, arrowCenterX,  SINGLE_LINE_ADJUST_OFFSET);
    CGPathAddLineToPoint(paths, NULL, arrowCenterX + kTopSpaceConstraint / 2, kTopSpaceConstraint + SINGLE_LINE_ADJUST_OFFSET);
    CGPathAddArcToPoint(paths, NULL, width - SINGLE_LINE_ADJUST_OFFSET, kTopSpaceConstraint, width - SINGLE_LINE_ADJUST_OFFSET, height - SINGLE_LINE_ADJUST_OFFSET, 8);
    CGPathAddArcToPoint(paths, NULL, width - SINGLE_LINE_ADJUST_OFFSET, height - SINGLE_LINE_ADJUST_OFFSET, SINGLE_LINE_ADJUST_OFFSET, height - SINGLE_LINE_ADJUST_OFFSET, 8);
    CGPathAddArcToPoint(paths, NULL, SINGLE_LINE_ADJUST_OFFSET, height - SINGLE_LINE_ADJUST_OFFSET,SINGLE_LINE_ADJUST_OFFSET, kTopSpaceConstraint, 8);
    CGPathAddArcToPoint(paths, NULL,SINGLE_LINE_ADJUST_OFFSET, kTopSpaceConstraint, arrowCenterX - kTopSpaceConstraint / 2, kTopSpaceConstraint + SINGLE_LINE_ADJUST_OFFSET, 8);
    CGPathAddLineToPoint(paths, NULL, arrowCenterX - kTopSpaceConstraint / 2, kTopSpaceConstraint + SINGLE_LINE_ADJUST_OFFSET);
    
    CGContextAddPath(context, paths);
    [[UIColor whiteColor] setFill];
    CGContextFillPath(context);
    CGContextAddPath(context, paths);
    CGContextSetLineWidth(context, SINGLE_LINE_WIDTH);
    [self.lineColor setStroke];
    CGContextStrokePath(context);
}
@end
