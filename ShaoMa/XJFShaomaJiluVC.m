//
//  XJFShaomaJiluVC.m
//  ShaoMa
//
//  Created by xia on 2017/8/26.
//  Copyright © 2017年 cn.xia. All rights reserved.
//

#import "XJFShaomaJiluVC.h"
#import "BKHeaderButtonView.h"
#import "XJFConstants.h"
#import "Masonry.h"
#import "BKArchive.h"
#import "XJFUpdateValueVC.h"

@interface XJFShaomaJiluVC ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) BKHeaderButtonView *headerButtonView;
@property (nonatomic, strong) NSMutableArray *headerViewArray;
@property (nonatomic, assign) int            selectIndexVC;

@property (nonatomic, strong) NSArray           *todaysKeyData;            //今天的头数据
@property (nonatomic, strong) NSMutableArray    *todaysData;               //今天的数据
@property (nonatomic, strong) NSArray           *allKeyTheData;            //全部的头数据
@property (nonatomic, strong) NSMutableArray    *allValueTheData;          //全部的数据

@property (nonatomic, strong) NSArray           *displayKeyTheData;        //显示的头数据
@property (nonatomic, strong) NSMutableArray    *displayTheData;           //显示的数据




@end

@implementation XJFShaomaJiluVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"扫码记录";
    self.view.backgroundColor = [UIColor whiteColor];
    [self loadListViewHeaderButtonView];
    [self loadTbaleViewLayout];
    [self getTableViewDateScrous];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self getTableViewDateScrous];
}


#pragma mark - 得到数据源
- (void)getTableViewDateScrous{
    NSMutableDictionary *dataDictionary= (NSMutableDictionary *)[BKArchive unarchiveDataWithFileName:SweepRecordList];
    if (dataDictionary) {
        //获取到今天的数据
        NSDate *today = [NSDate date];
        NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
        [dateFormat setDateFormat:@"yyyy-MM-dd"];
        NSString *vlueCodeDictTime = [dateFormat stringFromDate:today];
        self.allValueTheData = [NSMutableArray array];
        self.allKeyTheData = [dataDictionary allKeys];
        self.todaysData = [NSMutableArray array];
        for (NSString *kayString in self.allKeyTheData) {
            if (self.todaysData.count < 1 && [kayString isEqualToString:vlueCodeDictTime]) {
                NSMutableArray *todayMutabArray = (NSMutableArray *)[dataDictionary objectForKey:vlueCodeDictTime];
                [self.todaysData addObject:todayMutabArray];
                self.todaysKeyData = @[vlueCodeDictTime];
            }
            NSMutableArray *valueArray = (NSMutableArray *)[dataDictionary objectForKey:kayString];
            [self.allValueTheData addObject:valueArray];
        }
        self.displayTheData = nil;
        self.displayKeyTheData = nil;
        if (self.selectIndexVC == 0) {
            self.displayTheData = self.allValueTheData;
            self.displayKeyTheData = self.allKeyTheData;
        }else{
            self.displayTheData = self.todaysData;
            self.displayKeyTheData = self.todaysKeyData;
        }
        [self.tableView reloadData];
    }else{
        //显示暂无
    }
}

- (void)loadTbaleViewLayout{
    self.tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.separatorStyle = NO;
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.headerButtonView.mas_bottom).offset(0.5);
        make.left.bottom.right.mas_equalTo(0);
    }];
}


#pragma mark - 创建列表视图
- (void)loadListViewHeaderButtonView{
    //创建小题指示条
    if (self.headerViewArray) {
        self.headerViewArray = nil;
    }
    self.headerViewArray = [NSMutableArray array];
    [self.headerViewArray addObject:@"全部"];
    [self.headerViewArray addObject:@"今天"];
    if (!self.headerButtonView) {
        self.headerButtonView = [[BKHeaderButtonView alloc] initWithViewHeight:40];
        [self.view addSubview:self.headerButtonView];
        [self.headerButtonView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.mas_equalTo(0);
            make.height.mas_equalTo(40);
            make.top.mas_equalTo(64);
        }];
    }
    [self headerButtonViewBlock:self.headerViewArray];
}

- (void)headerButtonViewBlock:(NSMutableArray *)headerButtonTitleArray{
    [self.headerButtonView setArray:headerButtonTitleArray];
    [self.headerButtonView yingchengHuatiao:NO];
    WEAK_SELF;
    self.headerButtonView.headerButtonBlock = ^(int index) {
        STRONG_SELF;
        //加载 -- 选择的那个列表
        strongSelf.selectIndexVC = index;
        strongSelf.displayTheData = nil;
        strongSelf.displayKeyTheData = nil;
        if (strongSelf.selectIndexVC == 0) {
            strongSelf.displayTheData = strongSelf.allValueTheData;
            strongSelf.displayKeyTheData = strongSelf.allKeyTheData;
        }else{
            strongSelf.displayTheData = strongSelf.todaysData;
            strongSelf.displayKeyTheData = strongSelf.todaysKeyData;
        }
        [strongSelf.tableView reloadData];
    };
}


