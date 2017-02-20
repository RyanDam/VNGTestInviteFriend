//
//  CSContactBusiness.h
//  Contact Selector
//
//  Created by CPU11815 on 2/20/17.
//  Copyright © 2017 CPU11815. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CSDataBusiness.h"

@interface CSContactBusiness : NSObject <CSDataBusiness>

- (CSDataIndex *)getDataIndexFromDataArray:(CSDataArray *) dataArray;

- (CSDataDictionary *)getDataDictionaryFromDataArray:(CSDataArray *) dataArray;

- (void)performSearch:(NSString *)text onDataArray:(CSDataArray *)dataArray withCompletion:(SearchCompleteBlock)completion;

@end
