//
//  CSContact.m
//  Contact Selector
//
//  Created by CPU11815 on 2/13/17.
//  Copyright © 2017 CPU11815. All rights reserved.
//

#import "CSContact.h"

@implementation CSContact

- (id)initWithCNContact:(CNContact *)contact {
    
    if ([super init]) {
        
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
  
        self.fullName = [fullName stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
        self.avatar = profileImage;
        self.emails = emails;
        self.phoneNumbers = phoneNumbers;
    };
    
    return self;
}

- (id)initWithABRecord:(ABRecordRef)record {
    
    if (self = [super init]) {
        NSString * fullName;
        NSString * firstName;
        NSString * lastName;
        NSMutableArray<NSString *> * phoneNumbers = [NSMutableArray array];
        NSMutableArray<NSString *> * emails = [NSMutableArray array];
        UIImage * profileImage;
        
        firstName = CFBridgingRelease(ABRecordCopyValue(record, kABPersonFirstNameProperty));
        lastName  = CFBridgingRelease(ABRecordCopyValue(record, kABPersonLastNameProperty));
        if (lastName == nil) {
            fullName=[NSString stringWithFormat:@"%@",firstName];
        } else if (firstName == nil) {
            fullName=[NSString stringWithFormat:@"%@",lastName];
        } else {
            fullName=[NSString stringWithFormat:@"%@ %@",firstName,lastName];
        }
        
        // get phone numbers
        ABMultiValueRef abPhoneNumbers = ABRecordCopyValue(record, kABPersonPhoneProperty);
        CFIndex numberOfPhoneNumbers = ABMultiValueGetCount(abPhoneNumbers);
        
        for (CFIndex i = 0; i < numberOfPhoneNumbers; i++) {
            NSString *phoneNumber = CFBridgingRelease(ABMultiValueCopyValueAtIndex(abPhoneNumbers, i));
            [phoneNumbers addObject:phoneNumber];
        }
        
        CFRelease(abPhoneNumbers);
        
        // get emails
        ABMultiValueRef abEmails = ABRecordCopyValue(record, kABPersonEmailProperty);
        CFIndex numberOfEmails = ABMultiValueGetCount(abEmails);
        
        for (CFIndex i = 0; i < numberOfEmails; i++) {
            NSString *email = CFBridgingRelease(ABMultiValueCopyValueAtIndex(abEmails, i));
            [emails addObject:email];
        }
        
        CFRelease(abEmails);
        
        // get image
        NSData  *imgData = (__bridge NSData *)ABPersonCopyImageData(record);
        if (imgData != nil)
            profileImage = [UIImage imageWithData:imgData];

        self.fullName = [fullName stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
        self.avatar = profileImage;
        self.emails = emails;
        self.phoneNumbers = phoneNumbers;
    }
    
    return self;
}


@end
