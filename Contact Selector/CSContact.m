//
//  CSContact.m
//  Contact Selector
//
//  Created by CPU11815 on 2/13/17.
//  Copyright © 2017 CPU11815. All rights reserved.
//

#import "CSContact.h"

@implementation CSContact

//@synthesize fullname = _fullname;
//
//- (void) setFullname:(NSString *)newFullname {
//    
//    // check and init short name
//    if (newFullname != nil) {
//        if (newFullname.length > 0) {
//            NSArray<NSString *> * separateString = [newFullname componentsSeparatedByString:@" "];
//            
//            if (separateString.count > 1) {
//                NSString * firstName = separateString[0];
//                NSString * lastName = separateString[separateString.count - 1];
//                
//                self.shortName = @"";
//                if (firstName.length > 0) {
//                    self.shortName = [self.shortName stringByAppendingString:[firstName substringWithRange:NSMakeRange(0, 1)]];
//                }
//                if (lastName.length > 0) {
//                    self.shortName = [self.shortName stringByAppendingString:[lastName substringWithRange:NSMakeRange(0, 1)]];
//                }
//            } else {
//                self.shortName = [newFullname substringWithRange:NSMakeRange(0, 2)].uppercaseString;
//            }
//        } else {
//            self.shortName = @"";
//        }
//    } else {
//        self.shortName = nil;
//    }
//    
//    _fullname = newFullname;
//}

- (id)initWithCNContact:(CNContact *)contact {
    return [super init];
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
