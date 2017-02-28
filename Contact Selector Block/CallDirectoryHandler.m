//
//  CallDirectoryHandler.m
//  Contact Selector Block
//
//  Created by Dam Vu Duy on 2/26/17.
//  Copyright © 2017 CPU11815. All rights reserved.
//

#import "CallDirectoryHandler.h"
#import "CSBlockDatebaseManager.h"
#import "CSContact.h"

@interface CallDirectoryHandler () <CXCallDirectoryExtensionContextDelegate>
@end

@implementation CallDirectoryHandler

- (void)beginRequestWithExtensionContext:(CXCallDirectoryExtensionContext *)context {
    context.delegate = self;

    if (![self addBlockingPhoneNumbersToContext:context]) {
        NSLog(@"Unable to add blocking phone numbers");
        NSError *error = [NSError errorWithDomain:@"CallDirectoryHandler" code:1 userInfo:nil];
        [context cancelRequestWithError:error];
        return;
    }
    
    if (![self addIdentificationPhoneNumbersToContext:context]) {
        NSLog(@"Unable to add identification phone numbers");
        NSError *error = [NSError errorWithDomain:@"CallDirectoryHandler" code:2 userInfo:nil];
        [context cancelRequestWithError:error];
        return;
    }
    
    [context completeRequestWithCompletionHandler:nil];
}

- (BOOL)addBlockingPhoneNumbersToContext:(CXCallDirectoryExtensionContext *)context {
    // Retrieve phone numbers to block from data store. For optimal performance and memory usage when there are many phone numbers,
    // consider only loading a subset of numbers at a given time and using autorelease pool(s) to release objects allocated during each batch of numbers which are loaded.
    //
    // Numbers must be provided in numerically ascending order.
    
    CSBlockDatebaseManager * manager = [CSBlockDatebaseManager manager];
    NSArray * allContact = [manager getAllBlockContact];
    NSMutableArray * allNumber = [NSMutableArray array];
    
    for (CSContact * contact in allContact) {
        for (NSString * phone in contact.phoneNumbers) {
            if ([phone characterAtIndex:0] == '+') {
                [allNumber addObject:[phone substringFromIndex:1]];
            } else {
                [allNumber addObject:phone];
            }
        }
    }
    
    [allNumber sortUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
        NSString * phone1 = (NSString *) obj1;
        NSString * phone2 = (NSString *) obj2;
        return [phone1 compare:phone2];
    }];
    
    for (int i = 0; i < allNumber.count; i++) {
        NSString * phone = allNumber[i];
        
        NSNumberFormatter * f = [[NSNumberFormatter alloc] init];
        [f setNumberStyle:NSNumberFormatterDecimalStyle];
        NSNumber * myNumber = [f numberFromString:phone];
        
        CXCallDirectoryPhoneNumber phoneNumber = (CXCallDirectoryPhoneNumber)[myNumber longLongValue];
        
        //        CXCallDirectoryPhoneNumber phoneNumber = 84969143732;
        
        [context addBlockingEntryWithNextSequentialPhoneNumber:phoneNumber];
    }

    return YES;
}

- (BOOL)addIdentificationPhoneNumbersToContext:(CXCallDirectoryExtensionContext *)context {
    // Retrieve phone numbers to identify and their identification labels from data store. For optimal performance and memory usage when there are many phone numbers,
    // consider only loading a subset of numbers at a given time and using autorelease pool(s) to release objects allocated during each batch of numbers which are loaded.
    //
    // Numbers must be provided in numerically ascending order.
    
//    CXCallDirectoryPhoneNumber phoneNumbers[] = {  };
//    NSArray<NSString *> *labels = @[ ];
//    NSUInteger count = (sizeof(phoneNumbers) / sizeof(CXCallDirectoryPhoneNumber));
//
//    for (NSUInteger i = 0; i < count; i += 1) {
//        CXCallDirectoryPhoneNumber phoneNumber = phoneNumbers[i];
//        NSString *label = labels[i];
//        [context addIdentificationEntryWithNextSequentialPhoneNumber:phoneNumber label:label];
//    }

    return YES;
}

#pragma mark - CXCallDirectoryExtensionContextDelegate

- (void)requestFailedForExtensionContext:(CXCallDirectoryExtensionContext *)extensionContext withError:(NSError *)error {
    // An error occurred while adding blocking or identification entries, check the NSError for details.
    // For Call Directory error codes, see the CXErrorCodeCallDirectoryManagerError enum in <CallKit/CXError.h>.
    //
    // This may be used to store the error details in a location accessible by the extension's containing app, so that the
    // app may be notified about errors which occured while loading data even if the request to load data was initiated by
    // the user in Settings instead of via the app itself.
}

@end
