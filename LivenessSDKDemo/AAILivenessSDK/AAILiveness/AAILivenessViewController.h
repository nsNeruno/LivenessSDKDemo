//
//  AAILivenessWrapViewController.h
//  AAILivenessDemo
//
//  Created by Advance.ai on 2019/3/2.
//  Copyright © 2019 Advance.ai. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AAILivenessSDK/AAILivenessSDK.h>

NS_ASSUME_NONNULL_BEGIN

@protocol AAILivenessResultDelegate <NSObject>

@required
- (void)onDetectionFailed:(AAIDetectionResult)detectionResult forDetectionType:(AAIDetectionType)detectionType;
- (void)onDetectionComplete:(NSDictionary *)resultInfo;
@optional
- (void)livenessView:(AAILivenessWrapView *)param endRequest:(NSError * _Nullable)error;
- (void)onAuthError:(NSError * _Nonnull) error;
@end

@interface AAILivenessViewController : UIViewController
@property(nonatomic, readwrite) id<AAILivenessResultDelegate> _Nullable resultDelegate;
@end

NS_ASSUME_NONNULL_END
