//
//  AAILivenessWrapViewController.m
//  AAILivenessDemo
//
//  Created by Advance.ai on 2019/3/2.
//  Copyright © 2019 Advance.ai. All rights reserved.
//

#import "AAILivenessViewController.h"
#import <AAILivenessSDK/AAILivenessSDK.h>
#import "AAIHUD.h"
#import "AAILivenessResultViewController.h"
#import "AAILivenessUtil.h"
#import <AVFoundation/AVFoundation.h>

@interface AAILivenessViewController ()<AAILivenessWrapDelegate>
{
    UIButton *_backBtn;
    UILabel *_stateLabel;
    
    // Additional UILabel
    UILabel *_directionLabel;
    
//    UIImageView *_stateImgView;
    //Voice
//    UIButton *_voiceBtn;
    //Time label
//    UILabel *_timeLabel;
    CGRect _roundViewFrame;
    
    AAIDetectionResult _preResult;
    BOOL _isReady;
    BOOL _isRequestingAuth;
    BOOL _requestAuthSucceed;
}
@property(nonatomic, strong) AAILivenessWrapView *wrapView;
@property(nonatomic) BOOL isRequestingAuth;
@property(nonatomic) BOOL requestAuthSucceed;
@property(nonatomic) BOOL requestAuthComplete;
@property(nonatomic) BOOL requestAuthCached;
@property(nonatomic) BOOL hasPortraitDirection;
@property(nonatomic) AAILivenessUtil *util;
@end

@implementation AAILivenessViewController
@synthesize isRequestingAuth = _isRequestingAuth;
@synthesize requestAuthSucceed = _requestAuthSucceed;

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    _preResult = AAIDetectionResultUnknown;
    _isReady = NO;
    _isRequestingAuth = NO;
    _requestAuthSucceed = NO;
    _requestAuthComplete = NO;
    _requestAuthCached = NO;
    
    _util = [[AAILivenessUtil alloc] init];
    
    UIView *sv = self.view;
    AAILivenessWrapView *wrapView = [[AAILivenessWrapView alloc] init];
    sv.backgroundColor = [UIColor grayColor];
    [sv addSubview:wrapView];
    ///*
    //Custom UI
    wrapView.backgroundColor = [UIColor grayColor];
//    wrapView.roundBorderView.layer.borderColor = [UIColor redColor].CGColor;
//    wrapView.roundBorderView.layer.borderWidth = 2;
    // */
    //Custom corner radius and the shape of the preview area
    CGFloat cornerRadius = 0;
    wrapView.roundBorderView.layer.cornerRadius = cornerRadius;
    wrapView.roundBorderView.layer.borderColor = [UIColor clearColor].CGColor;
    wrapView.configAvatarPreviewPath = ^(CGSize avatarPreviewSize, UIBezierPath * _Nonnull originRectPath) {
        UIBezierPath *squarePath = [UIBezierPath bezierPathWithRoundedRect:CGRectMake(0, 0, avatarPreviewSize.width, avatarPreviewSize.width) cornerRadius:cornerRadius];
        [originRectPath appendPath: [squarePath bezierPathByReversingPath]];
    };
    
    //Custom preview area width
    wrapView.configAvatarPreviewWidth = ^CGFloat(CGRect wrapViewFrame) {
        return sv.frame.size.width - 48;
    };
//     */
    /*
    //You can custom detectionActions
    wrapView.detectionActions = @[@(AAIDetectionTypeMouth), @(AAIDetectionTypePosYaw), @(AAIDetectionTypeBlink)];
     */
    wrapView.wrapDelegate = self;
    _wrapView = wrapView;
    
    //Back button
//    [[self navigationController] setNavigationBarHidden:NO];
    [[self navigationController] setNavigationBarHidden:YES];
//    if (self.navigationController.navigationBarHidden) {
    
    
//    UIBarButtonItem *backBtn = [[UIBarButtonItem alloc] initWithTitle:@" " style:UIBarButtonItemStylePlain target:nil action:@selector(tapBackBtnAction)];
    UIButton *backBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    [backBtn setImage:[AAILivenessUtil imgWithName:@"Chevron"] forState:UIControlStateNormal];
    [backBtn setTintColor:[UIColor whiteColor]];
    [sv addSubview:backBtn];
    [backBtn addTarget:self action:@selector(tapBackBtnAction) forControlEvents:UIControlEventTouchUpInside];
    _backBtn = backBtn;
    
