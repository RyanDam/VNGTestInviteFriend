//
//  ContactViewController.m
//  Contact Selector
//
//  Created by CPU11815 on 2/24/17.
//  Copyright © 2017 CPU11815. All rights reserved.
//

#import "ContactViewController.h"
#import "ContactDetailViewController.h"
#import "CSContactProvider.h"
#import "CSContactBusiness.h"
#import "CSDataProvider.h"
#import "CSDataBusiness.h"
#import "CSContact.h"

#import <AddressBook/AddressBook.h>
#import <AddressBookUI/AddressBookUI.h>

@import Contacts;
@import ContactsUI;

#define SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(v)  ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedAscending)

@interface ContactViewController () <CSViewControllerDelegate, CNContactViewControllerDelegate, ABNewPersonViewControllerDelegate>

@property (weak, nonatomic) IBOutlet UIView *containerView;

@end

@implementation ContactViewController

+ (instancetype)viewController {
    return [[ContactViewController alloc] init];
}

- (void)viewDidLoad {
    self.allowMutilSelection = NO;
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self setupNavigation];
    self.dataBusiness = [[CSContactBusiness alloc] init];
    self.delegate = self;
    
    [self notifyDatasetChanged];
}

- (void)setupNavigation {
    self.navigationItem.title = @"Contact";
    
    UIBarButtonItem * plusButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(addNewContact)];
    self.navigationItem.rightBarButtonItem = plusButton;
}

- (void)addNewContact {
    
    if (SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"9.0")) {
        CNContactStore *store = [[CNContactStore alloc] init];
        CNContactViewController *controller = [CNContactViewController viewControllerForNewContact:nil];
        controller.contactStore = store;
        controller.delegate = self;
        
        UINavigationController * wrapper = [[UINavigationController alloc] initWithRootViewController:controller];
        [self presentViewController:wrapper animated:YES completion:nil];
    } else {
        ABNewPersonViewController * controller = [[ABNewPersonViewController alloc] init];
        controller.newPersonViewDelegate = self;
        
        UINavigationController * wrapper = [[UINavigationController alloc] initWithRootViewController:controller];
        [self presentViewController:wrapper animated:YES completion:nil];
    }
}

#pragma mark - ABNewPersonViewControllerDelegate

- (void)newPersonViewController:(ABNewPersonViewController *)newPersonView didCompleteWithNewPerson:(nullable ABRecordRef)person; {
    
    [newPersonView.navigationController dismissViewControllerAnimated:YES completion:nil];
    if (person) {
        [self notifyDatasetChanged];
    }
}

#pragma mark - CNContactViewControllerDelegate

- (void)contactViewController:(CNContactViewController *)viewController didCompleteWithContact:(nullable CNContact *)contact {
    
    [viewController.navigationController dismissViewControllerAnimated:YES completion:nil];
    if (contact) {
        [self notifyDatasetChanged];
    }
}

#pragma mark - CSViewControllerDelegate

- (CSModel *)csViewController:(ContactSelectorViewController *)csViewController willSelectData:(CSModel *)data {
    
    return data;
}

- (void)csViewController:(ContactSelectorViewController *)csViewController didSelectData:(CSModel *)data {
    
    CSContact * contact = (CSContact *) data;
    
    ContactDetailViewController * vc = [ContactDetailViewController viewController];
    vc.contact = contact;
    [self.navigationController pushViewController:vc animated:YES];
}

@end
