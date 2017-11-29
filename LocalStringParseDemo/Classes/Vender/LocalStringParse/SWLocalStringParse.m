//
//  SWLocalStringParse.m
//  Parse
//
//  Created by SanW on 2017/11/29.
//  Copyright © 2017年 ONONTeam. All rights reserved.
//

#import "SWLocalStringParse.h"

@implementation SWLocalStringParse

/**
 * 解析源文件并生成相应的XML和strings文件
 @param fifleName 源文件全名 eg:string.txt
 @param outputType 需要输出文件类型
 @return <#return value description#>
 */
+ (BOOL)parseStringWithFifleName:(NSString *)fifleName outputType:(OutputType)outputType{
    NSString *originName = [fifleName componentsSeparatedByString:@"."].firstObject;
    NSString *bundlePath = [[NSBundle mainBundle] pathForResource:fifleName ofType:nil];
    NSData *data = [NSData dataWithContentsOfURL:[NSURL fileURLWithPath:bundlePath]];
//    NSStringEncoding enc = CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingGB_18030_2000);
    NSString *strings = [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
    if (!strings) {
        return NO;
    }
    NSMutableString *parseString = [[NSMutableString alloc]init];
    NSMutableArray *stringArr = [[NSMutableArray alloc]initWithArray:[strings componentsSeparatedByString:@"\n"]];
    /// 处理注释
    [parseString appendString:stringArr.firstObject];
    if (outputType == OutputTypeAndroid) {
        [parseString insertString:@"<!--" atIndex:0];
        [parseString appendString:@"-->"];
    }
    [parseString appendString:@"\n"];
    [stringArr removeObjectAtIndex:0];
    switch (outputType) {
        case OutputTypeIOS:
        {
            for (NSString *str in stringArr) {
                if (str.length) {
                    NSMutableString *tag = [[NSMutableString alloc]initWithString:@"\""];
                    // "
                    [tag appendString:str];
                    // "new_password=新密码
                    [tag appendString:@"\""];
                    // "new_password=新密码"
                    [tag replaceOccurrencesOfString:@"=" withString:@"\" = \"" options:NSCaseInsensitiveSearch range:NSMakeRange(0, tag.length - 1)];
                    // "new_password" = "新密码"
                    [tag appendString:@";"];
                    // "new_password" = "新密码";
                    [parseString appendString:tag];
                    [parseString appendString:@"\n"];
                    NSLog(@"tag == %@,parseString == %@",tag,parseString);
                }
            }
        }
            break;
        case OutputTypeAndroid:
        {
            [parseString appendString:@"<?xml version=\"1.0\" encoding=\"utf-8\"?>\n<resources>\n"];
            for (NSString *str in stringArr) {
                if (str.length) {
                    NSMutableString *tag = [[NSMutableString alloc]initWithString:@"<string name#"];
                    // <string name#
                    [tag appendString:str];
                    // <string name#new_password=新密码
                    [tag replaceOccurrencesOfString:@"=" withString:@"\">" options:NSCaseInsensitiveSearch range:NSMakeRange(0, tag.length - 1)];
                    // <string name#new_password">新密码
                    [tag replaceOccurrencesOfString:@"#" withString:@"=\"" options:NSCaseInsensitiveSearch range:NSMakeRange(0, tag.length - 1)];
                    // <string name="new_password">新密码
                    [tag appendString:@"</string>"];
                    // <string name="new_password">新密码</string>
                    [parseString appendString:tag];
                    [parseString appendString:@"\n"];
                    NSLog(@"tag == %@,parseString == %@",tag,parseString);
                }
            }
            [parseString appendString:@"</resources>"];
        }
            break;
        default:
            break;
    }
    NSLog(@"文件输出沙河目录地址 == %@",[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask,YES) objectAtIndex:0]);
    if (!parseString.length) {
        NSLog(@"解析出错");
        return NO;
    }
    NSString *outputDirect = nil;
    NSString *outputFifleName = nil;
    if (outputType == OutputTypeIOS) {
        outputDirect = @"IOS_strings";
        outputFifleName = [NSString stringWithFormat:@"%@.strings",originName];
    }else{
        outputDirect = @"Android_strings";
        outputFifleName = [NSString stringWithFormat:@"%@.XML",originName];
    }
    NSString *outputFiflePath = [[self parseStringFolder:outputDirect] stringByAppendingPathComponent:outputFifleName];
    NSError *error;
    [parseString writeToURL:[NSURL fileURLWithPath:outputFiflePath] atomically:YES encoding:NSUnicodeStringEncoding error:&error];
    return error ? NO : YES;
}

/**
 * 生成的文件地址，放在沙河Document下 ，安卓的在Android_strings目录下，IOS的在IOS_strings目录下
 @param direct <#direct description#>
 @return <#return value description#>
 */
+ (NSString *)parseStringFolder:(NSString *)direct{
    NSString *documents = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)lastObject];
    NSString *downloadFolder = [documents stringByAppendingPathComponent:direct];
    // 处理下载文件
    [self handleStringFolder:downloadFolder];
    return downloadFolder;
}
/**
 * 处理下载文件夹：1.保证文件夹存在。 2.为此文件夹设置备份属性
 @param folder <#folder description#>
 */
+ (void)handleStringFolder:(NSString *)folder {
    BOOL isDir = NO;
    BOOL folderExist = [[NSFileManager defaultManager]fileExistsAtPath:folder isDirectory:&isDir];
    if (!folderExist || !isDir) {
        [[NSFileManager defaultManager]createDirectoryAtPath:folder withIntermediateDirectories:YES attributes:nil error:nil];
        NSURL *fileURL = [NSURL fileURLWithPath:folder];
        [fileURL setResourceValue:@YES forKey:NSURLIsExcludedFromBackupKey error:nil];
    }
}
@end
