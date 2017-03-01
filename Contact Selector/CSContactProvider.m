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

@property (strong, nonatomic) NSArray *cacheContact;

@end

@implementation CSContactProvider

- (instancetype)init {
    if (self = [super init]) {
        self.serialQueue = dispatch_queue_create("com.vng.ContactSelector.CSContactProvider", DISPATCH_QUEUE_SERIAL);
    }
    return self;
}

- (void)getDataArrayWithCompletion:(void (^)(NSArray<CSModel *> *, NSError *))completion{
    
    if (completion == nil)
        return;

    if (SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"9.0")) {
        [self usingContactFrameworkWithCompletion:completion andCustomQueue:self.serialQueue];
    } else {
        [self usingAddressBookWithCompletion:completion andCustomQueue:self.serialQueue];
    }
}

- (void)getDataArrayWithCompletion:(void (^)(NSArray<CSModel *> *, NSError *))completion andCustomQueue:(dispatch_queue_t)queue {
    
    if (completion == nil)
        return;
    
    if (queue == NULL) {
        queue = self.serialQueue;
    }

    if (SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"9.0")) {
        [self usingContactFrameworkWithCompletion:completion andCustomQueue:queue];
    } else {
        [self usingAddressBookWithCompletion:completion andCustomQueue:queue];
    }
}

- (void)usingContactFrameworkWithCompletion:(void (^)(NSArray<CSModel *> * data, NSError * err))completion andCustomQueue:(dispatch_queue_t)queue{
    
    CNContactStore * store = [[CNContactStore alloc] init];
    [store requestAccessForEntityType:CNEntityTypeContacts completionHandler:^(BOOL granted, NSError * _Nullable err) {
        
        dispatch_async(queue, ^{
            if (!granted) {
                NSLog(@"User not granted permission");
                completion(nil, err);
                return;
            }
            
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
                CSContact * contactResult = [self getInfoFromCNContact:contact];
                if (contactResult.fullName.length == 0) {
                    continue;
                }
                [contactNumbersArray addObject:contactResult];
            }
            
            self.cacheContact = contactNumbersArray;
            
            completion(contactNumbersArray ,nil);
        });
    }];
}

- (void)usingAddressBookWithCompletion:(void (^)(NSArray<CSModel *> * data, NSError * err))completion andCustomQueue:(dispatch_queue_t)queue{
    
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
        return;
    }
    
    CFErrorRef error = NULL;
    ABAddressBookRef addressBook = ABAddressBookCreateWithOptions(NULL, &error);
    
    if (!addressBook) {
        NSLog(@"ABAddressBookCreateWithOptions error: %@", CFBridgingRelease(error));
        completion(nil, (__bridge NSError *)(error));
        return;
    }
    
    ABAddressBookRequestAccessWithCompletion(addressBook, ^(bool granted, CFErrorRef error) {
        
        dispatch_async(queue, ^{
            if (error) {
                NSLog(@"ABAddressBookRequestAccessWithCompletion error: %@", CFBridgingRelease(error));
                completion(nil, (__bridge NSError *)(error));
            }
            
            if (granted) {
                // if they gave you permission, then just carry on
                NSArray *allPeople = CFBridgingRelease(ABAddressBookCopyArrayOfAllPeople(addressBook));
                NSInteger numberOfPeople = [allPeople count];
                
                NSMutableArray *contactNumbersArray = [NSMutableArray array];
                
                for (NSInteger i = 0; i < numberOfPeople; i++) {
                    ABRecordRef person = (__bridge ABRecordRef)allPeople[i];
                    
                    CSContact *contact = [self getInfoFromABRecord:person];
                    if (contact.fullName.length == 0) {
                        continue;
                    }
                    
                    [contactNumbersArray addObject:contact];
                }
                
                self.cacheContact = contactNumbersArray;
                
                completion(contactNumbersArray, (__bridge NSError *)(error));
            } else {
                // however, if they didn't give you permission, handle it gracefully, for example...
                completion(nil, (__bridge NSError *)(error));
            }
            
            CFRelease(addressBook);
        });
    });
}

