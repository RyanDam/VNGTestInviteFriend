//
//  CallViewController.m
//  Contact Selector
//
//  Created by CPU11815 on 2/24/17.
//  Copyright © 2017 CPU11815. All rights reserved.
//

#import "CallViewController.h"

@interface CallViewController () <UITableViewDataSource, UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIView *diallerView;
@property (weak, nonatomic) IBOutlet UIView *keypadView;




@property (weak, nonatomic) IBOutlet UIButton *addContactButton;
@property (weak, nonatomic) IBOutlet UIButton *backspaceButton;
@property (weak, nonatomic) IBOutlet UITextField *inputNumber;
@property (weak, nonatomic) IBOutlet UIView *inputView;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *diallerConstraint;

@property (strong, nonatomic) NSArray *history;

@end

@implementation CallViewController

+ (instancetype)viewController {
    UIStoryboard * storyboard = [UIStoryboard storyboardWithName:@"Call" bundle:nil];
    CallViewController * vc = [storyboard instantiateViewControllerWithIdentifier:@"CallViewController"];
    return vc;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.tableView setDataSource:self];
    [self.tableView setDelegate:self];
    
    self.history = @[@1, @2, @3, @4, @5, @6];
    self.inputNumber.userInteractionEnabled = NO;
    
    //[self.diallerView setHidden:YES];
    //[self.inputView setHidden:YES];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)numberClick:(id)sender {
    
//    self.abc.constant = -300;
    
//    [UIView animateWithDuration:0.7 delay:0.0 usingSpringWithDamping:0.8 initialSpringVelocity:0.9 options:UIViewAnimationOptionCurveEaseOut animations:^{
//        [self.view layoutIfNeeded];
//    } completion:^(BOOL finished) {
//       //
//    }];
    
//    [UIView animateWithDuration:1.0 animations:^{
//        [self.view layoutIfNeeded];
//    }];
    
    
//    [UIView animateWithDuration:0.5 animations:^{
//        CGRect rect = self.inputView.frame;
//        self.inputView.frame = CGRectMake(rect.origin.x, rect.origin.y + rect.size.height, rect.size.width, rect.size.height);
//    }];
}

- (IBAction)showDialler:(id)sender {
    self.diallerConstraint.constant = 0;
    [UIView animateWithDuration:0.5 animations:^{
        [self.view layoutIfNeeded];
    }];
}

- (IBAction)hideDialler:(id)sender {
    self.diallerConstraint.constant = -400;
    [UIView animateWithDuration:0.5 animations:^{
        [self.view layoutIfNeeded];
    }];
}


#pragma mark - Table View Datasource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.history count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *indentifier = @"calledCell";
    
    UITableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:indentifier];
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 50;
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
