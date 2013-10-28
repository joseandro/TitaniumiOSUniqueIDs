/**
 * Author: Joseandro Luiz
 * Contact: joseandro . luiz at gmail . com
 *
 * Licensed under the MIT License
 */
#import "ComJoseandroUniqueidsModule.h"
#import "TiBase.h"
#import "TiHost.h"
#import "TiUtils.h"

#import <Security/Security.h>
#import <AdSupport/AdSupport.h>

#import "KeychainItemWrapper.h"

@implementation ComJoseandroUniqueidsModule

#pragma mark Internal

// this is generated for your module, please do not change it
-(id)moduleGUID
{
	return @"026cfeca-5a2f-4590-91f7-cc4063be352f";
}

// this is generated for your module, please do not change it
-(NSString*)moduleId
{
	return @"com.joseandro.uniqueids";
}

#pragma mark Lifecycle

-(void)startup
{
	// this method is called when the module is first loaded
	// you *must* call the superclass
	[super startup];
	
	NSLog(@"[INFO] %@ loaded",self);
}

-(void)shutdown:(id)sender
{
	// this method is called when the module is being unloaded
	// typically this is during shutdown. make sure you don't do too
	// much processing here or the app will be quit forceably
	
	// you *must* call the superclass
	[super shutdown:sender];
}

#pragma mark Cleanup

-(void)dealloc
{
	// release any resources that have been retained by the module
	[super dealloc];
}

#pragma mark Internal Memory Management

-(void)didReceiveMemoryWarning:(NSNotification*)notification
{
	// optionally release any resources that can be dynamically
	// reloaded once memory is available - such as caches
	[super didReceiveMemoryWarning:notification];
}

#pragma mark Listener Notifications

-(void)_listenerAdded:(NSString *)type count:(int)count
{
	if (count == 1 && [type isEqualToString:@"my_event"])
	{
		// the first (of potentially many) listener is being added
		// for event named 'my_event'
	}
}

-(void)_listenerRemoved:(NSString *)type count:(int)count
{
	if (count == 0 && [type isEqualToString:@"my_event"])
	{
		// the last listener called for event named 'my_event' has
		// been removed, we can optionally clean up any resources
		// since no body is listening at this point for that event
	}
}

#pragma Public APIs


/**
 * Returns an alphanumeric string that uniquely identifies a device to the app’s vendor. If the app is uninstalled and reinstalled, this value will be different.
 * Discussion
 * The value of this property is the same for apps that come from the same vendor running on the same device. A different value is returned for apps on the same device that come from different vendors, and for apps on different devices regardless of vendor. Normally, the vendor is determined by data provided by the App Store. If the app was not installed from the app store (such as when the app is still in development), the vendor is determined based on the app’s bundle ID. The bundle ID is assumed to be in reverse-DNS format, and the first two components are used to generate a vendor ID. For example, com.example.app1 and com.example.app2 would appear to have the same vendor ID.
 * If the value is nil, wait and get the value again later. This happens, for example, after the device has been restarted but before the user has unlocked the device.
 * The value in this property remains the same while the app (or another app from the same vendor) is installed on the iOS device. The value changes when the user deletes all of that vendor’s apps from the device and subsequently reinstalls one or more of them. The value can also change when installing test builds using Xcode or when installing an app on a device using ad-hoc distribution. Therefore, if your app stores the value of this property anywhere, you should gracefully handle situations where the identifier changes.
 * Note: When implementing a system for serving advertisements, use the value returned by the method getAdvertisingIdentifier instead of this one. The use of that method requires you to follow the guidelines set forth in the class discussion for the proper use of that identifier.
 * Availability
 * Available in iOS 6.0 and later.
 * Declared In
 * UIDevice.h
 */
- (NSString *) getIdentifierForVendor
{
    if ([[UIDevice currentDevice] respondsToSelector:@selector(identifierForVendor)]) {
        NSString *like_UDID=[NSString stringWithFormat:@"%@",
                             [[[UIDevice currentDevice] identifierForVendor] UUIDString]];
        
        return like_UDID;
    }
    return @"";
}

