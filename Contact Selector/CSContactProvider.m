//
//  CSContactProvider.m
//  Contact Selector
//
//  Created by CPU11815 on 2/20/17.
//  Copyright © 2017 CPU11815. All rights reserved.
//

#import "CSContactProvider.h"
#import "CSContact.h"
@import Contacts;
@import AddressBook;

/*
 *  System Versioning Preprocessor Macros
 */

#define SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(v)  ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedAscending)

@interface CSContactProvider()

@property (nonatomic) dispatch_queue_t serialQueue;

@end

@implementation CSContactProvider

- (instancetype)init {
    if (self = [super init]) {
        self.serialQueue = dispatch_queue_create("com.vng.ContactSelector.CSContactProvider", DISPATCH_QUEUE_SERIAL);
    }
    return self;
}

- (void)getDataArrayWithCompletion:(void (^)(NSArray<CSModel *> *, NSError *))completion{
    
    [self getDataArrayWithCompletion:completion andQueue:NULL];
}

- (void)getDataArrayWithCompletion:(void (^)(NSArray<CSModel *> *, NSError *))completion andQueue:(dispatch_queue_t)queue {
    
    if (completion) {
        
        dispatch_async(self.serialQueue, ^{
            
            if (SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"9.0")) {
                
                CNContactStore * store = [[CNContactStore alloc] init];
                [store requestAccessForEntityType:CNEntityTypeContacts completionHandler:^(BOOL granted, NSError * _Nullable err) {
                                    
                    if (!granted) {
                        NSLog(@"User not granted permission");
                        completion(nil, err);
                    } else {
                        
                        NSArray *keys = @[CNContactFamilyNameKey, CNContactGivenNameKey, CNContactImageDataKey, CNContactPhoneNumbersKey, CNContactEmailAddressesKey];
                        
                        // get all contact group info
                        NSError * error;
                        NSArray * allContainer = [store containersMatchingPredicate:nil error:&error];
                        
                        NSArray *allContacts = [NSArray array];
                        if (error) {
                            completion(nil, error);
                        } else {
                            for (CNContainer * container in allContainer) {
                                NSPredicate *predicate = [CNContact predicateForContactsInContainerWithIdentifier:container.identifier];
                                NSError *error;
                                NSArray *cnContacts = [store unifiedContactsMatchingPredicate:predicate keysToFetch:keys error:&error];
                                
                                if (error) {
                                    completion(nil, error);
                                } else {
                                    allContacts = [allContacts arrayByAddingObjectsFromArray:cnContacts];
                                }
                            }
                        }
                        
                        NSMutableArray *contactNumbersArray = [NSMutableArray array];
                        
                        // convert CNContact to CSContact
                        for (CNContact *contact in allContacts) {
                            CSContact * contactResult = [[CSContact alloc] initWithCNContact:contact];
                            if (contactResult.fullName.length > 0) {
                                [contactNumbersArray addObject:contactResult];
                            }
                        }
                        
                        if (queue == NULL) {
                            dispatch_async(dispatch_get_main_queue(), ^{
                                completion(contactNumbersArray, nil);
                            });
                        } else {
                            dispatch_async(queue, ^{
                                completion(contactNumbersArray, nil);
                            });
                        }
                    }
                }];
            } else {
                
                ABAuthorizationStatus status = ABAddressBookGetAuthorizationStatus();
                
                if (status == kABAuthorizationStatusDenied || status == kABAuthorizationStatusRestricted) {
                    // if you got here, user had previously denied/revoked permission for your
                    // app to access the contacts, and all you can do is handle this gracefully,
                    // perhaps telling the user that they have to go to settings to grant access
                    // to contacts
                    
                    NSMutableDictionary* details = [NSMutableDictionary dictionary];
                    [details setValue:@"User had previously denied/revoked permission for your app to access the contacts." forKey:NSLocalizedDescriptionKey];
                    NSError *err = [NSError errorWithDomain:@"com.vng.ContactSelector.CSContactProvider" code:1000 userInfo:details];
                    
                    completion(nil, err);
                } else {
                    
                    CFErrorRef error = NULL;
                    ABAddressBookRef addressBook = ABAddressBookCreateWithOptions(NULL, &error);
                    
                    if (!addressBook) {
                        NSLog(@"ABAddressBookCreateWithOptions error: %@", CFBridgingRelease(error));
                        completion(nil, (__bridge NSError *)(error));
                    } else {
                        
                        ABAddressBookRequestAccessWithCompletion(addressBook, ^(bool granted, CFErrorRef error) {
                            
                            if (error) {
                                NSLog(@"ABAddressBookRequestAccessWithCompletion error: %@", CFBridgingRelease(error));
                                completion(nil, (__bridge NSError *)(error));
                            } else if (granted) {
                                // if they gave you permission, then just carry on
                                NSArray *allPeople = CFBridgingRelease(ABAddressBookCopyArrayOfAllPeople(addressBook));
                                NSInteger numberOfPeople = [allPeople count];
                                
                                NSMutableArray *contactNumbersArray = [NSMutableArray array];
                                
                                for (NSInteger i = 0; i < numberOfPeople; i++) {
                                    ABRecordRef person = (__bridge ABRecordRef)allPeople[i];
                                    
                                    CSContact *contact = [[CSContact alloc] initWithABRecord:person];
                                    if (contact.fullName.length > 0) {
                                        [contactNumbersArray addObject:contact];
                                    }
                                }
                                
                                if (queue != NULL) {
                                    dispatch_async(queue, ^{
                                        completion(contactNumbersArray, (__bridge NSError *)(error));
                                    });
                                } else {
                                    dispatch_async(dispatch_get_main_queue(), ^{
                                        completion(contactNumbersArray, (__bridge NSError *)(error));
                                    });
                                }
                            } else {
                                // however, if they didn't give you permission, handle it gracefully, for example...
                                completion(nil, (__bridge NSError *)(error));
                            }
                            
                            CFRelease(addressBook);
                        });
                    }
                }
            }
        });
    }
}

@end
