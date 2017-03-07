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
#import "ContactSelectorViewController.h"

@import CallKit;

@interface MainTabBarController () <UITabBarControllerDelegate>

@property (nonatomic) CallViewController * callVC;
@property (nonatomic) ContactViewController * contactsVC;
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
    
    [self initViewControllers];
    
    [self needRefreshBlockPhoneExtention];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)initViewControllers {
    
    self.callVC = [CallViewController viewController];
    self.callVC.tabBarItem.title = @"Call";
    self.callVC.tabBarItem.image = [UIImage imageNamed:@"callIconNormal"];
    
    self.contactsVC = [ContactViewController viewController];
    UINavigationController * contactWrapper = [[UINavigationController alloc] initWithRootViewController:self.contactsVC];
    self.contactsVC.tabBarItem.title = @"Contacts";
    self.contactsVC.tabBarItem.image = [UIImage imageNamed:@"contactIconNormal"];
    
    self.blockVC = [BlockViewController viewController];
    UINavigationController * blockWrapper = [[UINavigationController alloc] initWithRootViewController:self.blockVC];
    self.blockVC.tabBarItem.title = @"Block";
    self.blockVC.tabBarItem.image = [UIImage imageNamed:@"blockIconNormal"];
    
    self.viewControllers = @[self.callVC, contactWrapper, blockWrapper];
    
    self.delegate = self;
}

- (void)needRefreshBlockPhoneExtention {
    CXCallDirectoryManager * manager = [CXCallDirectoryManager sharedInstance];
    
    NSString* appID = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleIdentifier"];
    NSString * callDirectionID = [appID stringByAppendingString:@".Contact-Selector-Block"];
    
    [manager getEnabledStatusForExtensionWithIdentifier:callDirectionID completionHandler:^(CXCallDirectoryEnabledStatus enabledStatus, NSError * _Nullable error) {
        
        if (error) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [self showMessage:error.localizedDescription];
            });
            return;
        }
        
        if (enabledStatus == CXCallDirectoryEnabledStatusDisabled || enabledStatus == CXCallDirectoryEnabledStatusUnknown) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [self showMessage:@"Please enable to block contact in \nSettings > Phone > Call Blocking & Identification > enable Contact Selector"];
            });
        } else {
            [manager reloadExtensionWithIdentifier:callDirectionID completionHandler:^(NSError * _Nullable error) {
                if (error) {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [self showMessage:error.localizedDescription];
                    });
                }
            }];
        }
    }];
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