//    }
//    UINavigationBar *navigationBar = [[self navigationController] navigationBar];
//    [navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor whiteColor]}];
//    [navigationBar setTintColor:[UIColor whiteColor]];
//    [navigationBar setBackgroundImage:[UIImage new] forBarMetrics:UIBarMetricsDefault];
//    navigationBar.shadowImage = [UIImage new];
//    [navigationBar setTranslucent:YES];
//    [[self navigationItem] setTitle:@"Liveness Detection"];
//    UIBarButtonItem *backButton = [[UIBarButtonItem alloc] initWithTitle:@"Aha" style:UIBarButtonItemStylePlain target:nil action:nil];
//    [[self navigationItem] setBackBarButtonItem:backButton];
    
    // Additional Direction label
    UILabel *directionLabel = [[UILabel alloc] init];
//    directionLabel.font = [UIFont systemFontOfSize:18];
    directionLabel.font = [UIFont fontWithName:@"AvenirNextLTPro-Demi" size:14.0];
    
    directionLabel.textColor = [UIColor whiteColor];
    directionLabel.numberOfLines = 0;
    directionLabel.textAlignment = NSTextAlignmentLeft;
    [sv addSubview:directionLabel];
    _directionLabel = directionLabel;
    
    //Detect state label
    UILabel *stateLabel = [[UILabel alloc] init];
//    stateLabel.font = [UIFont systemFontOfSize:16];
    stateLabel.font = [UIFont fontWithName:@"AvenirNextLTPro-Regular" size:12.0];
    stateLabel.textColor = [UIColor whiteColor];
    stateLabel.numberOfLines = 0;
    stateLabel.textAlignment = NSTextAlignmentLeft;
    [sv addSubview:stateLabel];
    _stateLabel = stateLabel;
    
    //Action status imageView
//    UIImageView *stateImgView = [[UIImageView alloc] init];
//    stateImgView.contentMode = UIViewContentModeScaleAspectFit;
//    [sv addSubview:stateImgView];
//    _stateImgView = stateImgView;
    
    //Voice switch button
//    UIButton *voiceBtn = [[UIButton alloc] init];
//    [voiceBtn setImage:[AAILivenessUtil imgWithName:@"liveness_open_voice@2x.png"] forState:UIControlStateNormal];
//    [voiceBtn setImage:[AAILivenessUtil imgWithName:@"liveness_close_voice@2x.png"] forState:UIControlStateSelected];
//    [sv addSubview:voiceBtn];
//    [voiceBtn addTarget:self action:@selector(tapVoiceBtnAction:) forControlEvents:UIControlEventTouchUpInside];
//
//    if ([AAILivenessUtil isSilent]) {
//        voiceBtn.selected = YES;
//    }
//
//    _voiceBtn = voiceBtn;
    
    //Timeout interval label
//    _timeLabel = [[UILabel alloc] init];
//    _timeLabel.font = [UIFont systemFontOfSize:14];
//    _timeLabel.textColor = [UIColor colorWithRed:(0x36/255.f) green:(0x36/255.f) blue:(0x36/255.f) alpha:1];
//    _timeLabel.text = [NSString stringWithFormat:@"%d S", aai_timeout_interval];
//    _timeLabel.textAlignment = NSTextAlignmentCenter;
//    [sv addSubview:_timeLabel];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(restartDetection) name:@"kAAIRestart" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(networkChanged:) name:AAINetworkDidChangedNotification object:nil];
    [[AVAudioSession sharedInstance] addObserver:self forKeyPath:@"outputVolume" options:NSKeyValueObservingOptionNew context:nil];
    
    [_util saveCurrBrightness];
    
//    _timeLabel.hidden = YES;
//    _voiceBtn.hidden = YES;
    
    [self startCamera];
}

