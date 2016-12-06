//
//  NSString+MySecurities.m
//  iOS加密技术
//
//  Created by 高飞 on 16/11/10.
//  Copyright © 2016年 高飞. All rights reserved.
//

#import "NSString+MySecurities.h"
#import <CommonCrypto/CommonDigest.h>
#import <CommonCrypto/CommonHMAC.h>
#import <CommonCrypto/CommonCryptor.h>
#import "NSData+AES256_Encrypt.h"
@implementation NSString (MySecurities)
/**
 *  SHA的加密类型
 */
static NSInteger const shaType = CC_SHA1_DIGEST_LENGTH;
/**
 *  AES的初始向量的值
 */
static NSString *const kInitVector = @"16-Bytes--String";
/**
 *  确定密钥长度，这里选择 AES-128。
 */

static size_t const kKeySize = kCCKeySizeAES128;


-(NSString *)md5Str
{
    const char* myPassword = [self UTF8String];
    unsigned char md5c[16];
    CC_MD5(myPassword, (CC_LONG)strlen(myPassword), md5c);
    //转化成十六进制
    NSMutableString* md5Str =[NSMutableString string];
    for (int i = 0; i<16; i++) {
        [md5Str appendFormat:@"%02x",md5c[i]];
        
    }return [md5Str copy];
    
}
-(NSString *)md5StrXor//第二个升级版
{
    const char* myPassword = [self UTF8String];
    unsigned char md5c[16];
    CC_MD5(myPassword, (CC_LONG)strlen(myPassword), md5c);
    //转化成十六进制
    NSMutableString* md5Str =[NSMutableString string];
    [md5Str appendFormat:@"%02x",md5c[0]];
    for (int i = 0; i<16; i++) {
        [md5Str appendFormat:@"%02x",md5c[i]^md5c[0]];
        
    }return [md5Str copy];
    
}
/*对这个字符串进行 base64 加密
 1> 需要将原来的数据转换成二进制数据NSData.
 2> 将data进行base64编码---加密
 3> 返回的是 base64 加密之后的字符串.*/
+(NSString *)base64EncryptWithSourceStr:(NSString *)sourceStr{
    if (!sourceStr) {
        //如果sourceData则返回nil，不进行加密。
        return nil;
    }
    NSData *encodeData = [sourceStr dataUsingEncoding:NSUTF8StringEncoding];
    NSString *base64Str = [encodeData base64EncodedStringWithOptions:0];
    
    return base64Str;
}
/*对这个字符串进行 base64 解密
 1>根据base64 加密之后的字符串解密生成二进制data
 2>返回解密后的字符串
 */
+(NSString* )base64DecryptWithBase64Str:(NSString *)base64Str{
    if (!base64Str) {
        return nil;//如果sourceString则返回nil，不进行解密。
    }
    NSData* decodeData = [[NSData alloc]initWithBase64EncodedString:base64Str options:0];
    
    NSString* decodeStr = [[NSString alloc]initWithData:decodeData encoding:NSUTF8StringEncoding];
    
    return decodeStr;
}

/*HMAC:哈希带密钥的加密方式
 Key一般是指的secret串，text是base串。
 key是两个secret串用&连接起来的，比如说新浪微博，申请application时会得到一个api key和secret，获取request token的时候又获得了一个token secret。
 在获取access token的时候，key就是secret&token_secret.
 1>key:私钥
 2>str:需要加密的字符串
*/
-(NSString*) hmacForKey:(NSString*)key Str:(NSString*)str {
    
    const char *cKey  = [key cStringUsingEncoding:NSASCIIStringEncoding];
    const char *cStr = [str cStringUsingEncoding:NSUTF8StringEncoding];
    unsigned char cHMAC[CC_SHA256_DIGEST_LENGTH];
    
    CCHmac(kCCHmacAlgSHA256, cKey, strlen(cKey), cStr, strlen(cStr), cHMAC);
    
    NSData *HMAC = [[NSData alloc] initWithBytes:cHMAC length:sizeof(cHMAC)];
    
    NSString *hash =  [HMAC base64EncodedStringWithOptions:0];
    
    return hash;
}


/*sha1加密方式
shaType = CC_SHA1_DIGEST_LENGTH
只需要换掉CC_SHA1_DIGEST_LENGTH、CC_SHA256_DIGEST_LENGTH、CC_SHA384_DIGEST_LENGTH、CC_SHA512_DIGEST_LENGTH这个宏就可以了
 */
- (NSString *) sha1Encrypt:(NSString *)input ShaType:(NSInteger)shaType
{
//    const char *cstr = [input cStringUsingEncoding:NSUTF8StringEncoding];
//    NSData *data = [NSData dataWithBytes:cstr length:input.length];
    //需要加密的字符串里面增加了汉字（之前需要加密的字符串中无汉字
     NSData *data = [input dataUsingEncoding:NSUTF8StringEncoding];
    uint8_t digest[shaType];
    CC_SHA1(data.bytes, (unsigned int)data.length, digest);
    NSMutableString *output = [NSMutableString stringWithCapacity:shaType * 2];
    
    for(int i=0; i<shaType; i++) {
        [output appendFormat:@"%02x", digest[i]];
    }
    return output;
}









