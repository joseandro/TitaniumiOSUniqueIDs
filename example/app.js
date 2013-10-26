// open a single window
var win = Ti.UI.createWindow({
	backgroundColor:'white'
});
win.open();

var iOSUniqueID = require('com.joseandro.uniqueids');

Ti.API.info("UUID : " + iOSUniqueID.getUUID);
Ti.API.info("Identifier for vendor: " + iOSUniqueID.getIdentifierForVendor);
Ti.API.info("Identifier for advertising: " + iOSUniqueID.getAdvertisingIdentifier);
Ti.API.info("Is advertising tracking enabled? " + iOSUniqueID.isAdsTrackingEnabled);