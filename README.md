# GFSecurities
Some encryption methods used in iOS are collected and sorted out. Contains the BASE64, MD5, SHA, HMAC, AES encryption, and provides the corresponding interface.
收集整理了iOS常用的一些加密方法 包含了BASE64、MD5、SHA、HMAC、AES加密方式，并提供了相应的接口

/*    BASE64编码算法不算是真正的加密算法。
 MD5、SHA、HMAC这三种加密算法，可谓是非可逆加密，就是不可解密的加密方法,又称单向加密算法*/
#pragma mark--------******可逆的
#pragma mark--------******Base64内容传送编码被设计用来把任意序列的8位字节描述为一种不易被人直接识别的形式
//base64加密
+(NSString *)base64EncryptWithSourceStr:(NSString *)sourceStr;
//base64解密
+(NSString* )base64DecryptWithBase64Str:(NSString *)base64Str;

/*AES的算法总是相同的， 因此导致结果不一致的原因在于 加密设置的参数不一致 。于是先来看看在两个平台使用AES加密时需要统一的几个参数。 
 1>密钥长度（Key Size）key的长度有三种：128、192和256 bits
 2>加密模式（Cipher Mode）AES属于块加密（Block Cipher），块加密中有CBC、ECB、CTR、OFB、CFB 
 3>填充方式（Padding）iOS SDK中提供了PKCS7Padding,由于块加密只能对特定长度的数据块进行加密，因此CBC、ECB模式需要在最后一数据块加密前进行数据填充。（CFB，OFB和CTR模式由于与key进行加密操作的是上一块加密后的密文，因此不需要对最后一段明文进行填充）
 4>初始向量（Initialization Vector）使用除ECB以外的其他加密模式均需要传入一个初始向量，其大小与Block Size相等（AES的Block Size为128 bits）
*/
#pragma mark--------******AES加密//推荐使用+类方法
-(NSString *) aes256_encrypt:(NSString *)key;
+ (NSString *)encryptAES:(NSString *)content key:(NSString *)key;
//AES解密
-(NSString *) aes256_decrypt:(NSString *)key;
+ (NSString *)decryptAES:(NSString *)content key:(NSString *)key;

#pragma mark--------******以下为不可逆
#pragma mark--------******MD5 message-digest algorithm 5 （信息-摘要算法）
-(NSString*) md5Str;
-(NSString*) md5StrXor;//升级版，异或a^b,相同为0，不同为1；二进制
#pragma mark--------******HMAC基于密钥的Hash算法
-(NSString*) hmacForKey:(NSString*)key Str:(NSString*)str;

#pragma mark--------******SHA(Secure Hash Algorithm，安全散列算法），数字签名等密码学应用中重要的工具,严格来说，sha1（安全[哈希算法]）只是叫做一种算法，用于检验数据完整性，并不能叫做加密～
- (NSString *) sha1Encrypt:(NSString *)input ShaType:(NSInteger)shaType;
