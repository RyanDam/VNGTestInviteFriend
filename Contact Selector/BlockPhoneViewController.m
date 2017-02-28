//
//  AddBlockPhoneViewController.m
//  Contact Selector
//
//  Created by CPU11815 on 2/27/17.
//  Copyright © 2017 CPU11815. All rights reserved.
//

#import "BlockPhoneViewController.h"
#import "CSContact.h"
#import "BlockPhoneTableViewCell.h"

@interface BlockPhoneViewController () <UITableViewDelegate, UITableViewDataSource> {
    BOOL becameFirst;
}

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (nonatomic) CSContact * model;

@end

@implementation BlockPhoneViewController

+ (instancetype)viewController {
    
    UIStoryboard * storyboard = [UIStoryboard storyboardWithName:@"Block" bundle:nil];
    BlockPhoneViewController * vc = [storyboard instantiateViewControllerWithIdentifier:@"BlockPhoneViewController"];
    return vc;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"Block Number";
    becameFirst = YES;
    
    [self setupNavigation];
    self.model = [[CSContact alloc] init];
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.allowsSelection = NO;
}

- (void)setupNavigation {
    
    UIBarButtonItem * cancelButton = [[UIBarButtonItem alloc] initWithTitle:@"Cancel" style:UIBarButtonItemStylePlain target:self action:@selector(onCancel)];
    self.navigationItem.leftBarButtonItem = cancelButton;
    
    UIBarButtonItem * saveButton = [[UIBarButtonItem alloc] initWithTitle:@"Save" style:UIBarButtonItemStylePlain target:self action:@selector(onSave)];
    self.navigationItem.rightBarButtonItem = saveButton;
}

- (void)onCancel {
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(addBlockPhoneViewController:didAddModel:)]) {
        [self.view endEditing:YES];
        [self.delegate addBlockPhoneViewController:self didAddModel:nil];
    }
}

- (void)onSave {
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(addBlockPhoneViewController:didAddModel:)]) {
        NSUInteger lenght = self.model.phoneNumbers[0].length;
        if (lenght < 10 || lenght > 13) {
            [self showMessage:@"Please enter a valid phone number"];
        } else {
            NSString * replacedPlus = [self.model.phoneNumbers[0] stringByReplacingOccurrencesOfString:@"+" withString:@""];
            NSString * firstNumber = [replacedPlus substringWithRange:NSMakeRange(0, 1)];
            if ([firstNumber compare:@"0"] == NSOrderedSame) {
                replacedPlus = [NSString stringWithFormat:@"84%@", [replacedPlus substringFromIndex:1]];
            }
            self.model.phoneNumbers = @[replacedPlus];
            
            if (self.model.fullName.length == 0) {
                self.model.fullName = @"<No name>";
            }
            
            [self.view endEditing:YES];
            [self.delegate addBlockPhoneViewController:self didAddModel:self.model];
        }
    }
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    BlockPhoneTableViewCell * blockCell = (BlockPhoneTableViewCell *) cell;
    blockCell.model = self.model;
    if (indexPath.row == 0) {
        blockCell.cellState = BlockPhoneCellStateNumber;
        
        if (becameFirst) {
            [blockCell becomeFirstResponser];
            becameFirst = NO;
        }
        
    } else if (indexPath.row == 1) {
        blockCell.cellState = BlockPhoneCellStateName;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 54;
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 2;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    return [tableView dequeueReusableCellWithIdentifier:kBlockPhoneTableViewCellID];
}

#pragma mark - Utils

- (void)showMessage:(NSString *)message {
    
    UIAlertController * alert = [UIAlertController alertControllerWithTitle:@"Message"
                                                                    message:message
                                                             preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction * dismissAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDestructive handler:nil];
    [alert addAction:dismissAction];
    [self presentViewController:alert animated:YES completion:nil];
}

@end
