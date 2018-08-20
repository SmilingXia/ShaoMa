//
//  XJFShengChengErweimaVC.m
//  ShaoMa
//
//  Created by 夏江福 on 2018/7/19.
//  Copyright © 2018年 cn.xia. All rights reserved.
//

#import "XJFShengChengErweimaVC.h"
#import "Masonry.h"

@interface XJFShengChengErweimaVC ()

@property (nonatomic, strong) UIImageView   *erweimaImageView;

@property (nonatomic, strong) UITextField   *inputTextField;

@property (nonatomic, strong) UIButton      *generateButton;

@end

@implementation XJFShengChengErweimaVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"二维码生成";
    self.view.backgroundColor = [UIColor whiteColor];
    
    
    self.inputTextField = [[UITextField alloc] init];
    [self.view addSubview:self.inputTextField];
    self.inputTextField.frame = CGRectMake(25, 64 + 20, self.view.bounds.size.width - 100, 30);
    self.inputTextField.layer.borderWidth = 1.0f;
    self.inputTextField.layer.cornerRadius = 3.0f;
    
    
    
    self.generateButton = [[UIButton alloc] init];
    [self.view addSubview:self.generateButton];
    self.generateButton.frame = CGRectMake(CGRectGetMaxX(self.inputTextField.frame) + 10, 64 + 20, 40, 30);
    [self.generateButton setBackgroundColor:[UIColor colorWithRed:0/255.0 green:125/255.0 blue:255.0/255.0 alpha:1.0]];
    self.generateButton.layer.cornerRadius = 1;
    self.generateButton.clipsToBounds = YES;
    [self.generateButton setTitle:@"生成" forState:UIControlStateNormal];
    [self.generateButton addTarget:self action:@selector(shengChengButtonAction) forControlEvents:UIControlEventTouchUpInside];
    
    
    self.erweimaImageView = [[UIImageView alloc] init];
    [self.view addSubview:self.erweimaImageView];
    self.erweimaImageView.backgroundColor = [UIColor lightGrayColor];
    
    [self.erweimaImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.mas_equalTo(0);
        make.width.height.mas_equalTo(100);
    }];
}


//生成二维码
- (void)shengChengButtonAction {
    // 1. 创建一个二维码滤镜实例(CIFilter)
    CIFilter *filter = [CIFilter filterWithName:@"CIQRCodeGenerator"];
    // 滤镜恢复默认设置
    [filter setDefaults];
    
    // 2. 给滤镜添加数据
    NSData *data = [self.inputTextField.text dataUsingEncoding:NSUTF8StringEncoding];
    // 使用KVC的方式给filter赋值
    [filter setValue:data forKeyPath:@"inputMessage"];
    
    // 3. 生成二维码
    CIImage *image = [filter outputImage];
    
    // 4. 显示二维码
    self.erweimaImageView.image = [self createNonInterpolatedUIImageFormCIImage:image withSize:100];
}


- (UIImage *)createNonInterpolatedUIImageFormCIImage:(CIImage *)image withSize:(CGFloat) size

{
    
    CGRect extent = CGRectIntegral(image.extent);
    
    CGFloat scale = MIN(size/CGRectGetWidth(extent), size/CGRectGetHeight(extent));
    
    
    
    //1.创建bitmap;
    
    size_t width = CGRectGetWidth(extent) * scale;
    
    size_t height = CGRectGetHeight(extent) * scale;
    
    CGColorSpaceRef cs = CGColorSpaceCreateDeviceGray();
    
    CGContextRef bitmapRef = CGBitmapContextCreate(nil, width, height, 8, 0, cs, (CGBitmapInfo)kCGImageAlphaNone);
    
    CIContext *context = [CIContext contextWithOptions:nil];
    
    CGImageRef bitmapImage = [context createCGImage:image fromRect:extent];
    
    CGContextSetInterpolationQuality(bitmapRef, kCGInterpolationNone);
    
    CGContextScaleCTM(bitmapRef, scale, scale);
    
    CGContextDrawImage(bitmapRef, extent, bitmapImage);
    
    
    
    //2.保存bitmap到图片
    
    CGImageRef scaledImage = CGBitmapContextCreateImage(bitmapRef);
    
    CGContextRelease(bitmapRef);
    
    CGImageRelease(bitmapImage);
    
    return [UIImage imageWithCGImage:scaledImage];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
