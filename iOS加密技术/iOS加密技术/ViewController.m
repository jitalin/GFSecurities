//
//  ViewController.m
//  iOS加密技术
//
//  Created by 高飞 on 16/11/10.
//  Copyright © 2016年 高飞. All rights reserved.
//

#import "ViewController.h"
#import "NSString+MySecurities.h"
@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    //[self strBase64Encode];
    
    [self imageBase64Encode];
    

    NSString* base64Str = [NSString base64EncryptWithSourceStr:@"hello world"];
    NSLog(@"%@",base64Str);
 NSString* md5Str =  [@"hello world" md5Str];
    NSLog(@"%@",md5Str);
    
}
//字符串加密解密
- (void)strBase64Encode{
    /*对这个字符串进行 base64 加密
     1> 需要将原来的数据转换成二进制数据NSData.
     2> 将data进行base64编码---加密
     3> 返回的是 base64 加密之后的字符串.*/
    NSString *str = @"hello world";
    
    NSData *data = [str dataUsingEncoding:NSUTF8StringEncoding];
    NSString *base64Str = [data base64EncodedStringWithOptions:0];
    NSLog(@"字符串加密结果：%@",base64Str);
    
    /*对这个字符串进行 base64 解密
     1>根据base64 加密之后的字符串解密生成二进制data
     2>返回解密后的字符串
     */
    NSData* data1 = [[NSData alloc]initWithBase64EncodedString:base64Str options:0];
    NSString* str1 = [[NSString alloc]initWithData:data1 encoding:NSUTF8StringEncoding];
    NSLog(@"解密的结果为%@",str1);
    
    
    
}
//图片加密解密
- (void)imageBase64Encode{
    /*对一张图片进行 base64 加密
     1> 将本地图片路径转换成二进制数据NSData.
     2> 将data进行base64编码---加密
     3>将编码后的base64data写入文件。*/
    NSString *path = [[NSBundle mainBundle]pathForResource:@"1.jpg" ofType:nil];
    ;
    NSData *imageData = [NSData dataWithContentsOfFile:path];
    NSData *base64Data = [imageData base64EncodedDataWithOptions:0];

    /*对一张图片进行 base64 解密
     1> 将base64Data进行解密转成NSData类型的endata
     2>将endata转换成image*/
    
    NSData *encodeData = [[NSData alloc] initWithBase64EncodedData:base64Data options:0];
   
    UIImage *image = [UIImage imageWithData:encodeData];
    UIImageView* imageView = [[UIImageView alloc]initWithFrame:self.view.bounds];
    imageView.image = image;
    [self.view addSubview:imageView];
    
}
@end
