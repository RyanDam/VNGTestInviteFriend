//
//  CSModel.m
//  Contact Selector
//
//  Created by CPU11815 on 2/20/17.
//  Copyright © 2017 CPU11815. All rights reserved.
//

#import "CSModel.h"

@implementation CSModel

- (NSComparisonResult)compareTo:(CSModel *)other {
    
    if (other == nil) {
        return NSOrderedDescending;
    }
    
    if (self.fullName == nil) {
        if (other.fullName == nil) {
            return NSOrderedSame;
        } else {
            return NSOrderedAscending;
        }
    } else {
        if (other.fullName == nil) {
            return NSOrderedDescending;
        } else {
            return [self.fullName compare:other.fullName];
        }
    }
}

- (NSString *)shortName {
    // check and init short name
    if (self.fullName != nil) {
        if (self.fullName.length > 0) {
            NSArray<NSString *> * separateString = [self.fullName componentsSeparatedByString:@" "];
            
            if (separateString.count > 1) {
                NSString * firstName = separateString[0];
                NSString * lastName = separateString[separateString.count - 1];
                
                NSString * shortName = @"";
                if (firstName.length > 0) {
                    shortName = [shortName stringByAppendingString:[firstName substringWithRange:NSMakeRange(0, 1)]];
                }
                if (lastName.length > 0) {
                    shortName = [shortName stringByAppendingString:[lastName substringWithRange:NSMakeRange(0, 1)]];
                }
                
                return shortName;
            } else {
                return [self.fullName substringWithRange:NSMakeRange(0, 2)].uppercaseString;
            }
        } else {
            return @"";
        }
    } else {
        return nil;
    }
}

@end
