#import "EAzureBlobStorageImage.h"
#import <AZSClient/AZSClient.h>

NSString *ACCOUNT_NAME = @"account_name" 
NSString *ACCOUNT_KEY = @"account_key" 
NSString *CONTAINER_NAME = @"container_name" 
NSString *CONNECTION_STRING = [NSString stringWithFormat:@"DefaultEndpointsProtocol=https; AccountName= %@; AccountKey= %@",ACCOUNT_NAME,ACCOUNT_KEY];

@implementation EAzureBlobStorageImage

// To export a module named CalendarManager
RCT_EXPORT_MODULE();

// This would name the module AwesomeCalendarManager instead
// RCT_EXPORT_MODULE(AwesomeCalendarManager);

RCT_EXPORT_METHOD(uploadFile:(NSString *)name
                 findEventsWithResolver:(RCTPromiseResolveBlock)resolve
                 rejecter:(RCTPromiseRejectBlock)reject)
{
    AZSCloudStorageAccount *account = [AZSCloudStorageAccount accountFromConnectionString: CONNECTION_STRING];
    AZSCloudBlobClient *blobClient = [account getBlobClient];
    NSString *containerName = [CONTAINER_NAME lowercaseString];
    AZSCloudBlobContainer *blobContainer = [blobClient containerReferenceFromName:containerName];
    

    let blob = blobContainer.getBlockReference(forName: CONTAINER_NAME);
    NSString *nm = name ?? "";
    if(!nn.isEmpty){
    blob.upload(fromFile: nm,  completionHandler: { (error: Error?) -> Void in
                        if (error) {
                           reject(@"no_events", @"There was an error", error);
                        }else{
                           resolve(@"Success");
                        }
                    })
    }else{
      NSError *error;
      reject(@"no_events", @"File name cannot be empty.", error);
    }

}


RCT_EXPORT_METHOD(configure:(NSString *)account_name
                 key:(NSString)account_key
                 container:(NSString)conatiner_name)
{
   ACCOUNT_NAME = account_name;
   ACCOUNT_KEY = account_key;
   CONTAINER_NAME = conatiner_name;
}

@end
