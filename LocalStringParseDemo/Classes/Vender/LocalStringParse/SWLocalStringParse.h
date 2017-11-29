//
//  SWLocalStringParse.h
//  Parse
//
//  Created by SanW on 2017/11/29.
//  Copyright © 2017年 ONONTeam. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger,OutputType){
    /** 解析为IOS国际化文件类型 */
    OutputTypeIOS,
    /** 解析为安卓国际化文件类型 */
    OutputTypeAndroid
};

@interface SWLocalStringParse : NSObject
/**
 * 解析源文件并生成相应的XML和strings文件
 @param fifleName 源文件全名 eg:string.txt
 @param outputType 需要输出文件类型
 @return <#return value description#>
 */
+ (BOOL)parseStringWithFifleName:(NSString *)fifleName outputType:(OutputType)outputType;
@end
