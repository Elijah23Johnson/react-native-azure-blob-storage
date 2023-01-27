#import "EAzureBlobStorageFile.h"
#import <AZSClient/AZSClient.h>
#import <AZSClient/AZSSharedAccessBlobParameters.h>
NSString *ACCOUNT_NAME = @"account_name";
NSString *ACCOUNT_KEY = @"account_key";
NSString *CONTAINER_NAME = @"container_name";
NSString *CONNECTION_STRING = @"";
BOOL *SAS = false;
static NSString *const _filePath = @"filePath";
static NSString *const _contentType = @"contentType";
static NSString *const _fileName = @"fileName";
@implementation EAzureBlobStorageFile
RCT_EXPORT_MODULE();
RCT_EXPORT_METHOD(uploadFile:(NSDictionary *)options
         findEventsWithResolver:(RCTPromiseResolveBlock)resolve
         rejecter:(RCTPromiseRejectBlock)reject)
{
  if(SAS){
    [self uploadBlobToContainer: options rejecter:reject resolver:resolve];
  }else{
    [self uploadBlobToContainerSas: options rejecter:reject resolver:resolve];
  }
}
-(NSString *)genRandStringLength:(int)len {
  static NSString *letters = @"abcdefghijklmnopqrstuvwxyz";
  NSMutableString *randomString = [NSMutableString stringWithCapacity: len];
  for (int i=0; i<len; i++) {
    [randomString appendFormat: @"%C", [letters characterAtIndex: arc4random() % [letters length]]];
  }
  return randomString;
}
-(void)uploadBlobToContainer:(NSDictionary *)options rejecter:(RCTPromiseRejectBlock)reject resolver:(RCTPromiseResolveBlock)resolve{
  NSError *accountCreationError;
  NSString *fileName = @"";
  NSString *contentType = @"image/png";
  NSString *filePath = @"";
  if ([options valueForKey:_fileName] != [NSNull null]) {
    fileName = [options valueForKey:_fileName];
  }
  if ([options valueForKey:_contentType] != [NSNull null]) {
    contentType = [options valueForKey:_contentType];
  }
  if ([options valueForKey:_filePath] != [NSNull null]) {
    filePath = [options valueForKey:_filePath];
  }
  // Create a storage account object from a connection string.
  AZSCloudStorageAccount *account = [AZSCloudStorageAccount accountFromConnectionString:CONNECTION_STRING error:&accountCreationError];
  if(accountCreationError){
    NSLog(@"Error in creating account.");
  }
  // Create a blob service client object.
  AZSCloudBlobClient *blobClient = [account getBlobClient];
  // Create a local container object.
  AZSCloudBlobContainer *blobContainer = [blobClient containerReferenceFromName:CONTAINER_NAME];
  [blobContainer createContainerIfNotExistsWithAccessType:AZSContainerPublicAccessTypeContainer requestOptions:nil operationContext:nil completionHandler:^(NSError *error, BOOL exists)
    {
      if (error){
        reject(@"no_event",@"Error in creating container.",error);
      }
      else{
        // Create a local blob object
        AZSCloudBlockBlob *blockBlob = [blobContainer blockBlobReferenceFromName:fileName];
        blockBlob.properties.contentType = contentType;
        [blockBlob uploadFromFileWithURL:[NSURL URLWithString:filePath] completionHandler:^(NSError * error) {
          if (error){
            reject(@"no_event",[NSString stringWithFormat: @"Error in creating blob. %@",filePath],error);
          }else{
            resolve(fileName);
          }    
        }];
      }
    }];
}
-(void)uploadBlobToContainerSas:(NSDictionary *)options rejecter:(RCTPromiseRejectBlock)reject resolver:(RCTPromiseResolveBlock)resolve{
  NSError *accountCreationError;
  NSString *fileName = @"";
  NSString *contentType = @"image/png";
  NSString *filePath = @"";
  if ([options valueForKey:_fileName] != [NSNull null]) {
    fileName = [options valueForKey:_fileName];
  }
  if ([options valueForKey:_contentType] != [NSNull null]) {
    contentType = [options valueForKey:_contentType];
  }
  if ([options valueForKey:_filePath] != [NSNull null]) {
    filePath = [options valueForKey:_filePath];
  }
  AZSCloudStorageAccount *account = [AZSCloudStorageAccount accountFromConnectionString:CONNECTION_STRING error:&accountCreationError];
  // Create a storage account object from a connection string.
  AZSCloudBlobClient *blobClient = [account getBlobClient];
  AZSSharedAccessBlobParameters *sp = [[AZSSharedAccessBlobParameters alloc] init];
  sp.storedPolicyIdentifier = @"readwrite";
  AZSSharedAccessPolicy *policy = [[AZSSharedAccessPolicy alloc] initWithIdentifier:sp.storedPolicyIdentifier];
  policy.permissions = AZSSharedAccessPermissionsRead|AZSSharedAccessPermissionsWrite;
  policy.sharedAccessExpiryTime = [[NSDate alloc] initWithTimeIntervalSinceNow:300];
  NSMutableDictionary *permissions = [NSMutableDictionary dictionaryWithDictionary: @{sp.storedPolicyIdentifier : policy}];
  AZSCloudBlobContainer *blobContainer = [blobClient containerReferenceFromName:CONTAINER_NAME];
  [blobContainer uploadPermissions:permissions completionHandler:^(NSError *err) {
    if (err){
      reject(@"no_event",@"Error in creating container.",err);
    }else{
      __block NSError *error = nil;
      NSString *sasToken = [blobContainer createSharedAccessSignatureWithParameters:sp error:&error];
      AZSCloudBlockBlob *blockBlob = [blobContainer blockBlobReferenceFromName:fileName];
      blockBlob.properties.contentType = contentType;
      [blockBlob uploadFromFileWithURL:[NSURL URLWithString:filePath] completionHandler:^(NSError *err){
        if(err){
          reject(@"no_event",[NSString stringWithFormat: @"Error in creating blob. %@",filePath],error);
        }else{
          NSString *str = [NSString stringWithFormat: @"%@%@", blockBlob.storageUri.primaryUri, sasToken];
          resolve(str);
        }
      }];
    }
  }];
}
RCT_EXPORT_METHOD(configure:(NSString *)account_name
         key:(NSString *)account_key
         container:(NSString *)conatiner_name
         token:(BOOL *)sas_token)
{
  ACCOUNT_NAME = account_name;
  ACCOUNT_KEY = account_key;
  CONTAINER_NAME = [conatiner_name lowercaseString];
  CONNECTION_STRING = [NSString stringWithFormat:@"DefaultEndpointsProtocol=https;AccountName=%@;AccountKey=%@",ACCOUNT_NAME,ACCOUNT_KEY];
  SAS = sas_token;
}
@end