//
//  FBContactProvider.m
//  Contact Selector
//
//  Created by CPU11808 on 2/22/17.
//  Copyright © 2017 CPU11815. All rights reserved.
//

#import "FBContactProvider.h"
#import "FBContact.h"
@import FBSDKCoreKit;
@import AccountKit;

@interface FBContactProvider()

@property (nonatomic) dispatch_queue_t serialQueue;

@end

@implementation FBContactProvider

- (instancetype)init {
    if (self = [super init]) {
        self.serialQueue = dispatch_queue_create("com.vng.ContactSelector.FBContactProvider", DISPATCH_QUEUE_SERIAL);
    }
    return self;
}

//- (void)getDataArrayWithCompletion:(void (^)(NSArray<CSModel *> *, NSError *))completion {
//    
//    if (!completion) {
//        return;
//    }
//    
//    [[[FBSDKGraphRequest alloc] initWithGraphPath:@"me/friends" parameters:nil]
//     startWithCompletionHandler:^(FBSDKGraphRequestConnection *connection, id result, NSError *error) {
//         
//         dispatch_async(self.serialQueue, ^{
//             if (error) {
//                 completion(nil, error);
//                 return;
//             }
//             
//             NSArray *friends = [result objectForKey:@"data"];
//             
//             NSMutableArray* contacts = [NSMutableArray new];
//             
//             for (id user in friends) {
//                 CSModel *contact = [CSModel new];
//                 
//                 contact.fullName = [user objectForKey:@"name"];
//                 [contacts addObject:contact];
//             }
//             
//             completion(contacts, nil);
//         });
//     }];
//}

- (void)getDataArrayWithCompletion:(void (^)(NSArray<CSModel *> *, NSError *))completion {
    
    if (!completion) {
        return;
    }
    
    [[[FBSDKGraphRequest alloc] initWithGraphPath:@"me/taggable_friends?limit=25" parameters:nil]
     startWithCompletionHandler:^(FBSDKGraphRequestConnection *connection, id result, NSError *error) {
         
         dispatch_async(self.serialQueue, ^{
             if (error) {
                 completion(nil, error);
                 return;
             }
             
             NSArray *friends = result[@"data"];
             
             NSMutableArray* contacts = [NSMutableArray new];
             
             for (id user in friends) {
                 FBContact *contact = [FBContact new];
                 
                 contact.fullName = user[@"name"];
                 
                 contact.avatarUrl = user[@"picture"][@"data"][@"url"];
                 
                 [contacts addObject:contact];
             }
             
             if ([result[@"paging"][@"cursor"] containsValueForKey:@"after"]) {
                 NSString *afterToken = [result[@"paging"][@"cursor"] objectForKey:@"after"];
                 
                 
                 [self getNextContactPageWithAfterToken:afterToken andCompletionBlock:completion];
             } else {
             
             
             
                 completion(contacts, nil);
             }
         });
     }];
}

- (void) getNextContactPageWithAfterToken:(NSString *) afterToken andCompletionBlock:(void (^)(NSArray<CSModel* > *, NSError *))completion {
    
    NSDictionary *params = @{@"after" : afterToken,
                             @"limit" : @"25"};
    
    FBSDKGraphRequest* request = [[FBSDKGraphRequest alloc] initWithGraphPath:@"me/taggable_friends" parameters:params];
    [request startWithCompletionHandler:^(FBSDKGraphRequestConnection *connection, id result, NSError *error){
        dispatch_async(self.serialQueue, ^{
            if (error) {
                completion(nil, error);
                return;
            }
            
            NSArray *friends = result[@"data"];
            
            NSMutableArray* contacts = [NSMutableArray new];
            
            for (id user in friends) {
                FBContact *contact = [FBContact new];
                
                contact.fullName = user[@"name"];
                
                contact.avatarUrl = user[@"picture"][@"data"][@"url"];
                
                [contacts addObject:contact];
            }
            
            NSString *afterToken = result[@"paging"][@"cursor"][@"after"];
            
            if (afterToken == nil) {
                completion(contacts, nil);
            } else {
                [self getNextContactPageWithAfterToken:afterToken andCompletionBlock:completion];
            }
            
            
            
            
        });
    }];
    
}

@end
