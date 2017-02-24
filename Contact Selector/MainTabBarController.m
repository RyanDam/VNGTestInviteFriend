//
//  MainTabBarController.m
//  Contact Selector
//
//  Created by CPU11815 on 2/24/17.
//  Copyright © 2017 CPU11815. All rights reserved.
//

#import "MainTabBarController.h"
#import "ContactViewController.h"
#import "CallViewController.h"
#import "BlockViewController.h"
#import "CSPresenterViewController.h"

#import "CSContactProvider.h"
#import "CSContactBusiness.h"
#import "CSDataProvider.h"
#import "CSDataBusiness.h"

@interface MainTabBarController () <UITabBarControllerDelegate, CSViewControllerDelegate, CSViewControllerDataSource>

@property (nonatomic) id<CSDataBusiness> contactBusiness;
@property (nonatomic) id<CSDataProvider> contactProvider;

@property (nonatomic) CallViewController * callVC;
@property (nonatomic) CSPresenterViewController * contactsVC;
@property (nonatomic) BlockViewController * blockVC;

@end

@implementation MainTabBarController

+ (instancetype)viewController {
    UIStoryboard * storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    MainTabBarController * vc = [storyboard instantiateViewControllerWithIdentifier:@"MainTabBarController"];
    [vc initViewControllers];
    return vc;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.contactBusiness = [[CSContactBusiness alloc] init];
    self.contactProvider = [[CSContactProvider alloc] init];
    
    [self initViewControllers];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)initViewControllers {
    
    self.callVC = [CallViewController viewController];
    self.callVC.tabBarItem.title = @"Call";
    self.callVC.tabBarItem.image = [UIImage imageNamed:@"callIconNormal"];
    
    self.contactsVC = [CSPresenterViewController presenter];
    self.contactsVC.tabBarItem.title = @"Contacts";
    self.contactsVC.tabBarItem.image = [UIImage imageNamed:@"contactIconNormal"];
    self.contactsVC.delegateCS = self;
    self.contactsVC.dataSourceCS = self;
    [self.contactsVC allowMutilSelection:NO];
    
    self.blockVC = [BlockViewController viewController];
    self.blockVC.tabBarItem.title = @"Block";
    self.blockVC.tabBarItem.image = [UIImage imageNamed:@"blockIconNormal"];
    
    self.viewControllers = @[self.callVC, self.contactsVC, self.blockVC];
    
    self.delegate = self;
}

#pragma mark - CSViewControllerDataSource

- (id<CSDataProvider>)dataProviderForContactSelector:(ContactSelectorViewController *)csViewController {
    
    return self.contactProvider;
}

- (id<CSDataBusiness>)dataBusinessForContactSelector:(ContactSelectorViewController *)csViewController {
    
    return self.contactBusiness;
}

#pragma mark - CSViewControllerDelegate

- (CSModel *)csViewController:(ContactSelectorViewController *)csViewController willSelectData:(CSModel *)data {
    
    NSLog(@"Choose %@", data.fullName);
    
    return data;
}

#pragma mark - UITabBarControllerDelegate

- (BOOL)tabBarController:(UITabBarController *)tabBarController shouldSelectViewController:(UIViewController *)viewController {
    
    for (UIViewController * vc in self.viewControllers) {
        [self refreshNormalIconForViewController:vc];
    }
    [self setSelectedIconForViewController:viewController];
    return YES;
}

- (NSUInteger)indexOfViewController:(UIViewController *)vc {
    
    return [self.viewControllers indexOfObject:vc];
}

- (void)refreshNormalIconForViewController:(UIViewController *)vc {
    NSUInteger index = [self indexOfViewController:vc];
    
    switch (index) {
        case 0:
            vc.tabBarItem.image = [UIImage imageNamed:@"callIconNormal"];
            break;
        case 1:
            vc.tabBarItem.image = [UIImage imageNamed:@"contactIconNormal"];
            break;
        case 2:
            vc.tabBarItem.image = [UIImage imageNamed:@"blockIconNormal"];
            break;
        default:
            break;
    }
}

- (void)setSelectedIconForViewController:(UIViewController *)vc {
    NSUInteger index = [self indexOfViewController:vc];
    
    switch (index) {
        case 0:
            vc.tabBarItem.image = [UIImage imageNamed:@"callIconSelected"];
            break;
        case 1:
            vc.tabBarItem.image = [UIImage imageNamed:@"contactIconSelected"];
            break;
        case 2:
            vc.tabBarItem.image = [UIImage imageNamed:@"blockIconSelected"];
            break;
        default:
            break;
    }
}

@end
