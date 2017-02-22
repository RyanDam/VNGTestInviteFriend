//
//  MainViewController.m
//  Contact Selector
//
//  Created by CPU11815 on 2/20/17.
//  Copyright © 2017 CPU11815. All rights reserved.
//

#import "MainViewController.h"
#import "ContactSelectorViewController.h"
#import "CSContactProvider.h"
#import "CSContactBusiness.h"
#import "CSPresenterViewController.h"
#import <FBSDKLoginKit/FBSDKLoginKit.h>

@interface MainViewController () <CSViewControllerDelegate, CSViewControllerDataSource, FBSDKLoginButtonDelegate>

@property (nonatomic) CSContactBusiness * contactBusiness;
@property (nonatomic) CSContactProvider * contactProvider;
@property (strong, nonatomic) IBOutlet FBSDKLoginButton *loginButton;

@end

@implementation MainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.contactBusiness = [[CSContactBusiness alloc] init];
    self.contactProvider = [[CSContactProvider alloc] init];
    
    self.loginButton = [[FBSDKLoginButton alloc] init];
    self.loginButton.center = self.view.center;
    self.loginButton.readPermissions = @[@"public_profile", @"email", @"user_friends"];
    [self.loginButton setDelegate:self];
    [self.view addSubview:self.loginButton];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (IBAction)onPressButton:(id)sender {
    
    CSPresenterViewController * vc = [CSPresenterViewController presenter];

    [vc setDelegateCS:self];
    [vc setDataSourceCS:self];
    
    [self presentViewController:vc animated:YES completion:nil];
}

#pragma mark - CSViewControllerDataSource

- (id<CSDataProvider>)dataProviderForContactSelector:(ContactSelectorViewController *)csViewController {
    
    return self.contactProvider;
}

- (id<CSDataBusiness>)dataBusinessForContactSelector:(ContactSelectorViewController *)csViewController {
    
    return self.contactBusiness;
}

#pragma mark - Facebook login button delegate

- (void)loginButtonDidLogOut:(FBSDKLoginButton *)loginButton {
    NSLog(@"User logged out");
}

- (void)loginButton:(FBSDKLoginButton *)loginButton didCompleteWithResult:(FBSDKLoginManagerLoginResult *)result error:(NSError *)error {
    
    if (error) {
        NSLog(@"%@", [error localizedDescription]);
        return;
    }
    
    CSPresenterViewController * vc = [CSPresenterViewController presenter];
    
    [vc setDelegateCS:self];
    [vc setDataSourceCS:self];
    
    [self presentViewController:vc animated:YES completion:nil];
}

@end
