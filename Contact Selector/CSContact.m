//
//  CSContact.m
//  Contact Selector
//
//  Created by CPU11815 on 2/13/17.
//  Copyright © 2017 CPU11815. All rights reserved.
//

#import "CSContact.h"

@implementation CSContact

@synthesize fullname = _fullname;

- (void) setFullname:(NSString *)newFullname {
    
    // check and init short name
    if (newFullname != nil) {
        if (newFullname.length > 0) {
            NSArray<NSString *> * separateString = [newFullname componentsSeparatedByString:@" "];
            
            if (separateString.count > 1) {
                NSString * firstName = separateString[0];
                NSString * lastName = separateString[separateString.count - 1];
                
                self.shortName = @"";
                if (firstName.length > 0) {
                    self.shortName = [self.shortName stringByAppendingString:[firstName substringWithRange:NSMakeRange(0, 1)]];
                }
                if (lastName.length > 0) {
                    self.shortName = [self.shortName stringByAppendingString:[lastName substringWithRange:NSMakeRange(0, 1)]];
                }
            } else {
                self.shortName = [newFullname substringWithRange:NSMakeRange(0, 2)].uppercaseString;
            }
        } else {
            self.shortName = @"";
        }
    } else {
        self.shortName = nil;
    }
    
    _fullname = newFullname;
}

@end