//- (void)initNavbar
//{
//    UINavigationBar *navigationBar = [[UINavigationBar alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 50)];
//    UINavigationItem *title = [[UINavigationItem alloc] initWithTitle:@"Liveness Detection"];
//
//    [navigationBar setItems:@[title]];
//    [self.view addSubview:navigationBar];
//}

- (void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    
    // Do not modify begin
    CGRect rect = self.view.frame;
    _wrapView.frame = CGRectMake(rect.origin.x, rect.origin.y + 60.0, rect.size.width, rect.size.height);
//    _wrapView.frame = rect;
    [_wrapView setNeedsLayout];
    [_wrapView layoutIfNeeded];
    
//    CGSize size = rect.size;
    CGRect tmpFrame = _wrapView.roundBorderView.frame;
    UIView* roundBorderView = _wrapView.roundBorderView;
    NSLog(@"Bounds: [%f %f]", roundBorderView.bounds.origin.x, roundBorderView.bounds.origin.y);
    NSLog(@"Frame: [%f %f]", roundBorderView.frame.origin.x, roundBorderView.frame.origin.y);
    _roundViewFrame = [_wrapView.roundBorderView convertRect:tmpFrame toView:self.view];
    // Do not modify end
    
    //top
    CGFloat top = 0, marginLeft = 20, marginTop = 20;
    if (@available(iOS 11, *)) {
        top = self.view.safeAreaInsets.top;
    } else {
        if (self.navigationController.navigationBarHidden) {
            top = [UIApplication sharedApplication].statusBarFrame.size.height;
        } else {
            top = self.navigationController.navigationBar.frame.size.height + [UIApplication sharedApplication].statusBarFrame.size.height;
        }
    }
    
    // Direction Label
    _directionLabel.frame = CGRectMake(_roundViewFrame.origin.x, top + marginTop * 3.6, _roundViewFrame.size.width, 24);
    _directionLabel.text = @"Get ready to follow the instructions";
    
    UIView *sv = self.view;
    
    //Back button
    if (_backBtn) {
        _backBtn.frame = CGRectMake(marginLeft, top + marginTop, 40, 40);
        
        UILabel *titleLabel = [[UILabel alloc] init];
        titleLabel.text = @"Liveness Detection";
        
        [sv addSubview:titleLabel];
        titleLabel.font = [UIFont boldSystemFontOfSize:16.0];
        titleLabel.textColor = [UIColor whiteColor];
        titleLabel.frame = CGRectMake(0.0, _backBtn.frame.origin.y + _backBtn.frame.size.height / 2 - 12.0, sv.frame.size.width, 24.0);
        titleLabel.textAlignment = NSTextAlignmentCenter;
    }
    
    //State image
//    CGFloat stateImgViewWidth = 120;
//    _stateImgView.frame = CGRectMake((size.width-stateImgViewWidth)/2, CGRectGetMaxY(_roundViewFrame) + 80, stateImgViewWidth, stateImgViewWidth);
    
    //Time label
//    CGFloat timeLabelCenterY = 0;
//    CGSize timeLabelSize = CGSizeMake(40, 24);
//    if (_backBtn) {
//        timeLabelCenterY = _backBtn.center.y;
//    } else {
//        timeLabelCenterY = top + marginTop + timeLabelSize.height/2;
//    }
//    _timeLabel.bounds = CGRectMake(0, 0, timeLabelSize.width, timeLabelSize.height);
//    _timeLabel.center = CGPointMake(size.width - marginLeft - 20, timeLabelCenterY);
//    _timeLabel.layer.cornerRadius = 12;
//    _timeLabel.layer.borderWidth = 1;
//    _timeLabel.layer.borderColor = _timeLabel.textColor.CGColor;
    
//    _voiceBtn.bounds = CGRectMake(0, 0, 32, 32);
//    _voiceBtn.center = CGPointMake(_timeLabel.center.x, CGRectGetMaxY(_timeLabel.frame)+20);
    
    // Additional Borders
//    CGFloat *a = (CGFloat) (_roundViewFrame.size.width * 0.2);
    
    CGFloat w = _roundViewFrame.size.width * 0.2;
    CGFloat h = _roundViewFrame.size.height * 0.2;
    CGFloat x1 = _roundViewFrame.origin.x;
    CGFloat x3 = _roundViewFrame.origin.x + _roundViewFrame.size.width;
    CGFloat x2 = x3 - w;
    CGFloat y1 = _roundViewFrame.origin.y;
    CGFloat y2 = _roundViewFrame.origin.y + _roundViewFrame.size.height;
    CGFloat borderWidth = 4.0;
    
    // CA9832
    UIColor *borderColor = [UIColor colorWithRed:(CGFloat) (202.0 / 255.0) green:(CGFloat) (152.0 / 255.0) blue:(CGFloat) (50.0 / 255.0) alpha:1.0];
    
    UIView *topXLeftBorder = [[UIView alloc] init];
    topXLeftBorder.backgroundColor = borderColor;
    topXLeftBorder.frame = CGRectMake(x1, y1, w, borderWidth);
    [sv addSubview:topXLeftBorder];
    
    UIView *topYLeftBorder = [[UIView alloc] init];
    topYLeftBorder.backgroundColor = borderColor;
    topYLeftBorder.frame = CGRectMake(x1, y1, borderWidth, h);
    [sv addSubview:topYLeftBorder];
    
    UIView *topXRightBorder = [[UIView alloc] init];
    topXRightBorder.frame = CGRectMake(x2, y1, w, borderWidth);
    topXRightBorder.backgroundColor = borderColor;
    [sv addSubview:topXRightBorder];
    
    UIView *topYRightBorder = [[UIView alloc] init];
    topYRightBorder.backgroundColor = borderColor;
    topYRightBorder.frame = CGRectMake(x3, y1, borderWidth, h);
    [sv addSubview:topYRightBorder];
    
    UIView *bottomXLeftBorder = [[UIView alloc] init];
    bottomXLeftBorder.frame = CGRectMake(x1, y2, w, borderWidth);
    bottomXLeftBorder.backgroundColor = borderColor;
    [sv addSubview:bottomXLeftBorder];
    
    UIView *bottomYLeftBorder = [[UIView alloc] init];
    bottomYLeftBorder.backgroundColor = borderColor;
    bottomYLeftBorder.frame = CGRectMake(x1, y2 - h + borderWidth, borderWidth, h);
    [sv addSubview:bottomYLeftBorder];
    
    UIView *bottomXRightBorder = [[UIView alloc] init];
    bottomXRightBorder.frame = CGRectMake(x2, y2, w, borderWidth);
    bottomXRightBorder.backgroundColor = borderColor;
    [sv addSubview:bottomXRightBorder];
    
    UIView *bottomYRightBorder = [[UIView alloc] init];
    bottomYRightBorder.backgroundColor = borderColor;
    bottomYRightBorder.frame = CGRectMake(x3, y2 - h + borderWidth, borderWidth, h);
    [sv addSubview:bottomYRightBorder];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [_util graduallySetBrightness:1];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [_util graduallyResumeBrightness];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    [self resetViewState];
    _wrapView.roundBorderView.backgroundColor = [UIColor whiteColor];
}

