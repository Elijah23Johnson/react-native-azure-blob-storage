// CalendarManager.m
#import "EAzureBlobStorageImage.h"

@implementation EAzureBlobStorageImage

// To export a module named CalendarManager
RCT_EXPORT_MODULE();

// This would name the module AwesomeCalendarManager instead
// RCT_EXPORT_MODULE(AwesomeCalendarManager);

RCT_EXPORT_METHOD(uploadFile:(NSString *)name,
                 findEventsWithResolver:(RCTPromiseResolveBlock)resolve
                 rejecter:(RCTPromiseRejectBlock)reject)
{
  NSArray *events = ["Testing"]
  if (events) {
    resolve(events);
  } else {
    NSError *error = "Error no file found"
    reject(@"no_events", @"There were no events", error);
  }
}

@end