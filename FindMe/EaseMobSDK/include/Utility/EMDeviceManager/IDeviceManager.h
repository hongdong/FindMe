/*!
 @header IDeviceManager.h
 @abstract DeviceManager各类协议的合集
 @author EaseMob Inc.
 @version 1.00 2014/01/01 Creation (1.00)
 */
#import <Foundation/Foundation.h>
#import "internal/IDeviceManagerProximitySensor.h"
#import "internal/IDeviceManagerLocation.h"
#import "internal/IDeviceManagerDevice.h"
#import "internal/IDeviceManagerCamera.h"
#import "internal/IDeviceManagerMedia.h"

/*!
 @protocol
 @brief DeviceManager各类协议的合集
 @discussion
 */
@protocol IDeviceManager <IDeviceManagerMedia,
                        IDeviceManagerCamera,
                        IDeviceManagerDevice,
                        IDeviceManagerLocation,
                        IDeviceManagerProximitySensor>

@required

@end