/*AES加密*/
-(NSString *) aes256_encrypt:(NSString *)key
{
    const char *cstr = [self cStringUsingEncoding:NSUTF8StringEncoding];
    NSData *data = [NSData dataWithBytes:cstr length:self.length];
    //对数据进行加密
    NSData *result = [data aes256_encrypt:key];
    
    //转换为2进制字符串
    if (result && result.length > 0) {
        
        Byte *datas = (Byte*)[result bytes];
        NSMutableString *output = [NSMutableString stringWithCapacity:result.length * 2];
        for(int i = 0; i < result.length; i++){
            [output appendFormat:@"%02x", datas[i]];
        }
        return output;
    }
    return nil;
}
/*
 AES解密
 */
-(NSString *) aes256_decrypt:(NSString *)key
{
    //转换为2进制Data
    NSMutableData *data = [NSMutableData dataWithCapacity:self.length / 2];
    unsigned char whole_byte;
    char byte_chars[3] = {'\0','\0','\0'};
    int i;
    for (i=0; i < [self length] / 2; i++) {
        byte_chars[0] = [self characterAtIndex:i*2];
        byte_chars[1] = [self characterAtIndex:i*2+1];
        whole_byte = strtol(byte_chars, NULL, 16);
        [data appendBytes:&whole_byte length:1];
    }
    
    //对数据进行解密
    NSData* result = [data aes256_decrypt:key];
    if (result && result.length > 0) {
        return [[NSString alloc] initWithData:result encoding:NSUTF8StringEncoding];
    }
    return nil;
}
//AES加密
+ (NSString *)encryptAES:(NSString *)content key:(NSString *)key {
    
    NSData *contentData = [content dataUsingEncoding:NSUTF8StringEncoding];
    NSUInteger dataLength = contentData.length;
    
    // 为结束符'\\0' +1
    char keyPtr[kKeySize + 1];
    memset(keyPtr, 0, sizeof(keyPtr));
    [key getCString:keyPtr maxLength:sizeof(keyPtr) encoding:NSUTF8StringEncoding];
    
    // 密文长度 <= 明文长度 + BlockSize
    size_t encryptSize = dataLength + kCCBlockSizeAES128;
    void *encryptedBytes = malloc(encryptSize);
    size_t actualOutSize = 0;
    
    NSData *initVector = [kInitVector dataUsingEncoding:NSUTF8StringEncoding];
    
    CCCryptorStatus cryptStatus = CCCrypt(kCCEncrypt,
                                          kCCAlgorithmAES,
                                          kCCOptionPKCS7Padding,  // 系统默认使用 CBC，然后指明使用 PKCS7Padding
                                          keyPtr,
                                          kKeySize,
                                          initVector.bytes,
                                          contentData.bytes,
                                          dataLength,
                                          encryptedBytes,
                                          encryptSize,
                                          &actualOutSize);
    
    if (cryptStatus == kCCSuccess) {
        // 对加密后的数据进行 base64 编码
        return [[NSData dataWithBytesNoCopy:encryptedBytes length:actualOutSize] base64EncodedStringWithOptions:NSDataBase64EncodingEndLineWithLineFeed];
    }
    free(encryptedBytes);
    return nil;
}
//AES解密
+ (NSString *)decryptAES:(NSString *)content key:(NSString *)key {
    // 把 base64 String 转换成 Data
    NSData *contentData = [[NSData alloc] initWithBase64EncodedString:content options:NSDataBase64DecodingIgnoreUnknownCharacters];
    NSUInteger dataLength = contentData.length;
    
    char keyPtr[kKeySize + 1];
    memset(keyPtr, 0, sizeof(keyPtr));
    [key getCString:keyPtr maxLength:sizeof(keyPtr) encoding:NSUTF8StringEncoding];
    
    size_t decryptSize = dataLength + kCCBlockSizeAES128;
    void *decryptedBytes = malloc(decryptSize);
    size_t actualOutSize = 0;
    
    NSData *initVector = [kInitVector dataUsingEncoding:NSUTF8StringEncoding];
    
    CCCryptorStatus cryptStatus = CCCrypt(kCCDecrypt,
                                          kCCAlgorithmAES,
                                          kCCOptionPKCS7Padding,
                                          keyPtr,
                                          kKeySize,
                                          initVector.bytes,
                                          contentData.bytes,
                                          dataLength,
                                          decryptedBytes,
                                          decryptSize,
                                          &actualOutSize);
    
    if (cryptStatus == kCCSuccess) {
        return [[NSString alloc] initWithData:[NSData dataWithBytesNoCopy:decryptedBytes length:actualOutSize] encoding:NSUTF8StringEncoding];
    }
    free(decryptedBytes);
    return nil;
}
@end
