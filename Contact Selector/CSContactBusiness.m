//
//  CSContactBusiness.m
//  Contact Selector
//
//  Created by CPU11815 on 2/20/17.
//  Copyright © 2017 CPU11815. All rights reserved.
//

#import "CSContactBusiness.h"
#import "CSContact.h"
#import "CSContactProvider.h"

@interface CSContactBusiness ()

@property (nonatomic) dispatch_queue_t internalQueue;


@end

@implementation CSContactBusiness

static dispatch_queue_t internalQueue;
static id<CSDataProvider> currentProvider;

+ (id)instance {
    static CSContactBusiness *currentInstance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        currentInstance = [CSContactBusiness new];
        internalQueue = dispatch_queue_create("com.vng.ContactSelector.CSContactBusiness", DISPATCH_QUEUE_CONCURRENT);
        currentProvider = [CSContactProvider instance];
    });
    return currentInstance;
}

+ (id)instanceWithProvider:(id<CSDataProvider>)provider {
    if (provider != nil) {
        currentProvider = provider;
    }
    return [CSContactBusiness instance];
}

- (void)getDataIndexFromDataArray:(CSDataArray *) dataArray dispatchQueue:(dispatch_queue_t)queue withCompletion:(void (^)(CSDataIndex * index))completion {
    if (completion && dataArray) {
        dispatch_async(internalQueue, ^{
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
            
            if (queue) {
                dispatch_async(queue, ^{
                    completion(contactIndex);
                });
            } else {
                completion(contactIndex);
            }
        });
    }
}

- (void)getDataDictionaryFromDataArray:(CSDataArray *) dataArray dispatchQueue:(dispatch_queue_t)queue withCompletion:(void (^)(CSDataDictionary * dictionary))completion {
    if (completion && dataArray) {
        dispatch_async(internalQueue, ^{
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
            
            if (queue) {
                dispatch_async(queue, ^{
                    completion(contactDicionany);
                });
            } else {
                completion(contactDicionany);
            }
        });
    }
}

- (void)performSearch:(NSString *)text onDataArray:(CSDataArray *)dataArray dispatchQueue:(dispatch_queue_t)queue withCompletion:(SearchCompleteBlock)completion {
    
    if (text && dataArray && completion) {
        dispatch_async(internalQueue, ^{
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
                    if (queue) {
                        dispatch_async(queue, ^{
                            completion(CSSearchResultNoResult, nil, nil);
                        });
                    } else {
                        completion(CSSearchResultNoResult, nil, nil);
                    }
                } else {
                    if (queue) {
                        dispatch_async(queue, ^{
                            completion(CSSearchResultComplete, contactIndex, contactDictionary);
                        });
                    } else {
                        completion(CSSearchResultComplete, contactIndex, contactDictionary);
                    }
                }
                
            } else {
                [self getDataIndexFromDataArray:dataArray dispatchQueue:nil withCompletion:^(CSDataIndex *index) {
                    [self getDataDictionaryFromDataArray:dataArray dispatchQueue:nil withCompletion:^(CSDataDictionary *dictionary) {
                        if (queue) {
                            dispatch_async(queue, ^{
                                completion(CSSearchResultComplete, index, dictionary);
                            });
                        } else {
                            completion(CSSearchResultComplete, index, dictionary);
                        }
                    }];
                }];
            }
        });
    }
}

- (void)getDataIndexWithQueue:(dispatch_queue_t)queue withCompletion:(void (^)(CSDataIndex *))completion {
    
    [currentProvider getDataArrayWithCompletion:^(NSArray<CSModel *> *data, NSError *err) {
        [self getDataIndexFromDataArray:data dispatchQueue:queue withCompletion:completion];
    }];
}

- (void)getDataArrayWithCompletion:(void (^)(NSArray<CSModel *> *, NSError *))completion {
    [currentProvider getDataArrayWithCompletion:^(NSArray<CSModel *> *data, NSError *err) {
        completion(data, nil);
    }];
}

- (void)getDataDictionaryWithQueue:(dispatch_queue_t)queue withCompletion:(void (^)(CSDataDictionary *))completion {
    [currentProvider getDataArrayWithCompletion:^(NSArray<CSModel *> *data, NSError *err) {
        [self getDataDictionaryFromDataArray:data dispatchQueue:dispatch_get_main_queue() withCompletion:completion];
    }];
}

- (void)performSearch:(NSString *)text dispatchQueue:(dispatch_queue_t)queue withCompletion:(SearchCompleteBlock)completion {
    [currentProvider getDataArrayWithCompletion:^(NSArray<CSModel *> *data, NSError *err) {
        [self performSearch:text onDataArray:data dispatchQueue:dispatch_get_main_queue() withCompletion:completion];
    }];
}

- (void)searchForContactWithNumber:(NSString *)phoneNumber withCompletion:(void(^)(CSContact *))completion {
    if (completion) {
        [currentProvider getDataArrayWithCompletion:^(NSArray<CSModel *> *data, NSError *err) {
            CSContact *contact = [self searchForContactFromDataArray:data withNumber:phoneNumber];
            completion(contact);
        }];
    }
}

- (CSContact *)searchForContactFromDataArray:(CSDataArray *)dataArray withNumber:(NSString *)phoneNumber {

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
