//
//  NSData+3DES.m
//  SHHFrameWorkWithNaviAndTabBar
//
//  Created by zhang yinglong on 12-11-6.
//  Copyright (c) 2012年 sui huan. All rights reserved.
//

#import "NSData+3DES.h"
#import <CommonCrypto/CommonCrypto.h>

//注册/登录-的iv
static Byte iv[] = {'9','6','3','2','5','8','7','1'};

@implementation NSData (TripleDES)

-(NSData *) tripleDESEncrypt:(NSString *)key
{
                NSLog(@"----test-1-1-%@",self);
    
    char keyPtr[kCCKeySize3DES + 1];
    bzero(keyPtr, sizeof(keyPtr));
    [key getCString:keyPtr maxLength:sizeof(keyPtr) encoding:NSUTF8StringEncoding];
    
    NSUInteger dataLength = [self length];
    size_t bufferSize = dataLength + kCCKeySize3DES;
    Byte *buffer = malloc(bufferSize);
    size_t numByteEncrypted = 0;
    
    CCCryptorStatus cryptorStatus = CCCrypt(kCCEncrypt,
                                            kCCAlgorithm3DES,
                                            kCCOptionPKCS7Padding,
                                            keyPtr,
                                            kCCKeySize3DES,
                                            iv,
                                            [self bytes],
                                            dataLength,
                                            buffer,
                                            bufferSize,
                                            &numByteEncrypted);
    if (cryptorStatus == kCCSuccess)
    {
        NSData *a=[NSData dataWithBytesNoCopy:buffer length:numByteEncrypted];
                        NSLog(@"----test-1-2-%@",a);
        
        
        return a;
    }
    free(buffer);
    return nil;
}

-(NSData *) tripleDESDecrypt:(NSString *)key
{
                    NSLog(@"----test-2-1-%@",self);
    char keyPtr[kCCKeySize3DES + 1];
    bzero(keyPtr, sizeof(keyPtr));
    [key getCString:keyPtr maxLength:sizeof(keyPtr) encoding:NSUTF8StringEncoding];
    
    NSUInteger dataLength = [self length];
    size_t bufferSize = dataLength + kCCBlockSize3DES;
    Byte *buffer = malloc(bufferSize);
    size_t numByteDecrypted = 0;
    
    CCCryptorStatus cryptorStatus = CCCrypt(kCCDecrypt,
                                            kCCAlgorithm3DES,
                                            kCCOptionPKCS7Padding,
                                            keyPtr,
                                            kCCKeySize3DES,
                                            iv,
                                            [self bytes],
                                            dataLength,
                                            buffer,
                                            bufferSize,
                                            &numByteDecrypted);
    if (cryptorStatus == kCCSuccess)
    {
        NSData *a=[NSData dataWithBytesNoCopy:buffer length:numByteDecrypted];
        NSLog(@"----test-2-2-%@",a);
        
        return a;
    }
    free(buffer);
    return nil;
}

@end
