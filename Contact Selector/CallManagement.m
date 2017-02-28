//
//  CallManagement.m
//  Contact Selector
//
//  Created by CPU11815 on 2/28/17.
//  Copyright © 2017 CPU11815. All rights reserved.
//

#import "CallManagement.h"
#import "CSCallHistoryManager.h"

@implementation CallManagement

+ (instancetype)management {
    
    static CallManagement * instance = nil;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[CallManagement alloc] init];
    });
    
    return instance;
}

- (void)makePhoneCall:(NSString *)phone {
    
    CSCall *call = [CSCall new];
    call.number = phone;
    call.start = [NSDate date];
    call.end = [NSDate date];
    
    [[CSCallHistoryManager manager] addCall:call];
    
    NSString * cal = [NSString stringWithFormat:@"tel:%@", phone];
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:cal]];
}

- (void)makeMessage:(NSString *)phone {
    
}

@end
