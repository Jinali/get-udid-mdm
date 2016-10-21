#import "AppPreferences.h"

@implementation AppPreferences

- (void)pluginInitialize
{
    
}

//- (void)defaultsChanged:(NSNotification *)notification {
//    
//    NSString * jsCallBack = [NSString stringWithFormat:@"cordova.fireDocumentEvent('preferencesChanged');"];
//    
//    if ([notification.name isEqualToString:NSUbiquitousKeyValueStoreDidChangeExternallyNotification]) {
//        
//        NSNumber *changeReasonNumber = notification.userInfo[NSUbiquitousKeyValueStoreChangeReasonKey];
//        if (changeReasonNumber) {
//            NSInteger changeReason = [changeReasonNumber intValue];
//            
//        }
//    }
//    
//    // https://github.com/EddyVerbruggen/cordova-plugin-3dtouch/blob/master/src/ios/app/AppDelegate+threedeetouch.m
//    if ([self.webView respondsToSelector:@selector(stringByEvaluatingJavaScriptFromString:)]) {
//        // UIWebView
//        [self.webView performSelectorOnMainThread:@selector(stringByEvaluatingJavaScriptFromString:) withObject:jsCallBack waitUntilDone:NO];
//    } else if ([self.webView respondsToSelector:@selector(evaluateJavaScript:completionHandler:)]) {
//        // WKWebView
//        [self.webView performSelector:@selector(evaluateJavaScript:completionHandler:) withObject:jsCallBack withObject:nil];
//    } else {
//        NSLog(@"No compatible method found to send notification to the webview. Please notify the plugin author.");
//    }
//}



//- (void)watch:(CDVInvokedUrlCommand*)command
//{
//    
//    __block CDVPluginResult* result = nil;
//    
//    NSDictionary* options = [self validateOptions:command];
//    
//    if (!options)
//        return;
//    
//    bool watchChanges = true;
//    NSNumber *subscribe = [options objectForKey:@"subscribe"];
//    if (subscribe != nil) {
//        watchChanges = [subscribe boolValue];
//    }
//    
//    if (watchChanges) {
//        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(defaultsChanged:) name:NSUserDefaultsDidChangeNotification object:nil];
//        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(defaultsChanged:) name:NSUbiquitousKeyValueStoreDidChangeExternallyNotification object:nil];
//    } else {
//        [[NSNotificationCenter defaultCenter] removeObserver:self name:NSUserDefaultsDidChangeNotification object:nil];
//        [[NSNotificationCenter defaultCenter] removeObserver:self name:NSUbiquitousKeyValueStoreDidChangeExternallyNotification object:nil];
//    }
//    
//    [self.commandDelegate runInBackground:^{
//        result = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK];
//    }];
//}

//- (NSDictionary*)validateOptions:(CDVInvokedUrlCommand*)command
//{
//    NSDictionary* options = [[command arguments] objectAtIndex:0];
//    
//    if (!options) {
//        CDVPluginResult* result = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR messageAsString:@"no options given"];
//        [self.commandDelegate sendPluginResult:result callbackId:[command callbackId]];
//        return nil;
//    }
//    
//    return options;
//}

//- (id)getStoreForOptions:(NSDictionary*)options
//{
//    NSString *suiteName = [options objectForKey:@"suiteName"];
//    NSString *cloudSync = [options objectForKey:@"cloudSync"];
//    
//    id dataStore = nil;
//    
//    if (suiteName != nil && ![@"" isEqualToString:suiteName]) {
//        dataStore = [[NSUserDefaults alloc] initWithSuiteName:suiteName];
//    } else if (cloudSync != nil) {
//        dataStore = [NSUbiquitousKeyValueStore defaultStore];
//    } else {
//        dataStore = [NSUserDefaults standardUserDefaults];
//    }
//    
//    return dataStore;
//}

