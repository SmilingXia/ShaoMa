//
//  ViewController.m
//  ShaoMa
//
//  Created by xia on 2017/8/26.
//  Copyright © 2017年 cn.xia. All rights reserved.
//

#import "ViewController.h"
#import <AVFoundation/AVFoundation.h>
#import "BKArchive.h"
#import "XJFShaomaJiluVC.h"
#import "XJFShengChengErweimaVC.h"

@interface ViewController ()<AVCaptureMetadataOutputObjectsDelegate,UIAlertViewDelegate>

@property (nonatomic, strong) AVCaptureSession  *session;

@property (nonatomic, strong) UILabel   *labelShaoMaquYu;   //扫码区域

@property (nonatomic, strong) UIButton  *shaomiaoButton;    //开始扫码

@property (nonatomic, strong) UIButton  *shengChengButton;  //生成二维码

@property (nonatomic, strong) UIButton  *jiluButton;        //扫码记录

@end

@implementation ViewController

#pragma mark -- 调用扫描方法
- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"扫码";
    self.view.backgroundColor = [UIColor whiteColor];
    self.labelShaoMaquYu = [[UILabel alloc] init];
    [self.view addSubview:self.labelShaoMaquYu];
    self.labelShaoMaquYu.frame = CGRectMake(0, 100, self.view.bounds.size.width, 100);
    self.labelShaoMaquYu.backgroundColor = [UIColor clearColor];
    self.labelShaoMaquYu.layer.borderWidth = 1.0;
    self.labelShaoMaquYu.layer.cornerRadius = 1;
    self.labelShaoMaquYu.text = @"扫码区域";
    self.labelShaoMaquYu.textColor = [UIColor lightGrayColor];
    self.labelShaoMaquYu.textAlignment = NSTextAlignmentCenter;
    self.labelShaoMaquYu.layer.borderColor = [UIColor greenColor].CGColor;
    self.labelShaoMaquYu.hidden = YES;
    
    self.shaomiaoButton = [[UIButton alloc] init];
    [self.view addSubview:self.shaomiaoButton];
    self.shaomiaoButton.frame = CGRectMake((self.view.bounds.size.width - 300)/4, self.view.bounds.size.height - 70, 100, 30);
    [self.shaomiaoButton setBackgroundColor:[UIColor colorWithRed:0/255.0 green:125/255.0 blue:255.0/255.0 alpha:1.0]];
    self.shaomiaoButton.layer.cornerRadius = 1;
    self.shaomiaoButton.clipsToBounds = YES;
    [self.shaomiaoButton setTitle:@"开启扫码" forState:UIControlStateNormal];
    [self.shaomiaoButton setTitle:@"关闭扫码" forState:UIControlStateSelected];
    [self.shaomiaoButton addTarget:self action:@selector(shaomiaoButtonOnclick) forControlEvents:UIControlEventTouchUpInside];
    
    
    self.shengChengButton = [[UIButton alloc] init];
    [self.view addSubview:self.shengChengButton];
    self.shengChengButton.frame = CGRectMake((self.view.bounds.size.width - 300)/4 * 2 + 100, self.view.bounds.size.height - 70, 100, 30);
    [self.shengChengButton setBackgroundColor:[UIColor colorWithRed:0/255.0 green:125/255.0 blue:255.0/255.0 alpha:1.0]];
    self.shengChengButton.layer.cornerRadius = 1;
    self.shengChengButton.clipsToBounds = YES;
    [self.shengChengButton setTitle:@"生成二维码" forState:UIControlStateNormal];
    [self.shengChengButton addTarget:self action:@selector(shengChengButtonAction) forControlEvents:UIControlEventTouchUpInside];

    
    self.jiluButton = [[UIButton alloc] init];
    [self.view addSubview:self.jiluButton];
    self.jiluButton.frame = CGRectMake((self.view.bounds.size.width - 300)/4 * 3 + 200, self.view.bounds.size.height - 70, 100, 30);
    [self.jiluButton setBackgroundColor:[UIColor colorWithRed:0/255.0 green:125/255.0 blue:255.0/255.0 alpha:1.0]];
    self.jiluButton.layer.cornerRadius = 1;
    self.jiluButton.clipsToBounds = YES;
    [self.jiluButton setTitle:@"扫码记录" forState:UIControlStateNormal];
    [self.jiluButton addTarget:self action:@selector(jiluButtonOnclick) forControlEvents:UIControlEventTouchUpInside];
}


- (void)shaomiaoButtonOnclick{
    self.shaomiaoButton.selected = !self.shaomiaoButton.selected;
    self.labelShaoMaquYu.hidden = !self.shaomiaoButton.selected;
    if (self.shaomiaoButton.selected) {
        AVCaptureDevice *device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
        AVCaptureDeviceInput *input = [AVCaptureDeviceInput deviceInputWithDevice:device error:nil];
        if (input) {
            AVCaptureMetadataOutput *output = [[AVCaptureMetadataOutput alloc]init];
            [output setMetadataObjectsDelegate:self queue:dispatch_get_main_queue()];
            self.session = [[AVCaptureSession alloc]init];
            [_session setSessionPreset:AVCaptureSessionPresetHigh];
            [_session addInput:input];
            [_session addOutput:output];
            output.metadataObjectTypes = @[AVMetadataObjectTypeQRCode,AVMetadataObjectTypeEAN13Code, AVMetadataObjectTypeEAN8Code, AVMetadataObjectTypeCode128Code];
            AVCaptureVideoPreviewLayer *layer = [AVCaptureVideoPreviewLayer layerWithSession:_session];
            layer.videoGravity = AVLayerVideoGravityResizeAspectFill;
            //layer.frame = CGRectMake((self.view.bounds.size.width - 300)/2, 80, 300, 300);
            layer.frame = CGRectMake(0, 64, self.view.bounds.size.width, self.view.bounds.size.height-64);
            [self.view.layer insertSublayer:layer atIndex:0];
            //layer.cornerRadius = 10;
            output.rectOfInterest = CGRectMake((100.0 - 64)/layer.frame.size.height, 0, (200 - 64)/layer.frame.size.height, 1);
            [_session startRunning];
        }
    }else{
        [_session stopRunning];
        AVCaptureVideoPreviewLayer *layer = (AVCaptureVideoPreviewLayer *)[[self.view.layer sublayers] objectAtIndex:0];
        [layer removeFromSuperlayer];
    }
}