- (void)updateStateLabel:(NSString *)state
{
    CGRect frame = _roundViewFrame;
    CGFloat w = frame.size.width;
    CGFloat marginTop = 40;
    if (state) {
        _stateLabel.text = state;
        CGSize size = [_stateLabel sizeThatFits:CGSizeMake(w, 1000)];
//        _stateLabel.frame = CGRectMake(frame.origin.x, frame.origin.y + w + marginTop, w, size.height);
        _stateLabel.frame = CGRectMake(frame.origin.x, frame.origin.y - marginTop, w, size.height);
    } else {
        _stateLabel.text = nil;
        _stateLabel.frame = CGRectMake(frame.origin.x, frame.origin.y + w + marginTop, frame.size.width, 30);
    }
}

- (void)showImgWithType:(AAIDetectionType)detectionType
{
    switch (detectionType) {
        case AAIDetectionTypeBlink:
        case AAIDetectionTypeMouth:
        case AAIDetectionTypePosYaw: {
//            [_stateImgView stopAnimating];
//            NSArray *array = [AAILivenessUtil stateImgWithType:detectionType];
//            _stateImgView.animationImages = array;
//            _stateImgView.animationDuration = array.count * 1/5.f;
//            [_stateImgView startAnimating];
            break;
        }
        default:
            break;
    }
}

