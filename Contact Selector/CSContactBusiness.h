//
//  CSContactBusiness.h
//  Contact Selector
//
//  Created by CPU11815 on 2/20/17.
//  Copyright © 2017 CPU11815. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CSDataBusiness.h"
#import "CSContact.h"

@interface CSContactBusiness : NSObject <CSDataBusiness>

@property (nonatomic) id<CSDataProvider> dataProvider;

- (void)searchForContactWithNumber:(NSString *)phoneNumber withCompletion:(void(^)(CSContact *))completion;

@end
