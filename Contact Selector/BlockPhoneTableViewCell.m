//
//  BlockPhoneTableViewCell.m
//  Contact Selector
//
//  Created by CPU11815 on 2/27/17.
//  Copyright © 2017 CPU11815. All rights reserved.
//

#import "BlockPhoneTableViewCell.h"
#import "CSContact.h"

NSString * kBlockPhoneTableViewCellID = @"BlockPhoneTableViewCellID";

@interface BlockPhoneTableViewCell() <UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UILabel *label;
@property (weak, nonatomic) IBOutlet UITextField *textInput;

@end

@implementation BlockPhoneTableViewCell

@synthesize cellState = _cellState;
@synthesize model = _model;

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.textInput.delegate = self;
}

- (void)setModel:(CSContact *)newModel {
    _model = newModel;
    
    if (self.cellState == BlockPhoneCellStateName) {
        [self.label setText:self.model.fullName];
    } else if (self.cellState == BlockPhoneCellStateNumber) {
        [self.label setText:self.model.phoneNumbers[0]];
    }
}

- (void)setCellState:(BlockPhoneCellState)newCellState {
    _cellState = newCellState;
    
    if (self.cellState == BlockPhoneCellStateName) {
        [self.label setText:@"Name"];
        self.textInput.keyboardType = UIKeyboardTypeDefault;
    } else if (self.cellState == BlockPhoneCellStateNumber) {
        [self.label setText:@"Number"];
        self.textInput.keyboardType = UIKeyboardTypePhonePad;
    }
}

- (void)becomeFirstResponser {
    [self.textInput becomeFirstResponder];
}

#pragma mark - UITextFieldDelegate

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    
    if (self.cellState == BlockPhoneCellStateName) {
        self.model.fullName = [textField.text stringByReplacingCharactersInRange:range withString:string];
    } else if (self.cellState == BlockPhoneCellStateNumber) {
        self.model.phoneNumbers = @[[textField.text stringByReplacingCharactersInRange:range withString:string]];
    }
    return YES;
}

@end
