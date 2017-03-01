//
//  CSContactBusiness.m
//  Contact Selector
//
//  Created by CPU11815 on 2/20/17.
//  Copyright © 2017 CPU11815. All rights reserved.
//

#import "CSContactBusiness.h"
#import "CSContact.h"

@implementation CSContactBusiness

- (CSDataIndex *)getDataIndexFromDataArray:(CSDataArray *) dataArray {
    
    if (dataArray == nil) {
        return [NSArray array];
    }
    
    // sort all contact
    NSArray * sortedContact = [dataArray sortedArrayUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
        CSContact * currentContact = (CSContact *) obj1;
        CSContact * nextContact = (CSContact *) obj2;
        return [currentContact compareTo:nextContact];
    }];
    
    NSMutableArray * contactIndex = [NSMutableArray array];
    
    // Indexing contact into dictionary
    for (CSContact * contact in sortedContact) {
        NSString * currentFirstCharOfContactName = [[contact.fullName substringWithRange:NSMakeRange(0, 1)] uppercaseString];
        
        if (contactIndex.count == 0) { // create new section array and add first data
            [contactIndex addObject:currentFirstCharOfContactName];
        } else {
            NSString * currentLastIndex = (NSString *) contactIndex[contactIndex.count - 1];
            if ([currentFirstCharOfContactName localizedCaseInsensitiveCompare:currentLastIndex] != NSOrderedSame) {
                [contactIndex addObject:currentFirstCharOfContactName];
            }
        }
    }
    
    return contactIndex;
}

- (CSDataDictionary *)getDataDictionaryFromDataArray:(CSDataArray *) dataArray {
    
    if (dataArray == nil) {
        return [NSDictionary dictionary];
    }
    
    // sort all contact
    NSArray * sortedContact = [dataArray sortedArrayUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
        CSContact * currentContact = (CSContact *) obj1;
        CSContact * nextContact = (CSContact *) obj2;
        return [currentContact compareTo:nextContact];
    }];
    
    NSMutableArray * contactIndex = [NSMutableArray array];
    NSMutableDictionary * contactDicionany = [NSMutableDictionary dictionary];
    
    // Indexing contact into dictionary
    for (CSContact * contact in sortedContact) {
        NSString * currentFirstCharOfContactName = [[contact.fullName substringWithRange:NSMakeRange(0, 1)] uppercaseString];
        
        if (contactIndex.count == 0) { // create new section array and add first data
            [contactIndex addObject:currentFirstCharOfContactName];
            NSMutableArray * contactArray = [NSMutableArray arrayWithObject:contact];
            [contactDicionany setObject:contactArray forKey:currentFirstCharOfContactName];
        } else {
            NSString * currentLastIndex = (NSString *) contactIndex[contactIndex.count - 1];
            
            if ([currentFirstCharOfContactName localizedCaseInsensitiveCompare:currentLastIndex] != NSOrderedSame) { // create new section array and add first data
                [contactIndex addObject:currentFirstCharOfContactName];
                NSMutableArray * contactArray = [NSMutableArray arrayWithObject:contact];
                [contactDicionany setObject:contactArray forKey:currentFirstCharOfContactName];
            } else {
                NSMutableArray * contactArray = [contactDicionany objectForKey:currentLastIndex];
                [contactArray addObject:contact];
            }
        }
    }
    
    return contactDicionany;
}

- (void)performSearch:(NSString *)text onDataArray:(CSDataArray *)dataArray withCompletion:(SearchCompleteBlock)completion {
    
    if (dataArray == nil || completion == nil) {
        return;
    }
    
    if (text.length > 0) {
        NSMutableArray * searchedArray = [NSMutableArray array];
        NSArray * arrayToSearch = dataArray;
        
        for (CSContact * contact in arrayToSearch) {
            if ([contact.fullName.lowercaseString containsString:text.lowercaseString]) {
                [searchedArray addObject:contact];
            }
        }
        
        NSArray * contactIndex = [NSArray arrayWithObject:kCSProviderSearchKey];
        NSDictionary * contactDictionary = [NSDictionary dictionaryWithObject:searchedArray forKey:kCSProviderSearchKey];
        
        if (searchedArray.count == 0) {
            completion(CSSearchResultNoResult, nil, nil);
        } else {
            completion(CSSearchResultComplete, contactIndex, contactDictionary);
        }
        
    } else {
        
        NSArray * contactIndex = [self getDataIndexFromDataArray:dataArray];
        NSDictionary * contactDicionany = [self getDataDictionaryFromDataArray:dataArray];
        
        completion(CSSearchResultComplete, contactIndex, contactDicionany);
    }
}

- (CSModel *)searchForContactFromDataArray:(CSDataArray *)dataArray withNumber:(NSString *)phoneNumber {

    for (CSContact *contact in dataArray) {
        for (NSString* number in contact.phoneNumbers) {
            
            if ([number isEqualToString:phoneNumber]) {
                return contact;
            }
        }
    }
    return nil;
}

@end