- (CSContact *)getInfoFromCNContact: (CNContact *)contact {
    
    NSString * fullName;
    NSString * firstName;
    NSString * lastName;
    NSMutableArray<NSString *> * phoneNumbers = [NSMutableArray array];
    NSMutableArray<NSString *> * emails = [NSMutableArray array];
    UIImage * profileImage;
    
    firstName = contact.givenName;
    lastName = contact.familyName;
    if (lastName == nil) {
        fullName=[NSString stringWithFormat:@"%@",firstName];
    } else if (firstName == nil) {
        fullName=[NSString stringWithFormat:@"%@",lastName];
    } else {
        fullName=[NSString stringWithFormat:@"%@ %@",firstName,lastName];
    }
    
    UIImage *image = [UIImage imageWithData:contact.imageData];
    if (image != nil) {
        profileImage = image;
    } else {
        profileImage = [UIImage imageNamed:@"person-icon.png"];
    }
    
    // get all email address
    for (CNLabeledValue<NSString *> * emailLabeled in contact.emailAddresses) {
        [emails addObject:emailLabeled.value];
    }
    
    // get all phone number
    for (CNLabeledValue<CNPhoneNumber *> * phoneLabeled in contact.phoneNumbers) {
        CNPhoneNumber * phone = phoneLabeled.value;
        [phoneNumbers addObject:phone.stringValue];
    }
    
    CSContact * contactResult = [[CSContact alloc] init];
    contactResult.fullName = [fullName stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    contactResult.avatar = profileImage;
    contactResult.emails = emails;
    contactResult.phoneNumbers = phoneNumbers;
    
    return contactResult;
}

- (CSContact *)getInfoFromABRecord: (ABRecordRef)person {
    
    NSString * fullName;
    NSString * firstName;
    NSString * lastName;
    NSMutableArray<NSString *> * phoneNumbers = [NSMutableArray array];
    NSMutableArray<NSString *> * emails = [NSMutableArray array];
    UIImage * profileImage;
    
    firstName = CFBridgingRelease(ABRecordCopyValue(person, kABPersonFirstNameProperty));
    lastName  = CFBridgingRelease(ABRecordCopyValue(person, kABPersonLastNameProperty));
    if (lastName == nil) {
        fullName=[NSString stringWithFormat:@"%@",firstName];
    } else if (firstName == nil) {
        fullName=[NSString stringWithFormat:@"%@",lastName];
    } else {
        fullName=[NSString stringWithFormat:@"%@ %@",firstName,lastName];
    }

    // get phone numbers
    ABMultiValueRef abPhoneNumbers = ABRecordCopyValue(person, kABPersonPhoneProperty);
    CFIndex numberOfPhoneNumbers = ABMultiValueGetCount(abPhoneNumbers);
    
    for (CFIndex i = 0; i < numberOfPhoneNumbers; i++) {
        NSString *phoneNumber = CFBridgingRelease(ABMultiValueCopyValueAtIndex(abPhoneNumbers, i));
        [phoneNumbers addObject:phoneNumber];
    }
    
    CFRelease(abPhoneNumbers);
    
    // get emails
    ABMultiValueRef abEmails = ABRecordCopyValue(person, kABPersonEmailProperty);
    CFIndex numberOfEmails = ABMultiValueGetCount(abEmails);
    
    for (CFIndex i = 0; i < numberOfEmails; i++) {
        NSString *email = CFBridgingRelease(ABMultiValueCopyValueAtIndex(abEmails, i));
        [emails addObject:email];
    }
    
    CFRelease(abEmails);
    
    // get image
    NSData  *imgData = (__bridge NSData *)ABPersonCopyImageData(person);
    if (imgData != nil)
        profileImage = [UIImage imageWithData:imgData];
    else
        profileImage = [UIImage imageNamed:@"person-icon.png"];

    CSContact *contactResult = [CSContact new];
    contactResult.fullName = [fullName stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    contactResult.avatar = profileImage;
    contactResult.emails = emails;
    contactResult.phoneNumbers = phoneNumbers;
    
    return contactResult;
}

- (void)getContactWithNumber:(NSString *)number withCompletion:(void (^)(CSModel *, NSError *))completion {

    if (self.cacheContact == nil) {
        [self getDataArrayWithCompletion:^(NSArray<CSModel *> * data, NSError * err) {
            
            for (CSContact *contact in data) {
                for (NSString* phoneNumber in contact.phoneNumbers) {
                    
                    if ([phoneNumber isEqualToString:number]) {
                        completion(contact, nil);
                        return;
                    }
                }
            }
            
            completion(nil, nil);
        }];
    } else {
        for (CSContact *contact in self.cacheContact) {
            for (NSString* phoneNumber in contact.phoneNumbers) {
                
                if ([phoneNumber isEqualToString:number]) {
                    completion(contact, nil);
                    return;
                }
            }
        }
    }
}

@end