#pragma mark - tableview的代理方法实现
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.displayTheData.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    NSArray *countArray = self.displayTheData[section];
    return countArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 30;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.00001;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *headerView = [[UIView alloc] init];
    [headerView setBackgroundColor:[UIColor lightGrayColor]];
    UILabel *leftTimeLabel = [[UILabel alloc] init];
    [headerView addSubview:leftTimeLabel];
    UIButton *rightButton = [[UIButton alloc] init];
    [headerView addSubview:rightButton];
    
    [leftTimeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.mas_equalTo(0);
        make.left.mas_equalTo(10);
        make.right.mas_equalTo(rightButton.mas_left).offset(-10);
    }];
    [rightButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(30);
        make.width.mas_equalTo(35);
        make.right.mas_equalTo(-10);
        make.centerY.mas_equalTo(0);
    }];
    leftTimeLabel.text = self.displayKeyTheData[section];
    leftTimeLabel.font = [UIFont systemFontOfSize:15];
    leftTimeLabel.textColor = [UIColor whiteColor];
    rightButton.titleLabel.font = [UIFont systemFontOfSize:14];
    [rightButton setTitle:@"复制" forState:UIControlStateNormal];
    [rightButton setTitleColor:TXColor(0, 125, 255) forState:UIControlStateNormal];
    rightButton.tag  = 1000 + section;
    [rightButton addTarget:self action:@selector(rightButtonFuzhiOnclick:) forControlEvents:UIControlEventTouchUpInside];
    
    return headerView;
}

- (void)rightButtonFuzhiOnclick:(UIButton *)sender{
    UIPasteboard *copy = [UIPasteboard generalPasteboard];
    NSArray *dataValueArray = nil;
    int contentIndex = (int)sender.tag - 1000;
    NSString *copyAddString = self.displayKeyTheData[contentIndex];
    if (self.selectIndexVC == 0) {
        //全部
        dataValueArray = [self.allValueTheData objectAtIndex:contentIndex];
    }else{
        //今天
        dataValueArray = [self.todaysData objectAtIndex:contentIndex];
    }
    for (NSDictionary *valueDict in dataValueArray) {
        copyAddString=[NSString stringWithFormat:@"%@\n%@ - %@",copyAddString,[valueDict objectForKey:@"vlueCode"],[valueDict objectForKey:@"codeName"]];
    }
    [copy setString:copyAddString];
    NSString *msg;
    if (copy == nil)      {
        msg = @"复制失败";
    }else{
        msg = @"复制成功";
    }
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示"
                                                    message:msg
                                                   delegate:nil
                                          cancelButtonTitle:nil
                                          otherButtonTitles:@"确定", nil , nil];
    [alert show];
}




- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 71;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [[UITableViewCell alloc] init];
    [cell setBackgroundColor:[UIColor whiteColor]];
    UILabel *label = [[UILabel alloc] init];
    [cell addSubview:label];
    [label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(5);
        make.left.mas_equalTo(10);
        make.right.mas_equalTo(-10);
        make.height.mas_equalTo(20);
    }];
    label.textAlignment = NSTextAlignmentLeft;
    NSArray *countArray = self.displayTheData[indexPath.section];
    label.text = [NSString stringWithFormat:@"码值:  %@",[countArray[indexPath.row] objectForKey:@"vlueCode"]];
    label.font = [UIFont systemFontOfSize:14];
    label.textColor = [UIColor lightGrayColor];
    
    
    UILabel *label1 = [[UILabel alloc] init];
    [cell addSubview:label1];
    [label1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(label.mas_bottom);
        make.left.mas_equalTo(10);
        make.right.mas_equalTo(-10);
        make.height.mas_equalTo(20);
    }];
    label1.textAlignment = NSTextAlignmentLeft;
    label1.text = [NSString stringWithFormat:@"时间:  %@",[countArray[indexPath.row] objectForKey:@"codeTime"]];
    label1.font = [UIFont systemFontOfSize:14];
    label1.textColor = [UIColor lightGrayColor];
    
    UILabel *label2 = [[UILabel alloc] init];
    [cell addSubview:label2];
    [label2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(label1.mas_bottom);
        make.left.mas_equalTo(10);
        make.right.mas_equalTo(-10);
        make.height.mas_equalTo(20);
    }];
    NSString *beiZhuString = [countArray[indexPath.row] objectForKey:@"codeName"];
    if (beiZhuString == nil || [beiZhuString isEqualToString:@""]) {
        beiZhuString = @"默认无";
    }
    label2.textAlignment = NSTextAlignmentLeft;
    label2.text = [NSString stringWithFormat:@"备注:  %@",beiZhuString];
    label2.font = [UIFont systemFontOfSize:14];
    label2.textColor = [UIColor lightGrayColor];
    
    UIView *lineView = [[UIView alloc] init];
    [cell addSubview:lineView];
    [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(0.5);
        make.left.bottom.right.mas_equalTo(0);
    }];
    lineView.backgroundColor = [UIColor lightGrayColor];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    //点击修改信息
    XJFUpdateValueVC *updateVC = [[XJFUpdateValueVC alloc] init];
    updateVC.arrayIndexRow = (int)indexPath.row;
    updateVC.vlueCodeDictTime = self.displayKeyTheData[indexPath.section];
    [self.navigationController pushViewController:updateVC animated:YES];
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
