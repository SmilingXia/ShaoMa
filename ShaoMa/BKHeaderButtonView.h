//
//  BKHeaderButtonView.h
//  BangKao
//
//  Created by xia on 2017/4/12.
//  Copyright © 2017年 肖杰. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BKHeaderButtonView : UIView

- (instancetype)initWithViewHeight:(float)viewHeight;

/**
 *  按钮切换
 */
@property (nonatomic, copy) void(^headerButtonBlock)(int);


/**
 *  设置被选中的按钮tag
 */
- (void)setOnclickButtonIndex:(int)buttonIndex;


/**
 *  设置被选中的按钮tag -- isHuidiao 需不需要回调
 */
- (void)setOnclickButtonIndex:(int)buttonIndex andIshuiDiao:(BOOL)isHuidiao;


/**
 *  顶部段按钮title
 */
- (void)setArray:(NSArray *)headerButtonTitleArray;

/**
 *  是否隐藏滑条
 */
- (void)yingchengHuatiao:(BOOL)isShow;

@end