/**
 * Returns an alphanumeric string unique to each device, used only for serving advertisements.
 * Discussion:
 * Unlike the getIdentifierForVendor method returning value, the same value is returned to all vendors. This identifier may change—for example, if the user erases the device—so you should not cache it.
 * If the value is nil, wait and get the value again later. This happens, for example, after the device has been restarted but before the user has unlocked the device.
 * Availability
 * Available in iOS 6.0 and later.
 * Declared In
 * ASIdentifierManager.h
 */
-(NSString *) getAdvertisingIdentifier {
    Class ASIdentifierManagerClass = NSClassFromString(@"ASIdentifierManager");
    if (ASIdentifierManagerClass) {
        id identifierManager = [ASIdentifierManagerClass sharedManager];
        if ([ASIdentifierManagerClass instancesRespondToSelector:@selector(advertisingIdentifier)]) {
            id adID = [identifierManager performSelector:@selector(advertisingIdentifier)];
            return [adID performSelector:@selector(UUIDString)]; // you can use this sUDID as an alternative to UDID
        }
    }
    return @"";
}


/**
 * Returns a Boolean value that indicates whether the user has limited ad tracking.
 * Discussion:
 * Check the value of this property before performing any advertising tracking. If the value is FALSE, use the advertising identifier only for the following purposes: frequency capping, conversion events, estimating the number of unique users, security and fraud detection, and debugging.
 * Availability:
 * Available in iOS 6.0 and later.
 * Declared In:
 * ASIdentifierManager.h
 */
- (id)isAdsTrackingEnabled
{
    Class advertisingManagerClass = NSClassFromString(@"ASIdentifierManager");
    if ([advertisingManagerClass respondsToSelector:@selector(sharedManager)]){
        id advertisingManager = [[advertisingManagerClass class] performSelector:@selector(sharedManager)];
        
        if ([advertisingManager respondsToSelector:@selector(isAdvertisingTrackingEnabled)]){
            return NUMBOOL(YES);
        }
    }
    return NUMBOOL(NO);
}

/**
 * This method returns the UUID and add it to the user's keychain.
 * By using the keychain the UUID can be retrieved even if the system is rebooted or formatted.
 *
 * The standard format for UUIDs represented in ASCII is a string punctuated by hyphens, for example:
 * 68753A44-4D6F-1226-9C60-0050E4C00067.
 *
 * This method also avoids the Keychain UUID's entry to be used in other devices within the same iCloud account, turning it into unique even across the devices from the same user.
 *
 */
-(NSString *) getUUID
{
    KeychainItemWrapper* keychain = [[KeychainItemWrapper alloc] initWithIdentifier:@"com.joseandro.UUID"  accessGroup:nil];
    
    NSString* UUID = [keychain objectForKey:(kSecValueData)];
    
    if ( UUID == nil ||
        ( [UUID isKindOfClass:[NSString class]] && [UUID isEqualToString:@""] ) ){
        
        NSLog(@"[INFO] Keychain entry is empty, setting up a new one");
        
        CFUUIDRef theUUID = CFUUIDCreate(NULL);
        CFStringRef string = CFUUIDCreateString(NULL, theUUID);
        CFRelease(theUUID);
        
        UUID = [(NSString *)string autorelease];
        NSLog(@"[INFO] New UUID retrieved: %@", UUID);
        
        /* As per:
            http://useyourloaf.com/blog/2010/04/28/keychain-duplicate-item-when-adding-password.html

            "In database terms you could think of their being a unique index on the two attributes
            kSecAttrAccount, kSecAttrService requiring the combination of those two attributes to be unique
            for each entry in the keychain."
         */
         
        [keychain setObject:@"UNIQUE_IDS_SERVICE" forKey:kSecAttrService];
        [keychain setObject:@"DeviceUUID" forKey:kSecAttrAccount];
        [keychain setObject:UUID forKey:kSecValueData];

        // Make it last uniquely on this device (due iCloud, the same user could have many differents devices operating with the same keychain) 
        // even after the app's deleted, system rebooted  and formated :)
        [keychain setObject:kSecAttrAccessibleAlwaysThisDeviceOnly forKey:kSecAttrAccessible];
        
        [keychain release];
        keychain = nil;
        
        NSLog(@"[INFO] Keychain entry successfully added");
        return UUID;
    }
    
    [keychain release];
    keychain = nil;
    
    NSLog(@"[INFO] Keychain was reused :)");
    return UUID;
}
@end
