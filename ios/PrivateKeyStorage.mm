#import "PrivateKeyStorage.h"
#import "PrivateKeyStorage-Swift.h"

@implementation PrivateKeyStorage {
  PrivateKeyStorageImpl *_storage;
}

RCT_EXPORT_MODULE()

- (instancetype)init {
  if (self = [super init]) {
    _storage = [[PrivateKeyStorageImpl alloc] init];
  }
  return self;
}

- (void)savePrivateKey:(NSString *)accountId
             base64Key:(NSString *)base64Key
                resolve:(RCTPromiseResolveBlock)resolve
                 reject:(RCTPromiseRejectBlock)reject {
  [_storage savePrivateKey:accountId base64Key:base64Key resolve:resolve reject:reject];
}

- (void)savePrivateKeys:(nonnull NSDictionary *)privateKeys
                resolve:(nonnull RCTPromiseResolveBlock)resolve 
                 reject:(nonnull RCTPromiseRejectBlock)reject { 
  [_storage savePrivateKeys:privateKeys resolve:resolve reject:reject];
}

- (void)getPrivateKey:(NSString *)accountId
              resolve:(RCTPromiseResolveBlock)resolve
               reject:(RCTPromiseRejectBlock)reject {
  [_storage getPrivateKey:accountId resolve:resolve reject:reject];
}

- (void)getPrivateKeys:(RCTPromiseResolveBlock)resolve
                reject:(RCTPromiseRejectBlock)reject {
  [_storage getPrivateKeys:resolve reject:reject];
}

- (void)deletePrivateKey:(NSString *)accountId
                 resolve:(RCTPromiseResolveBlock)resolve
                  reject:(RCTPromiseRejectBlock)reject {
  [_storage deletePrivateKey:accountId resolve:resolve reject:reject];
}

- (void)deletePrivateKeys:(nonnull RCTPromiseResolveBlock)resolve
                   reject:(nonnull RCTPromiseRejectBlock)reject { 
  [_storage deletePrivateKeys:resolve reject:reject];
}

- (std::shared_ptr<facebook::react::TurboModule>)getTurboModule:
  (const facebook::react::ObjCTurboModule::InitParams &)params {
  return std::make_shared<facebook::react::NativePrivateKeyStorageSpecJSI>(params);
}

@end
