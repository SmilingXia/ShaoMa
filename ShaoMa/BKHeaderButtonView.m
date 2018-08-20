//
//  BKHeaderButtonView.m
//  BangKao
//
//  Created by xia on 2017/4/12.
//  Copyright © 2017年 肖杰. All rights reserved.
//

#import "BKHeaderButtonView.h"
#import "XJFConstants.h"
#import "Masonry.h"

@interface BKHeaderButtonView(){
    float headBtnWidth;
    float headBtnHeight;
}

@property (nonatomic, strong) NSArray *headerButtonTitleArray;
@property (nonatomic, strong) UIButton *headButton;
@property (nonatomic, strong) UIView *headButtonSelectView;
@property (nonatomic, strong) UIView *henxianView;
@property (nonatomic, assign) BOOL  isShowSelectView;

@end

@implementation BKHeaderButtonView

- (instancetype)initWithViewHeight:(float)viewHeight{
    self = [super init];
    if (self) {
        headBtnHeight = viewHeight;
        self.backgroundColor = [UIColor whiteColor];
    }
    return self;
}

- (instancetype)init{
    self = [super init];
    if (self) {
        headBtnHeight = 60;
        self.backgroundColor = [UIColor whiteColor];
    }
    return self;
}


- (void)setArray:(NSArray *)headerButtonTitleArray{
    self.headerButtonTitleArray = headerButtonTitleArray;
    headBtnWidth = App_Frame_Width/headerButtonTitleArray.count;
    
    if (self.headerButtonTitleArray.count > 1) {
        [self loadSubView];
    }else{
        [self loadSubViewOne];
    }
}

- (void)yingchengHuatiao:(BOOL)isShow{
    self.isShowSelectView = isShow;
    self.headButtonSelectView.hidden = self.isShowSelectView;
}

- (void)setOnclickButtonIndex:(int)buttonIndex{
    UIButton *onclickButton = [self viewWithTag:buttonIndex + 1000];
    [self headSelectButtonOnclick:onclickButton];
}

- (void)setOnclickButtonIndex:(int)buttonIndex andIshuiDiao:(BOOL)isHuidiao{
    UIButton *onclickButton = [self viewWithTag:buttonIndex + 1000];
    int jianju;
    if (self.headButton.tag != onclickButton.tag) {
        self.headButton.selected = NO;
        self.headButton = onclickButton;
        jianju = (int)self.headButton.tag - 1000;
        
        [self.headButtonSelectView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.headButton.mas_bottom);
            make.height.mas_equalTo(1.5);
            make.left.right.equalTo(self.headButton);
        }];
        [UIView animateWithDuration:0.3 animations:^{
            [self layoutIfNeeded];
        }];
    }
    self.headButton.selected = YES;
}


- (void)loadSubViewOne{
    [self.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    if (self.headButton) {
        [self.headButton removeFromSuperview];
        self.headButton = nil;
    }
    self.headButton = [[UIButton alloc] init];
    [self addSubview:self.headButton];
    [self.headButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.mas_equalTo(0);
        make.height.mas_equalTo(headBtnHeight - 2);
    }];
    [self.headButton setTitle:[self.headerButtonTitleArray objectAtIndex:0] forState:UIControlStateNormal];
    self.headButton.titleLabel.font = [UIFont systemFontOfSize:13];
    [self.headButton setTitleColor:TXColor(146, 146, 146) forState:UIControlStateNormal];
    [self.headButton setTitleColor:TXColor(0, 133, 241) forState:UIControlStateSelected];
    [self.headButton addTarget:self action:@selector(headSelectButtonOnclick:) forControlEvents:UIControlEventTouchUpInside];
    self.headButton.selected = YES;
    
    self.headButtonSelectView = [[UIView alloc]init];
    [self addSubview:self.headButtonSelectView];
    [self.headButtonSelectView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.headButton.mas_bottom);
        make.height.mas_equalTo(1.5);
        make.left.right.equalTo(self.headButton);
    }];
    self.headButtonSelectView.backgroundColor = TXColor(0, 133, 241);
    self.headButtonSelectView.hidden = self.isShowSelectView;
    self.henxianView = [[UIView alloc] init];
    [self addSubview:self.henxianView];
    [self.henxianView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.left.right.mas_equalTo(0);
        make.height.mas_equalTo(0.5);
    }];
    self.henxianView.backgroundColor = TXColor(146, 146, 146);
}

- (void)loadSubView{
    [self.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    NSMutableArray *buttonArray = [NSMutableArray array];
    for (int i = 0; i < self.headerButtonTitleArray.count; i++) {
        UIButton *headSelectButton = [[UIButton alloc] init];
        [self addSubview:headSelectButton];
        headSelectButton.frame = CGRectMake(i*headBtnWidth,0, headBtnWidth, headBtnHeight - 2);
        [headSelectButton setTitle:[self.headerButtonTitleArray objectAtIndex:i] forState:UIControlStateNormal];
        headSelectButton.titleLabel.font = [UIFont systemFontOfSize:13];
        [headSelectButton setTitleColor:TXColor(146, 146, 146) forState:UIControlStateNormal];
        [headSelectButton setTitleColor:TXColor(0, 133, 241) forState:UIControlStateSelected];
        [headSelectButton addTarget:self action:@selector(headSelectButtonOnclick:) forControlEvents:UIControlEventTouchUpInside];
        headSelectButton.tag = i+1000;
        [buttonArray addObject:headSelectButton];
        if (i == 0) {
            headSelectButton.selected = YES;
            self.headButton = headSelectButton;
        }
    }
    [buttonArray mas_distributeViewsAlongAxis:MASAxisTypeHorizontal withFixedSpacing:10 leadSpacing:0 tailSpacing:0];
    [buttonArray mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(0);
        make.height.mas_equalTo(headBtnHeight - 2);
    }];
    for (int i = 0; i < buttonArray.count - 1; i++) {
        UIButton *senderButton = buttonArray[i];
        UIView *fengeXian = [[UIView alloc] init];
        [self addSubview:fengeXian];
        [fengeXian mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.mas_equalTo(1);
            make.left.mas_equalTo(senderButton.mas_right).offset(4.5);
            make.top.mas_equalTo(5);
            make.bottom.mas_equalTo(-7);
        }];
        fengeXian.backgroundColor = TXColor(146, 146, 146);
    }
    self.headButtonSelectView = [[UIView alloc]init];
    [self addSubview:self.headButtonSelectView];
    [self.headButtonSelectView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.headButton.mas_bottom);
        make.height.mas_equalTo(1.5);
        make.left.right.equalTo(self.headButton);
    }];
    self.headButtonSelectView.backgroundColor = TXColor(0, 133, 241);
    
    
    self.henxianView = [[UIView alloc] init];
    [self addSubview:self.henxianView];
    [self.henxianView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.left.right.mas_equalTo(0);
        make.height.mas_equalTo(0.5);
    }];
    self.henxianView.backgroundColor = TXColor(146, 146, 146);
}

- (void)headSelectButtonOnclick:(UIButton *)sender{
    int jianju;
    if (self.headButton.tag != sender.tag) {
        self.headButton.selected = NO;
        self.headButton = sender;
        jianju = (int)self.headButton.tag - 1000;
        
        [self.headButtonSelectView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.headButton.mas_bottom);
            make.height.mas_equalTo(1.5);
            make.left.right.equalTo(self.headButton);
        }];
        [UIView animateWithDuration:0.3 animations:^{
            [self layoutIfNeeded];
        }];
        if (self.headerButtonBlock) {
            self.headerButtonBlock(jianju);
        }
    }
    self.headButton.selected = YES;
}

@end
