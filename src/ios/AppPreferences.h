#import <Foundation/Foundation.h>

#import <Cordova/CDV.h>

@interface AppPreferences : CDVPlugin

- (void)fetch:(CDVInvokedUrlCommand*)command;

@end
