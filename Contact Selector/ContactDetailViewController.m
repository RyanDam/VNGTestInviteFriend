//
//  ContactDetailViewController.m
//  Contact Selector
//
//  Created by CPU11815 on 2/27/17.
//  Copyright © 2017 CPU11815. All rights reserved.
//

#import "ContactDetailViewController.h"
#import "CSContact.h"
#import "TopContactDetailCell.h"
#import "CSBlockDatebaseManager.h"
#import "CallManagement.h"
#import <MessageUI/MessageUI.h>

NSString * kTopDetailCellID = @"TopContactDetailCell";
NSString * kCallContactCellID = @"CallContactID";
NSString * kMessageCellID = @"SendMessageID";
NSString * kBlockCellID = @"BlockContactID";
NSString * kUnBlockCellID = @"UnblockContactID";

@interface ContactDetailViewController () <UITableViewDelegate, UITableViewDataSource, MFMessageComposeViewControllerDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation ContactDetailViewController

+ (instancetype)viewController {
    UIStoryboard * storyboard = [UIStoryboard storyboardWithName:@"ContactDetail" bundle:nil];
    ContactDetailViewController * vc = [storyboard instantiateViewControllerWithIdentifier:@"ContactDetailViewController"];
    return vc;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
    self.navigationItem.title = self.contact.fullName;
}

- (void)callContact {
    
    if ([self isContactHavePhone]) {
        [[CallManagement management] makePhoneCall:self.contact.phoneNumbers[0]];
    } else {
        [self showMessage:@"This contact does not have a phone number"];
    }
}

- (void)messageContact {
    
    if ([self isContactHavePhone]) {
        MFMessageComposeViewController* composeVC = [[MFMessageComposeViewController alloc] init];
        composeVC.messageComposeDelegate = self;
        
        // Configure the fields of the interface.
        composeVC.recipients = @[self.contact.phoneNumbers[0]];
        composeVC.body = @"";
        
        // Present the view controller modally.
        [self presentViewController:composeVC animated:YES completion:nil];
    } else {
        [self showMessage:@"This contact does not have a phone number"];
    }
}

- (void)blockContact {
    
    if ([self isContactHavePhone]) {
        CSBlockDatebaseManager * manager = [CSBlockDatebaseManager manager];
        [manager blockContact:self.contact];
        [self.tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:3 inSection:0]] withRowAnimation:UITableViewRowAnimationFade];
    } else {
        [self showMessage:@"This contact does not have a phone number"];
    }
}

- (void)unBlockContact {
    
    CSBlockDatebaseManager * manager = [CSBlockDatebaseManager manager];
    [manager unblockContact:self.contact];
    [self.tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:3 inSection:0]] withRowAnimation:UITableViewRowAnimationFade];
}

#pragma mark - MFMessageComposeViewControllerDelegate

- (void)messageComposeViewController:(MFMessageComposeViewController *)controller didFinishWithResult:(MessageComposeResult)result {
    // nothing
    [controller dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    switch (indexPath.row) {
        case 0: {
            TopContactDetailCell * c = (TopContactDetailCell *) cell;
            c.model = self.contact;
            break;
        }
        default:
            // Nothing
            break;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    switch (indexPath.row) {
        case 0:
            return [TopContactDetailCell getHeight];
            break;
        case 1:
        case 2:
        case 3:
        default:
            return 52;
            break;
    }
}

- (nullable NSIndexPath *)tableView:(UITableView *)tableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    switch (indexPath.row) {
        case 0:
            // don't select first cell
            return nil;
        case 1:
            [self callContact];
        case 2:
            [self messageContact];
            break;
        case 3: {
            if ([self isContactBlocked]) {
                [self unBlockContact];
            } else {
                [self blockContact];
            }
            break;
        }
        default:
            return nil;
    }
    return nil;
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return 4;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    switch (indexPath.row) {
        case 0:
            return [tableView dequeueReusableCellWithIdentifier:kTopDetailCellID];
            break;
        case 1:
            return [tableView dequeueReusableCellWithIdentifier:kCallContactCellID];
            break;
        case 2:
            return [tableView dequeueReusableCellWithIdentifier:kMessageCellID];
            break;
        case 3:
        default:
            if ([self isContactBlocked]) {
                return [tableView dequeueReusableCellWithIdentifier:kUnBlockCellID];
            } else {
                return [tableView dequeueReusableCellWithIdentifier:kBlockCellID];
            }
            break;
    }
}

#pragma mark - Utils

- (BOOL)isContactBlocked {
    
    if ([self isContactHavePhone]) {
        CSBlockDatebaseManager * manager = [CSBlockDatebaseManager manager];
        NSString * phone = self.contact.phoneNumbers[0];
        return [manager checkIfPhoneBlocked:phone];
    }
    return NO;
}

- (BOOL)isContactHavePhone {
    
    return self.contact.phoneNumbers.count > 0;
}

- (void)showMessage:(NSString *)message {
    
    UIAlertController * alert = [UIAlertController alertControllerWithTitle:@"Message"
                                                                    message:message
                                                             preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction * dismissAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDestructive handler:nil];
    [alert addAction:dismissAction];
    [self presentViewController:alert animated:YES completion:nil];
}

@end
