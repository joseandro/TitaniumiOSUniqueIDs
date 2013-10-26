TitaniumiOSUniqueIDs
====================

With this native iOS Titanium module you will be able to get the replacements ( UUID, identifierForVendor and advertisingIdentifier) for the deprecated means of getting the UDID / Open UDID / MAC Address on iOS 7. 

##Usage example:

~~~
var iOSUniqueID = require('com.joseandro.uniqueids');

Ti.API.info("UUID : " + iOSUniqueID.getUUID);
Ti.API.info("Identifier for vendor: " + iOSUniqueID.getIdentifierForVendor);
Ti.API.info("Identifier for advertising: " + iOSUniqueID.getAdvertisingIdentifier);
Ti.API.info("Is advertising tracking enabled? " + iOSUniqueID.isAdsTrackingEnabled);
~~~
[Check App.js](https://github.com/joseandro/TitaniumiOSUniqueIDs/tree/master/example)

##Methods:

####getUUID
This method simply returns a string containing a UUID by using the appIdentifier method defined in TiUtils.h.
The standard format for UUIDs represented in ASCII is a string punctuated by hyphens, for example 68753A44-4D6F-1226-9C60-0050E4C00067.

For more information, check:
https://github.com/appcelerator/titanium_mobile/blob/master/iphone/Classes/TiUtils.m#L1732

Availability: Available in iOS 6.0 and later.

####getIdentifierForVendor

Returns an alphanumeric string that uniquely identifies a device to the app’s vendor. If the app is uninstalled and reinstalled, this value will be different.

Discussion:
The value of this property is the same for apps that come from the same vendor running on the same device. A different value is returned for apps on the same device that come from different vendors, and for apps on different devices regardless of vendor. Normally, the vendor is determined by data provided by the App Store. If the app was not installed from the app store (such as when the app is still in development), the vendor is determined based on the app’s bundle ID. The bundle ID is assumed to be in reverse-DNS format, and the first two components are used to generate a vendor ID. For example, com.example.app1 and com.example.app2 would appear to have the same vendor ID.

If the value is nil, wait and get the value again later. This happens, for example, after the device has been restarted but before the user has unlocked the device.
The value in this property remains the same while the app (or another app from the same vendor) is installed on the iOS device. The value changes when the user deletes all of that vendor’s apps from the device and subsequently reinstalls one or more of them. The value can also change when installing test builds using Xcode or when installing an app on a device using ad-hoc distribution. Therefore, if your app stores the value of this property anywhere, you should gracefully handle situations where the identifier changes.
 
Note: When implementing a system for serving advertisements, use the value returned by the method getAdvertisingIdentifier instead of this one. The use of that method requires you to follow the guidelines set forth in the class discussion for the proper use of that identifier.
 
Availability:
Available in iOS 6.0 and later.

####getAdvertisingIdentifier
Returns an alphanumeric string unique to each device, used only for serving advertisements.
 
Discussion:
Unlike the getIdentifierForVendor method returning value, the same value is returned to all vendors. This identifier may change—for example, if the user erases the device—so you should not cache it.
If the value is nil, wait and get the value again later. This happens, for example, after the device has been restarted but before the user has unlocked the device.
 
Availability:
Available in iOS 6.0 and later.
 

####isAdsTrackingEnabled
Returns a Boolean value that indicates whether the user has limited ad tracking.

Discussion:
Check the value of this property before performing any advertising tracking. If the value is "false", use the advertising identifier only for the following purposes: frequency capping, conversion events, estimating the number of unique users, security and fraud detection, and debugging.

Availability:
Available in iOS 6.0 and later.
