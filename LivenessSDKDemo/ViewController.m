//
//  ViewController.m
//  LivenessSDKDemo
//
//  Created by aaaa zhao on 2019/4/15.
//  Copyright © 2019 Liveness.AI.Advance. All rights reserved.
//

#import "ViewController.h"
#import "AAILivenessSDK/AAILiveness/AAILivenessViewController.h"
#import <AAILivenessSDK/AAILivenessSDK.h>
@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    NSString *sdkVersion = [AAILivenessSDK sdkVersion];
    [AAILivenessSDK configResultPictureSize:650];
    UIButton *sdkBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    sdkBtn.frame = CGRectMake(40, 80, 140, 40);
    [sdkBtn setTitle:[NSString stringWithFormat:@"%@sdk test", sdkVersion] forState:UIControlStateNormal];
    [sdkBtn setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    [sdkBtn addTarget:self action:@selector(tapSDKBtnAction) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:sdkBtn];
}

- (void)tapSDKBtnAction
{
    AAILivenessViewController *vc = [[AAILivenessViewController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}

@end
