//
//  SWLocalStringParseController.m
//  LocalStringParseDemo
//
//  Created by SanW on 2017/11/29.
//  Copyright © 2017年 ONONTeam. All rights reserved.
//

#import "SWLocalStringParseController.h"
#import "SWLocalStringParse.h"
@interface SWLocalStringParseController ()

@end

@implementation SWLocalStringParseController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    NSArray *fileNameArr = @[@"ApplicationResources_zh_CN.properties",@"ApplicationResources_ms_MY.properties",@"ApplicationResources_nl_NL.properties",@"ApplicationResources_zh_TW.properties"];
    for (NSString *fifleName in fileNameArr) {
        [SWLocalStringParse parseStringWithFifleName:fifleName outputType:OutputTypeIOS];
        [SWLocalStringParse parseStringWithFifleName:fifleName outputType:OutputTypeAndroid];
    }
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
