//
//  CallViewController.m
//  Contact Selector
//
//  Created by CPU11815 on 2/24/17.
//  Copyright © 2017 CPU11815. All rights reserved.
//

#import "CallViewController.h"
#import "CSCallHistoryManager.h"
#import "CallCell.h"
#import "CSContactProvider.h"

@interface CallViewController () <UITableViewDataSource, UITableViewDelegate>

@property (strong, nonatomic) CSContactProvider *contactProvider;

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIView *keypadView;

@property (weak, nonatomic) IBOutlet UITextField *inputNumber;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *diallerConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *inputConstraint;

@property (strong, nonatomic) NSArray<CSCall *> *calls;

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
    
    self.calls = [[CSCallHistoryManager manager] getAllCalls];
    self.inputNumber.userInteractionEnabled = NO;
    self.contactProvider = [CSContactProvider new];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)numberClick:(id)sender {
    
    [self showInputView];
    
    UIButton *btn = (UIButton *)sender;
    self.inputNumber.text = [self.inputNumber.text stringByAppendingString:btn.titleLabel.text];
}

- (IBAction)showDialler:(id)sender {
    
    [UIView animateWithDuration:0.1 animations:^{
        self.keypadView.transform = CGAffineTransformMakeScale(0.1, 0.1);
    }];
    
    self.diallerConstraint.constant = -34;
    [UIView animateWithDuration:0.5
                          delay:0
         usingSpringWithDamping:0.7
          initialSpringVelocity:0.7
                        options:UIViewAnimationOptionCurveEaseOut
                     animations:^{
                         [self.view layoutIfNeeded];
                     }
                     completion:nil
     ];
}

- (IBAction)hideDialler:(id)sender {
    
    self.diallerConstraint.constant = -350;
    [UIView animateWithDuration:0.2 animations:^{
        [self.view layoutIfNeeded];
    }];
    
    [UIView animateWithDuration:0.5 animations:^{
        self.keypadView.transform = CGAffineTransformMakeScale(1, 1);
    }];
}

- (IBAction)deleteNumber:(id)sender {
    
    NSString *textNumber = self.inputNumber.text;
    if (textNumber.length > 0) {
        self.inputNumber.text = [textNumber substringToIndex:[textNumber length] - 1];
    }
    
    if (self.inputNumber.text.length < 1) {
        [self hideInputView];
    }
}

- (IBAction)addNewContact:(id)sender {
    NSLog(@"Implement add a new contact");
}

- (void)showInputView {
    self.inputConstraint.constant = 0;
    [UIView animateWithDuration:0.2 animations:^{
        [self.view layoutIfNeeded];
    }];
}

- (void)hideInputView {
    self.inputConstraint.constant = -40;
    [UIView animateWithDuration:0.2 animations:^{
        [self.view layoutIfNeeded];
    }];
}


#pragma mark - Table View Datasource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.calls count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *indentifier = @"calledCell";
    
    CallCell *cell = [self.tableView dequeueReusableCellWithIdentifier:indentifier];
    
    [self.contactProvider getContactWithNumber:self.calls[indexPath.row].number withCompletion:^(CSModel *contact, NSError *err) {
        
        dispatch_async(dispatch_get_main_queue(), ^{
                cell.fullName.text = contact.fullName;
        });
    }];
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
    [dateFormatter setDateFormat:@"dd.MM.YYYY HH:mm:ss"];
    
    cell.subcription.text = [NSString stringWithFormat:@"↗ %@", [dateFormatter stringFromDate:_calls[indexPath.row].start]];
    
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
