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

@property (nonatomic) NSString *afterPage;

@end

@implementation FBContactProvider

- (instancetype)init {
    if (self = [super init]) {
        self.serialQueue = dispatch_queue_create("com.vng.ContactSelector.FBContactProvider", DISPATCH_QUEUE_SERIAL);
        self.afterPage = @"start";
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
                 self.afterPage = [result[@"paging"][@"cursor"] objectForKey:@"after"];
             } else {
                 self.afterPage = @"end";
             }
             
             completion(contacts, nil);
         });
     }];
}

- (void) getNextContactPageWithAfterToken:(NSString *)afterToken andCompletionBlock:(void (^)(NSArray<CSModel* > *, NSError *))completion {
    
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
            
            if ([result[@"paging"][@"cursor"] containsValueForKey:@"after"]) {
                self.afterPage = [result[@"paging"][@"cursor"] objectForKey:@"after"];
            } else {
                self.afterPage = @"end";
            }
            
            completion(contacts, nil);
        });
    }];
}

- (void)getNextPageDataWithCompletion:(void (^)(NSArray<CSModel *> *, NSError *))completion {
    
    if (!completion)
        return;
    
    if ([self.afterPage isEqualToString:@"start"]) {
        [self getDataArrayWithCompletion:completion];
    } else if ([self.afterPage isEqualToString:@"end"]) {
        completion([NSArray new], nil);
    } else {
        [self getNextContactPageWithAfterToken:self.afterPage andCompletionBlock:completion];
    }
}

@end
