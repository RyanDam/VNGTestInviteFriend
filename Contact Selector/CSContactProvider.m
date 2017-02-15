//
//  CSContactProvider.m
//  Contact Selector
//
//  Created by CPU11815 on 2/13/17.
//  Copyright © 2017 CPU11815. All rights reserved.
//

#import "CSContactProvider.h"
#import "CSContact.h"

@import Contacts;

@interface CSContactProvider()

@property (nonatomic, strong) NSArray * allContacts;

@property (nonatomic, strong) NSDictionary * contactDictionary;
@property (nonatomic, strong) NSArray * contactIndex;

@property (nonatomic, strong) NSDictionary * originalContactDictionary;
@property (nonatomic, strong) NSArray * originalContactIndex;

@property (nonatomic, strong) NSString * lastSearchText;

@end

@implementation CSContactProvider

- (instancetype) init {
    if (self = [super init]) {
        [self getAllContact];
        return self;
    }
    return nil;
}

- (void) getAllContact {
    
    dispatch_group_t waitGroup = dispatch_group_create();
    dispatch_group_enter(waitGroup);
    
    CNContactStore * store = [[CNContactStore alloc] init];
    [store requestAccessForEntityType:CNEntityTypeContacts completionHandler:^(BOOL granted, NSError * _Nullable err) {
        
        if (!granted) {
            NSLog(@"User not granted permission");
            return;
        }
        
        NSArray *keys = @[CNContactFamilyNameKey, CNContactGivenNameKey, CNContactImageDataKey];
        
        NSString *containerId = store.defaultContainerIdentifier;
        NSPredicate *predicate = [CNContact predicateForContactsInContainerWithIdentifier:containerId];
        NSError *error;
        NSArray *cnContacts = [store unifiedContactsMatchingPredicate:predicate keysToFetch:keys error:&error];
        
        if (err) {
            NSLog(@"Get contact error!");
        } else {
            NSMutableArray *contactNumbersArray = [NSMutableArray array];
            
            for (CNContact *contact in cnContacts) {
                CSContact * contactResult = [self getInfoFromCNContact:contact];
                [contactNumbersArray addObject:contactResult];
            }
            
            NSArray * sortedContact = [contactNumbersArray sortedArrayUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
                CSContact * currentContact = (CSContact *) obj1;
                CSContact * nextContact = (CSContact *) obj2;
                return [currentContact.fullname caseInsensitiveCompare:nextContact.fullname];
            }];
            
            NSMutableArray * contactIndex = [NSMutableArray array];
            NSMutableDictionary * contactDicionany = [NSMutableDictionary dictionary];
            
            for (CSContact * contact in sortedContact) {
                NSString * currentFirstCharOfContactName = [[contact.fullname substringWithRange:NSMakeRange(0, 1)] uppercaseString];
                
                if (contactIndex.count == 0) {
                    [contactIndex addObject:currentFirstCharOfContactName];
                    NSMutableArray * contactArray = [NSMutableArray arrayWithObject:contact];
                    [contactDicionany setObject:contactArray forKey:currentFirstCharOfContactName];
                } else {
                    NSString * currentLastIndex = (NSString *) contactIndex[contactIndex.count - 1];
                    
                    if ([currentFirstCharOfContactName localizedCaseInsensitiveCompare:currentLastIndex] != NSOrderedSame) {
                        [contactIndex addObject:currentFirstCharOfContactName];
                        NSMutableArray * contactArray = [NSMutableArray arrayWithObject:contact];
                        [contactDicionany setObject:contactArray forKey:currentFirstCharOfContactName];
                    } else {
                        NSMutableArray * contactArray = [contactDicionany objectForKey:currentLastIndex];
                        [contactArray addObject:contact];
                    }
                }
            }
            
            self.allContacts = contactNumbersArray;
            
            self.contactIndex = contactIndex;
            self.contactDictionary = contactDicionany;
            
            self.originalContactIndex = [contactIndex copy];
            self.originalContactDictionary = [contactDicionany copy];
        }
        
        dispatch_group_leave(waitGroup);
    }];
    
    dispatch_group_wait(waitGroup, DISPATCH_TIME_FOREVER);
}

- (CSContact *) getInfoFromCNContact: (CNContact *) contact {
    
    NSString *fullName;
    NSString *firstName;
    NSString *lastName;
    UIImage *profileImage;
    
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

    CSContact * contactResult = [[CSContact alloc] init];
    
    contactResult.fullname = fullName;
    contactResult.avatar = profileImage;
    
    return contactResult;
}

- (NSArray *) getContactIndex {
    return self.contactIndex;
}

- (NSDictionary *) getContactDictionary {
    return self.contactDictionary;
}

- (void)prepareForSearch {
    
    self.lastSearchText = @"";
}

- (void)performSearchText:(NSString *)text {
    
    if (text.length > 0) {
        NSMutableArray * searchedArray = [NSMutableArray array];
        NSArray * arrayToSearch = self.allContacts;
        
        for (CSContact * contact in arrayToSearch) {
            if ([contact.fullname.lowercaseString containsString:text.lowercaseString]) {
                [searchedArray addObject:contact];
            }
        }
        
        self.contactIndex = [NSArray arrayWithObject:kCSProviderSearchKey];
        self.contactDictionary = [NSDictionary dictionaryWithObject:searchedArray forKey:kCSProviderSearchKey];
        
    } else {
        self.contactIndex = self.originalContactIndex;
        self.contactDictionary = self.originalContactDictionary;
    }
    
    self.lastSearchText = text;
}

- (void)completeSearch {
    self.contactIndex = self.originalContactIndex;
    self.contactDictionary = self.originalContactDictionary;
}

@end