#pragma mark - 扫面结果在这个代理方法里获取到
-(void)captureOutput:(AVCaptureOutput *)captureOutput didOutputMetadataObjects:(NSArray *)metadataObjects fromConnection:(AVCaptureConnection *)connection{
    if (metadataObjects.count>0) {
        [_session stopRunning];
        AVMetadataMachineReadableCodeObject *metaDataObject = [metadataObjects objectAtIndex:0];
        [self needToBeSaved:metaDataObject.stringValue];
    }
}

#pragma mark - 将扫码结果存储起来 -- 判断是否被扫过
- (void)needToBeSaved:(NSString *)vlueCode{
    NSMutableDictionary *dataDictionary= (NSMutableDictionary *)[BKArchive unarchiveDataWithFileName:SweepRecordList];
    NSLog(@"%@",dataDictionary);
    if (dataDictionary == nil) {
        dataDictionary = [[NSMutableDictionary alloc] init];
    }
    NSDate *today = [NSDate date];
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:@"yyyy-MM-dd"];
    NSString *vlueCodeDictTime = [dateFormat stringFromDate:today];
    NSMutableArray *vlueCodeArray = (NSMutableArray *)[dataDictionary objectForKey:vlueCodeDictTime];
    if (vlueCodeArray == nil) {
        vlueCodeArray = [NSMutableArray array];
    }
    BOOL isChunzai = NO;
    if (vlueCodeArray.count > 0) {
        for (NSDictionary *modelDict in vlueCodeArray) {
            if ([[modelDict objectForKey:@"vlueCode"] isEqualToString:vlueCode]) {
                //输出已经存在 - 是否需要覆盖
                isChunzai = YES;
                [self alertviewNew:@"该码今天已经录入" andMessage:vlueCode andButtonString:@"继续扫码" andTag:10002];
                return;
            }
        }
    }
    if (!isChunzai) {
        //进行存储对象
        //弹窗是否添加备注
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"是否添加备注" message:nil preferredStyle:UIAlertControllerStyleAlert];
        [alert addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
        }];
        UIAlertAction *sure = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            if (![alert.textFields[0].text isEqualToString:@""]) {
                NSString *stringName = alert.textFields[0].text;
                [self saveValue:vlueCodeArray andVlueCode:vlueCode andStringName:stringName andDataDictionary:dataDictionary andVlueCodeDictTime:vlueCodeDictTime];
            }
        }];
        UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            NSString *stringName = @"默认无";
            [self saveValue:vlueCodeArray andVlueCode:vlueCode andStringName:stringName andDataDictionary:dataDictionary andVlueCodeDictTime:vlueCodeDictTime];
        }];
        [alert addAction:sure];
        [alert addAction:cancel];
        [self presentViewController:alert animated:YES completion:nil];
    }
}

- (void)saveValue:(NSMutableArray *)vlueCodeArray andVlueCode:(NSString *)vlueCode andStringName:(NSString *)stringName andDataDictionary:(NSMutableDictionary *)dataDictionary andVlueCodeDictTime:(NSString *)vlueCodeDictTime{
    NSDate *today = [NSDate date];
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:@"yyyy-MM-dd HH:mm"];
    NSDictionary *modelDict=@{@"vlueCode":vlueCode,@"codeTime":[dateFormat stringFromDate:today],@"codeName":stringName};
    [vlueCodeArray addObject:modelDict];
    [dataDictionary setObject:vlueCodeArray forKey:vlueCodeDictTime];
    [BKArchive archiveData:dataDictionary withFileName:SweepRecordList];
    [self alertviewNew:@"扫码成功,信息已存储" andMessage:vlueCode andButtonString:@"继续扫码" andTag:10001];
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
                self.shaomiaoButton.selected = NO;
                self.labelShaoMaquYu.hidden = YES;
                AVCaptureVideoPreviewLayer *layer = (AVCaptureVideoPreviewLayer *)[[self.view.layer sublayers] objectAtIndex:0];
                [layer removeFromSuperlayer];
                [self shaomiaoButtonOnclick];
            }
        }
    }
}

//查看扫码记录
- (void)jiluButtonOnclick{
    XJFShaomaJiluVC *smjl = [[XJFShaomaJiluVC alloc] init];
    [self.navigationController pushViewController:smjl animated:YES];
}


//生成二维码
- (void)shengChengButtonAction {
    XJFShengChengErweimaVC *erweimavc = [[XJFShengChengErweimaVC alloc] init];
    [self.navigationController pushViewController:erweimavc animated:YES];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}


@end
