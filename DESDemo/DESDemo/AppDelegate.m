//
//  AppDelegate.m
//  DESDemo
//
//  Created by tekuba.net on 13-7-23.
//  Copyright (c) 2013年 tekuba.net. All rights reserved.
//

#import "AppDelegate.h"
#import "NSData+Conversion.h"
#import "NSData+3DES.h"
#import "DES.h"

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    //Byte byte[] = {0,1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23};
    Byte byte[]={80,168,15,154,67};
    
    for (int i = 0; i < sizeof(byte); i++)
    {
        byte[i]=70;
    }
    //NSLog(@"-1-%@", byte);
    
    
    NSData *adata = [[NSData alloc] initWithBytes:byte length:5];
    
    NSLog(@"0-%@", adata);
    //NSLog(@"%s", adata.bytes);

    NSString * str = @"801681515467";
    
    const char* but=[str UTF8String];
    
        NSLog(@"1-%s", but);
    
    NSData *bdata = [[NSData alloc] initWithBytes:but length:[str length]/2];

    NSLog(@"2-%@", bdata);
    
    NSData * data = [str dataUsingEncoding:NSUTF8StringEncoding]; //NSString转换成NSData类型
    NSLog(@"%@", data);
    NSString * newStr = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    NSLog(@"%@", newStr);
    
    //24 bytes are valid
    NSString *keyString = @"9638527410abcd3219874560";
    
    NSString *testString=@"111111";
    
    NSLog(@"加密字符----%@",testString);

    
    NSData *test=[testString dataUsingEncoding:NSUTF8StringEncoding];


    
    NSData *testResult=[test tripleDESEncrypt:keyString];
    
    NSLog(@"加密原型----%@",[testResult hexadecimalString]);

    
    NSLog(@"加密结果----%@",[testResult hexadecimalString]);
   
    
    NSLog(@"解密原型----%@",[[testResult hexadecimalString] dataUsingEncoding:NSASCIIStringEncoding] );

    NSString *newString= [[[[testResult hexadecimalString] dataUsingEncoding:NSUTF8StringEncoding] tripleDESDecrypt:keyString] hexadecimalString];
    
    NSLog(@"解密结果----%@",newString );
    
    NSString *a=@"";
    
    for (int i = 0; i<[newString length]; i++) {
 
        NSString *s = [newString substringWithRange:NSMakeRange(i, 1)];
        
        if (i%2!=0) {
             a =   [a stringByAppendingString:s];
            
        }
    }
    NSLog(@"%@",a);
    
    
    return YES;
}
							
- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
