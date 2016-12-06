//
//  NSData+AES256_Encrypt.h
//  iOS加密技术
//
//  Created by 高飞 on 16/11/10.
//  Copyright © 2016年 高飞. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSData (AES256_Encrypt)
-(NSData *) aes256_encrypt:(NSString *)key;
-(NSData *) aes256_decrypt:(NSString *)key;
@end
