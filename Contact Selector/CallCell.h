//
//  CallCell.h
//  Contact Selector
//
//  Created by CPU11808 on 2/28/17.
//  Copyright © 2017 CPU11815. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CSThumbnailView.h"

@interface CallCell : UITableViewCell

@property (weak, nonatomic) IBOutlet CSThumbnailView *thumnailView;
@property (weak, nonatomic) IBOutlet UILabel *fullName;
@property (weak, nonatomic) IBOutlet UILabel *subcription;

@end