#pragma mark - Network

- (BOOL)isRequestingAuth
{
    return _isRequestingAuth;
}

- (BOOL)requestAuthSucceed
{
    return _requestAuthSucceed;
}

#pragma mark - UserAction

- (void)startCamera
{
    __weak typeof(self) weakSelf = self;
    [_wrapView checkCameraPermissionWithCompletionBlk:^(BOOL authed) {
        if (!weakSelf) return;
        
        //Alert no permission
        [AAIHUD showMsg:[AAILivenessUtil localStrForKey:@"no_camera_permission"] onView:weakSelf.view duration:1.5];
    }];
}

- (void)requestAuth
{
    _isRequestingAuth = YES;
    _isReady = NO;
//    _timeLabel.hidden = YES;
    
    __weak typeof(self) weakSelf = self;
    [AAIHUD showWaitWithMsg:[AAILivenessUtil localStrForKey:@"auth_check"] onView:self.view];
    [_wrapView startAuthWithCompletionBlk:^(NSError * _Nonnull error) {
        __strong AAILivenessViewController *strongSelf = weakSelf;
        if (strongSelf) {
            strongSelf.isRequestingAuth = NO;
            strongSelf.requestAuthComplete = YES;
            
            if (error) {
                strongSelf.requestAuthSucceed = NO;
                
                [AAIHUD dismissHUDOnView:strongSelf.view afterDelay:0];
                AAILivenessResultViewController *resultVC = [[AAILivenessResultViewController alloc] initWithResult:NO resultState:error.localizedDescription];
                [weakSelf.navigationController pushViewController:resultVC animated:YES];
            } else {
                strongSelf.requestAuthCached = YES;
                strongSelf.requestAuthSucceed = YES;
                [AAIHUD dismissHUDOnView:strongSelf.view afterDelay:0];
            }
        }
    }];
}

- (void)tapVoiceBtnAction:(UIButton *)btn
{
    btn.selected = !btn.selected;
    if (btn.selected) {
        //Close
        [_util configVolume:0];
    } else {
        //Open
        [_util configVolume:0.5];
    }
}

- (void)tapBackBtnAction
{
    UINavigationController *navc = self.navigationController;
    if (navc && [navc.viewControllers containsObject:self]) {
        [self.navigationController popViewControllerAnimated:YES];
    } else {
        [self.presentingViewController dismissViewControllerAnimated:YES completion:nil];
    }
}

- (void)resetViewState
{
    if (_stateLabel) {
        _stateLabel.text = nil;
    }
//    _stateImgView.animationImages = nil;
    _isReady = NO;
//    _timeLabel.hidden = YES;
//    _voiceBtn.hidden = YES;
}

- (void)restartDetection
{
    [self resetViewState];
    _wrapView.roundBorderView.backgroundColor = [UIColor whiteColor];
    _hasPortraitDirection = NO;
    _requestAuthComplete = NO;

    [self startCamera];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        self->_wrapView.roundBorderView.backgroundColor = [UIColor clearColor];
    });
}

