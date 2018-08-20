//
//  XJFUpdateValueVC.m
//  ShaoMa
//
//  Created by xia on 2017/8/26.
//  Copyright © 2017年 cn.xia. All rights reserved.
//

#import "XJFUpdateValueVC.h"
#import "BKArchive.h"
#import "Masonry.h"
#import "XJFConstants.h"

@interface XJFUpdateValueVC ()<UITextFieldDelegate>

@property (nonatomic, strong) UITextField       *updateNameField;
@property (nonatomic, strong) NSMutableArray    *todayMutabArray;
@property (nonatomic, strong) NSDictionary      *todayDictionary;

@property (nonatomic, strong) UIButton          *updateNameButton;

@end

@implementation XJFUpdateValueVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"修改备注信息";
    self.view.backgroundColor = [UIColor whiteColor];
    //得到当前信息
    NSMutableDictionary *dataDictionary= (NSMutableDictionary *)[BKArchive unarchiveDataWithFileName:SweepRecordList];
    self.todayMutabArray = (NSMutableArray *)[dataDictionary objectForKey:_vlueCodeDictTime];
    self.todayDictionary = (NSDictionary *)self.todayMutabArray[_arrayIndexRow];
    [self.view addSubview:self.updateNameField];
    [self.updateNameField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(80);
        make.left.mas_equalTo(20);
        make.right.mas_equalTo(-20);
        make.height.mas_equalTo(40);
    }];
    self.updateNameField.placeholder = [self.todayDictionary objectForKey:@"codeName"];
    UIView *layerView = [[UIView alloc] init];
    [self.view addSubview:layerView];
    [layerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.updateNameField.mas_bottom);
        make.left.mas_equalTo(18);
        make.right.mas_equalTo(-18);
        make.height.mas_equalTo(0.5);
    }];
    [layerView setBackgroundColor:TXColor(110, 110, 110)];
    layerView.layer.cornerRadius = 0.1;
    layerView.clipsToBounds = YES;
    
    self.updateNameButton = [[UIButton alloc] init];
    [self.view addSubview:self.updateNameButton];
    [self.updateNameButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.updateNameField.mas_bottom).offset(30);
        make.left.mas_equalTo(20);
        make.right.mas_equalTo(-20);
        make.height.mas_equalTo(40);
    }];
    self.updateNameButton.layer.cornerRadius = 2.0;
    self.updateNameButton.clipsToBounds = YES;
    [self.updateNameButton setBackgroundColor:TXColor(0, 125, 255)];
    [self.updateNameButton setTitle:@"确认修改" forState:UIControlStateNormal];
    [self.updateNameButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.updateNameButton addTarget:self action:@selector(updateNameButtonOnclick) forControlEvents:UIControlEventTouchUpInside];
}


- (void)updateNameButtonOnclick{
    self.updateNameField.text = [self.updateNameField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    if (self.updateNameField.text == nil || [self.updateNameField.text isEqualToString:@""]) {
        //不能为空
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示"
                                                        message:@"不能为空"
                                                       delegate:nil
                                              cancelButtonTitle:nil
                                              otherButtonTitles:@"确定", nil , nil];
        [alert show];
    }
    else if ([[self.todayDictionary objectForKey:@"codeName"] isEqualToString:self.updateNameField.text]) {
        //不能与修改前相同
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示"
                                                        message:@"不能与修改前相同"
                                                       delegate:nil
                                              cancelButtonTitle:nil
                                              otherButtonTitles:@"确定", nil , nil];
        [alert show];
    }else{
        NSMutableDictionary *modelDict= [NSMutableDictionary dictionary];
        [modelDict setObject:[self.todayDictionary objectForKey:@"vlueCode"] forKey:@"vlueCode"];
        [modelDict setObject:[self.todayDictionary objectForKey:@"codeTime"] forKey:@"codeTime"];
        [modelDict setObject:self.updateNameField.text forKey:@"codeName"];
        
        NSString *beiZhuString = [self.todayDictionary objectForKey:@"codeName"];
        if (beiZhuString == nil || [beiZhuString isEqualToString:@""]) {
            beiZhuString = @"默认无";
        }
        NSDate *today = [NSDate date];
        NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
        [dateFormat setDateFormat:@"yyyy-MM-dd HH:mm"];
        NSDictionary *upadteDictQian = @{@"updateTime":[dateFormat stringFromDate:today],
                                         @"updateName":beiZhuString};

        NSMutableArray *updateArray = (NSMutableArray *)[self.todayDictionary objectForKey:@"updateArray"];
        if (updateArray == nil) {
            updateArray = [NSMutableArray array];
        }
        [updateArray addObject:upadteDictQian];
        [modelDict setObject:updateArray forKey:@"updateArray"];
        [self.todayMutabArray replaceObjectAtIndex:_arrayIndexRow withObject:modelDict];
        
        NSMutableDictionary *dataDictionary = (NSMutableDictionary *)[BKArchive unarchiveDataWithFileName:SweepRecordList];
        [dataDictionary setObject:self.todayMutabArray forKey:_vlueCodeDictTime];
        [BKArchive archiveData:dataDictionary withFileName:SweepRecordList];
        [self alertviewNew:@"修改成功" andMessage:nil andButtonString:@"返回" andTag:10001];
    }
}

- (void)alertviewNew:(NSString *)titleString andMessage:(NSString *)msg andButtonString:(NSString *)buttonString andTag:(NSInteger)tag {
    //弹出扫码成功，确认继续扫码
    UIAlertView *alertview = [[UIAlertView alloc] initWithTitle:titleString
                                                        message:msg
                                                       delegate:self
                                              cancelButtonTitle:nil
                                              otherButtonTitles:buttonString, nil];
    alertview.tag = tag;
    [alertview show];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    switch (alertView.tag) {
        case 10001:
        case 10002:
        {
            if(buttonIndex==0){
                //移除扫描视图:
                [self.navigationController popViewControllerAnimated:YES];
            }
        }
    }
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    [self.updateNameField resignFirstResponder];
}

- (UITextField *)updateNameField{
    if (_updateNameField) {
        return _updateNameField;
    }
    _updateNameField = [[UITextField alloc] init];
    _updateNameField.tag = 1001;
    _updateNameField.textColor = [UIColor blackColor];
    _updateNameField.delegate = self;
    return _updateNameField;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
