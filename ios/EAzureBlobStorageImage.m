#import "EAzureBlobStorageImage.h"

@implementation EAzureBlobStorageImage

// To export a module named CalendarManager
RCT_EXPORT_MODULE();

// This would name the module AwesomeCalendarManager instead
// RCT_EXPORT_MODULE(AwesomeCalendarManager);

RCT_EXPORT_METHOD(uploadFile:(NSString *)name
                 findEventsWithResolver:(RCTPromiseResolveBlock)resolve
                 rejecter:(RCTPromiseRejectBlock)reject)
{
    NSString *events = name;
  if (events) {
    resolve(events);
  } else {
      NSError *error;
    reject(@"no_events", @"There were no events", error);
  }
}

@end
