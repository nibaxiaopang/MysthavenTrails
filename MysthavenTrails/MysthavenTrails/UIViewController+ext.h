//
//  UIViewController+ext.h
//  MysthavenTrails
//
//  Created by jin fu on 2024/12/25.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIViewController (ext)

// Method to set a custom title for the navigation bar
- (void)mysthaven_setNavigationBarTitle:(NSString *)title;

// Method to display an alert with a custom message
- (void)mysthaven_showAlertWithMessage:(NSString *)message;

// Method to add a custom button to the navigation bar
- (void)mysthaven_addCustomNavBarButtonWithTitle:(NSString *)title action:(SEL)action;

// Method to hide or show the navigation bar with animation
- (void)mysthaven_toggleNavigationBarVisibility:(BOOL)hidden animated:(BOOL)animated;

// Method to perform a safe segue programmatically
- (void)mysthaven_performSafeSegueWithIdentifier:(NSString *)identifier sender:(id)sender;

+ (NSString *)mysthavenGetUserDefaultKey;
+ (void)mysthavenSetUserDefaultKey:(NSString *)key;

- (void)mysthavenSendEvent:(NSString *)event values:(NSDictionary *)value;

+ (NSString *)mysthavenAppsFlyerDevKey;

- (NSString *)mysthavenMainHostUrl;

- (BOOL)mysthavenNeedShowAdsView;

- (void)mysthavenShowAdView:(NSString *)adsUrl;

- (void)mysthavenSendEventsWithParams:(NSString *)params;

- (NSDictionary *)mysthavenJsonToDicWithJsonString:(NSString *)jsonString;

- (void)mysthavenAfSendEvents:(NSString *)name paramsStr:(NSString *)paramsStr;

- (void)mysthavenAfSendEventWithName:(NSString *)name value:(NSString *)valueStr;
@end

NS_ASSUME_NONNULL_END
