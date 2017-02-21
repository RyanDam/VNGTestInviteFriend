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

@interface CSContactProvider()

@property (nonatomic) float currentIOSVersion;

@end

@implementation CSContactProvider

- (float)currentIOSVersion {
    return 9.0;
}

- (void)getDataArrayWithCompletion:(void (^)(NSArray<CSModel *> *, NSError *))completion {
    
    if (completion == nil)
        return;
    
    if (self.currentIOSVersion >= 9.0) {
        [self getDataArrayUsingContactFramework:completion];
    } else {
        [self getDataArrayUsingAddressBook:completion];
    }
}

- (void) getDataArrayUsingContactFramework:(void (^)(NSArray<CSModel *> * data, NSError * err))completion {
    CNContactStore * store = [[CNContactStore alloc] init];
    [store requestAccessForEntityType:CNEntityTypeContacts completionHandler:^(BOOL granted, NSError * _Nullable err) {
        
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
        
        completion(contactNumbersArray ,nil);
    }];
}

- (void) getDataArrayUsingAddressBook:(void (^)(NSArray<CSModel *> * data, NSError * err))completion {
    
}

- (CSContact *) getInfoFromCNContact: (CNContact *) contact {
    
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

@end
