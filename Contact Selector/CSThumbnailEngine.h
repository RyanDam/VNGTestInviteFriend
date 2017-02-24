//
//  CSThumbnailEngine.h
//  Contact Selector
//
//  Created by CPU11815 on 2/24/17.
//  Copyright © 2017 CPU11815. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImageView (CSThumbnailEngine)

- (void)setThumbnailText:(NSString *)text withCompletion:(void (^)(UIImage * image))completion;

@end
