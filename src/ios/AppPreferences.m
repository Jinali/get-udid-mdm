#import "AppPreferences.h"

@implementation AppPreferences

- (void)pluginInitialize
{
    
}

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

@end