- (void)networkChanged:(NSNotification *)notification
{
    NSInteger networkAvailable = [notification.userInfo[AAINetworkNotificationResultItem] integerValue];
    if (networkAvailable) {
        if ([self isRequestingAuth] == NO && [self requestAuthSucceed] == NO) {
            if ([AAILocalizationUtil isPortraitDirection]) {
                [self requestAuth];
            }
        }
    } else {
        //Network unavailable
    }
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context
{
//    if ([keyPath isEqualToString:@"outputVolume"]) {
//        float volume = [change[NSKeyValueChangeNewKey] floatValue];
//        [_util configPlayerVolume:volume];
//        if (volume == 0) {
//            if (_voiceBtn.selected == NO) {
//                _voiceBtn.selected = YES;
//            }
//        } else {
//            if (_voiceBtn.selected == YES) {
//                _voiceBtn.selected = NO;
//            }
//        }
//    }
}

#pragma mark - WrapViewDelegate

- (void)onDetectionReady:(AAIDetectionType)detectionType
{
    _isReady = YES;
//    _timeLabel.hidden = NO;
    
    NSString *key = nil;
    if (detectionType == AAIDetectionTypeBlink) {
        key = @"pls_blink";
        [_util playAudio:@"action_blink.mp3"];
    } else if (detectionType == AAIDetectionTypeMouth) {
        key = @"pls_open_mouth";
        [_util playAudio:@"action_open_mouth.mp3"];
    } else if (detectionType == AAIDetectionTypePosYaw) {
        key = @"pls_turn_head";
        [_util playAudio:@"action_turn_head.mp3"];
    }
    
    if (key) {
        _stateLabel.text = [AAILivenessUtil localStrForKey:key];
        [self showImgWithType:detectionType];
    }
}

- (void)onDetectionFailed:(AAIDetectionResult)detectionResult forDetectionType:(AAIDetectionType)detectionType
{
    [_util playAudio:@"detection_failed.mp3"];
    [AAILocalizationUtil stopMonitor];
    
    //Reset
    _preResult = AAIDetectionResultUnknown;
    
    NSString *key = nil;
    switch (detectionResult) {
        case AAIDetectionResultTimeout:
            key = @"fail_reason_timeout";
            break;
        case AAIDetectionResultErrorMutipleFaces:
            key = @"fail_reason_muti_face";
            break;
        case AAIDetectionResultErrorFaceMissing: {
            switch (detectionType) {
                case AAIDetectionTypeBlink:
                case AAIDetectionTypeMouth:
                    key = @"fail_reason_facemiss_blink_mouth";
                    break;
                case AAIDetectionTypePosYaw:
                    key = @"fail_reason_facemiss_pos_yaw";
                    break;
                default:
                    break;
            }
            break;
        }
        case AAIDetectionResultErrorMuchMotion:
            key = @"fail_reason_much_action";
            break;
        default:
            break;
    }
    
    //Show result page
    if (key) {
        NSString *state = [AAILivenessUtil localStrForKey:key];
        [self updateStateLabel:state];
        
//        [_stateImgView stopAnimating];
        
        AAILivenessResultViewController *resultVC = [[AAILivenessResultViewController alloc] initWithResult:NO resultState:key];
        [self.navigationController pushViewController:resultVC animated:YES];
    }
}

- (BOOL)shouldDetect
{
    if (_hasPortraitDirection == NO) {
        _hasPortraitDirection = [AAILocalizationUtil isPortraitDirection];
        if (_hasPortraitDirection) {
            if (_requestAuthCached == NO && _isRequestingAuth == NO && _requestAuthComplete == NO) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self requestAuth];
                });
            }
            return _requestAuthCached;
        } else {
            dispatch_async(dispatch_get_main_queue(), ^{
                if (self->_isReady == NO) {
//                    _timeLabel.hidden = YES;
//                    _voiceBtn.hidden = YES;
//                    _stateImgView.animationImages = nil;
                }
                
                NSString *state = [AAILivenessUtil localStrForKey:@"pls_hold_phone_v"];
                [self updateStateLabel:state];
            });
        }
        
        return NO;
    } else {
        if (_requestAuthCached == NO && _isRequestingAuth == NO  && _requestAuthComplete == NO) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [self updateStateLabel:nil];
                [self requestAuth];
            });
        }
        return _requestAuthCached;
    }
    return YES;
}