- (void)fetch:(CDVInvokedUrlCommand*)command
{
    
    __block CDVPluginResult* result = nil;
    
    NSDictionary* options = [self validateOptions:command];
    
    if (!options)
        return;
    
    NSString *key = [options objectForKey:@"key"];
    
    NSLog(@"settingsName is %@",key);
    
    @try {
        
        NSString *managed = [[[NSUserDefaults standardUserDefaults] dictionaryForKey:@"com.apple.configuration.managed"] objectForKey:key];
        
        result = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsString:managed];
        NSLog(@"settingsvalue is %@",managed);
        
    } @catch (NSException * e) {
        
        result = [CDVPluginResult resultWithStatus:CDVCommandStatus_NO_RESULT messageAsString:[e reason]];
        
    } @finally {
        
        [self.commandDelegate sendPluginResult:result callbackId:[command callbackId]];
    }
}

//- (void)remove:(CDVInvokedUrlCommand*)command
//{
//    
//    __block CDVPluginResult* result = nil;
//    
//    NSDictionary* options = [self validateOptions:command];
//    
//    if (!options)
//        return;
//    
//    NSString *settingsDict = [options objectForKey:@"dict"];
//    NSString *settingsName = [options objectForKey:@"key"];
//    
//    id dataStore = [self getStoreForOptions:options];
//    
//    __block id target = dataStore;
//    
//    //[self.commandDelegate runInBackground:^{
//    
//    @try {
//        
//        NSString *returnVar;
//        
//        if (settingsDict) {
//            target = [dataStore dictionaryForKey:settingsDict];
//            if (target)
//                target = [target mutableCopy];
//        }
//        
//        if (target != nil) {
//            [target removeObjectForKey:settingsName];
//            if (target != dataStore)
//                [dataStore setObject:(NSMutableDictionary*)target forKey:settingsDict];
//            [dataStore synchronize];
//        }
//        
//        result = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsString:returnVar];
//        
//    } @catch (NSException * e) {
//        
//        result = [CDVPluginResult resultWithStatus:CDVCommandStatus_NO_RESULT messageAsString:[e reason]];
//        
//    } @finally {
//        
//        [self.commandDelegate sendPluginResult:result callbackId:[command callbackId]];
//    }
//    //}];
//}
//
//- (void)clearAll:(CDVInvokedUrlCommand*)command
//{
//    __block CDVPluginResult* result = nil;
//    
//    NSDictionary* options = [self validateOptions:command];
//    
//    if (!options)
//        return;
//    
//    NSString *settingsDict  = [options objectForKey:@"dict"];
//    NSString *suiteName     = [options objectForKey:@"suiteName"];
//    NSString *cloudSync     = [options objectForKey:@"cloudSync"];
//    
//    id dataStore = [self getStoreForOptions:options];
//    
//    __block id target = dataStore;
//    
//    //[self.commandDelegate runInBackground:^{
//    
//    @try {
//        
//        NSString *appDomain;
//        
//        if (suiteName != nil) {
//            appDomain = suiteName;
//            [dataStore removePersistentDomainForName:appDomain];
//        } else if (cloudSync) {
//            for (NSString *key in [dataStore allKeys]) {
//                [dataStore removeObjectForKey:key];
//            }
//        } else {
//            appDomain = [[NSBundle mainBundle] bundleIdentifier];
//            [dataStore removePersistentDomainForName:appDomain];
//        }
//        
//        [dataStore synchronize];
//        
//        result = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK];
//        
//    } @catch (NSException * e) {
//        
//        result = [CDVPluginResult resultWithStatus:CDVCommandStatus_NO_RESULT messageAsString:[e reason]];
//        
//    } @finally {
//        
//        [self.commandDelegate sendPluginResult:result callbackId:[command callbackId]];
//    }
//    
//    //}];
//}
//
//
//- (void)show:(CDVInvokedUrlCommand*)command
//{
//    __block CDVPluginResult* result;
//    
//    if(&UIApplicationOpenSettingsURLString != nil) {
//        
//        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:UIApplicationOpenSettingsURLString]];
//        result = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK];
//        
//    } else {
//        result = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR messageAsString:@"switching to preferences not supported"];
//    }
//    
//    [self.commandDelegate sendPluginResult:result callbackId:[command callbackId]];
//    
//}
//
//- (void)store:(CDVInvokedUrlCommand*)command
//{
//    __block CDVPluginResult* result;
//    
//    NSDictionary* options = [self validateOptions:command];
//    
//    if (!options)
//        return;
//    
//    NSString *settingsDict  = [options objectForKey:@"dict"];
//    NSString *settingsName  = [options objectForKey:@"key"];
//    NSString *settingsValue = [options objectForKey:@"value"];
//    NSString *settingsType  = [options objectForKey:@"type"];
//    
//    //	NSLog(@"%@ = %@ (%@)", settingsName, settingsValue, settingsType);
//    
//    //[self.commandDelegate runInBackground:^{
//    id dataStore = [self getStoreForOptions:options];
//    
//    id target = dataStore;
//    
//    // NSMutableDictionary *mutable = [[dict mutableCopy] autorelease];
//    // NSDictionary *dict = [[mutable copy] autorelease];
//    
//    if (settingsDict) {
//        target = [[dataStore dictionaryForKey:settingsDict] mutableCopy];
//        if (!target) {
//            target = [[NSMutableDictionary alloc] init];
//#if !__has_feature(objc_arc)
//            [target autorelease];
//#endif
//        }
//    }
//    
//    NSError* error = nil;
//    id JSONObj = [NSJSONSerialization
//                  JSONObjectWithData:[settingsValue dataUsingEncoding:NSUTF8StringEncoding]
//                  options:NSJSONReadingAllowFragments
//                  error:&error
//                  ];
//    
//    if (error != nil) {
//        NSLog(@"NSString JSONObject error: %@", [error localizedDescription]);
//    }
//    
//    @try {
//        
//        if ([settingsType isEqual: @"string"] && [JSONObj isKindOfClass:[NSString class]]) {
//            [target setObject:(NSString*)JSONObj forKey:settingsName];
//        } else if ([settingsType  isEqual: @"number"] && [JSONObj isKindOfClass:[NSNumber class]]) {
//            [target setObject:(NSNumber*)JSONObj forKey:settingsName];
//            // setInteger: forKey, setFloat: forKey:
//        } else if ([settingsType  isEqual: @"boolean"]) {
//            [target setObject:JSONObj forKey:settingsName];
//        } else {
//            // data
//            [target setObject:[settingsValue dataUsingEncoding:NSUTF8StringEncoding] forKey:settingsName];
//        }
//        
//        if (target != dataStore)
//            [dataStore setObject:(NSMutableDictionary*)target forKey:settingsDict];
//        [dataStore synchronize];
//        
//        result = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK];
//        
//    } @catch (NSException * e) {
//        
//        result = [CDVPluginResult resultWithStatus:CDVCommandStatus_NO_RESULT messageAsString:[e reason]];
//        
//    } @finally {
//        
//        [self.commandDelegate sendPluginResult:result callbackId:[command callbackId]];
//    }
//    //}];
//}
//
///*
// Parsing the Root.plist for the key, because there is a bug/feature in Settings.bundle
// So if the user haven't entered the Settings for the app, the default values aren't accessible through NSUserDefaults.
// */
//
//- (NSString*)getSettingFromBundle:(NSString*)settingsName
//{
//    NSString *pathStr = [[NSBundle mainBundle] bundlePath];
//    NSString *settingsBundlePath = [pathStr stringByAppendingPathComponent:@"Settings.bundle"];
//    NSString *finalPath = [settingsBundlePath stringByAppendingPathComponent:@"Root.plist"];
//    
//    NSDictionary *settingsDict = [NSDictionary dictionaryWithContentsOfFile:finalPath];
//    NSArray *prefSpecifierArray = [settingsDict objectForKey:@"PreferenceSpecifiers"];
//    NSDictionary *prefItem;
//    for (prefItem in prefSpecifierArray)
//    {
//        if ([[prefItem objectForKey:@"Key"] isEqualToString:settingsName])
//            return [prefItem objectForKey:@"DefaultValue"];
//    }
//    return nil;
//    
//}
@end