- (void)onFrameDetected:(AAIDetectionResult)result status:(AAIActionStatus)status forDetectionType:(AAIDetectionType)detectionType
{
    NSString *key = nil;
    if (_isReady == NO && [AAILocalizationUtil isPortraitDirection] == NO) {
        key = @"pls_hold_phone_v";
    } else {
        if (_preResult == result) {
            return;
        }
        
        _preResult = result;
        switch (result) {
            case AAIDetectionResultFaceMissing:
                key = @"no_face";
                break;
            case AAIDetectionResultFaceLarge:
                key = @"move_further";
                break;
            case AAIDetectionResultFaceSmall:
                key = @"move_closer";
                break;
            case AAIDetectionResultFaceNotCenter:
                key = @"move_center";
                break;
            case AAIDetectionResultFaceNotFrontal:
                key = @"frontal";
                break;
            case AAIDetectionResultFaceNotStill:
                key = @"stay_still";
                break;
            case AAIDetectionResultFaceInAction: {
                if (detectionType == AAIDetectionTypeBlink) {
                    key = @"pls_blink";
                } else if (detectionType == AAIDetectionTypePosYaw) {
                    key = @"pls_turn_head";
                } else if (detectionType == AAIDetectionTypeMouth) {
                    key = @"pls_open_mouth";
                }
            }
                break;
            default:
                break;
        }
    }
    
    if (key) {
        NSString *state = [AAILivenessUtil localStrForKey:key];
        [self updateStateLabel:state];
    }
}

- (void)onDetectionTypeChanged:(AAIDetectionType)toDetectionType
{
    NSString *key = nil;
    if (toDetectionType == AAIDetectionTypeBlink) {
        key = @"pls_blink";
        [_util playAudio:@"action_blink.mp3"];
    } else if (toDetectionType == AAIDetectionTypeMouth) {
        key = @"pls_open_mouth";
        [_util playAudio:@"action_open_mouth.mp3"];
    } else if (toDetectionType == AAIDetectionTypePosYaw) {
        key = @"pls_turn_head";
        [_util playAudio:@"action_turn_head.mp3"];
    }
    
    if (key) {
        NSString *state = [AAILivenessUtil localStrForKey:key];
        [self updateStateLabel:state];
        [self showImgWithType:toDetectionType];
    }
}

- (void)onDetectionComplete:(NSDictionary *)resultInfo
{
    [_util playAudio:@"detection_success.mp3"];
    [AAILocalizationUtil stopMonitor];
    NSString *state = [AAILivenessUtil localStrForKey:@"detection_success"];
    [self updateStateLabel:state];
//    [_stateImgView stopAnimating];
    _preResult = AAIDetectionResultUnknown;
    
    /*
     {
        "livenessId":@"xxx",
        "img":xxx,
        "uploadImgCostMillSeconds": 1000.0
     }
     
     //Get livenessId
     NSString *livenessId = resultInfo[@"livenessId"];
     UIImage *bestImg = resultInfo[@"img"];
     //Do something...
     */
    
    //Show result page
    AAILivenessResultViewController *resultVC = [[AAILivenessResultViewController alloc] initWithResultInfo:resultInfo];
    [self.navigationController pushViewController:resultVC animated:YES];
}

- (void)onDetectionRemainingTime:(NSTimeInterval)remainingTime forDetectionType:(AAIDetectionType)detectionType
{
//    if (_isReady) {
//        _timeLabel.hidden = NO;
//        _voiceBtn.hidden = NO;
//        _timeLabel.text = [NSString stringWithFormat:@"%.f S", remainingTime];
//    }
}

- (void)livenessViewBeginRequest:(AAILivenessWrapView * _Nonnull)param
{
    [AAIHUD showWaitWithMsg:[AAILivenessUtil localStrForKey:@"auth_check"] onView:self.view];
    
    [self updateStateLabel:nil];
//    [_stateImgView stopAnimating];
}

- (void)livenessView:(AAILivenessWrapView *)param endRequest:(NSError * _Nullable)error
{
    [AAIHUD dismissHUDOnView:self.view afterDelay:0];
    
    if (error) {
        AAILivenessResultViewController *resultVC = [[AAILivenessResultViewController alloc] initWithResult:NO resultState:error.localizedDescription];
        [self.navigationController pushViewController:resultVC animated:YES];
    }
}

- (void)dealloc
{
    //If `viewDidLoad` method not called, we do nothing.
    if (_util != nil) {
        [AAILocalizationUtil stopMonitor];
        [_util removeVolumeView];
        
        [[NSNotificationCenter defaultCenter] removeObserver:self name:@"kAAIRestart" object:nil];
        [[NSNotificationCenter defaultCenter] removeObserver:self name:AAINetworkDidChangedNotification object:nil];
        [[AVAudioSession sharedInstance] removeObserver:self forKeyPath:@"outputVolume"];
    }
}

@end
