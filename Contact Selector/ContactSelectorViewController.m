//
//  ViewController.m
//  Contact Selector
//
//  Created by CPU11815 on 2/13/17.
//  Copyright © 2017 CPU11815. All rights reserved.
//

#import "ContactSelectorViewController.h"
#import "CSProviderDelegate.h"
#import "CSContactProvider.h"
#import "CSContact.h"
#import "CSContactTableViewCell.h"
#import "CSSelectedContactCollectionViewCell.h"

@interface ContactSelectorViewController () <UITableViewDelegate, UITableViewDataSource, UICollectionViewDelegate, UICollectionViewDataSource, UISearchBarDelegate>

@property (weak, nonatomic) IBOutlet UITableView *friendTableView;
@property (weak, nonatomic) IBOutlet UICollectionView *friendChoosedCollectionView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *friendChoosedcollectionHeightConstraint;
@property (weak, nonatomic) IBOutlet UISearchBar *searchBarView;

@property (nonatomic) UIView * headerTitleView;
@property (nonatomic) UILabel * headerTitleLabel;
@property (nonatomic) UILabel * headerCountingLabel;

@property (nonatomic) NSMutableArray * selectedContacts;
@property (nonatomic) id <CSProviderDelegate> dataProvider;

@property (nonatomic) NSUInteger maxSelectedContact;
@property (nonatomic) NSUInteger defaultFriendChoosedCollectionHeight;

@end

@implementation ContactSelectorViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.maxSelectedContact = 10;
    self.selectedContacts = [NSMutableArray array];
    self.dataProvider = (id <CSProviderDelegate>)[[CSContactProvider alloc] init];
    [self initFriendTableView];
    [self initFriendCollectionView];
    [self initHeaderTitleView];
    [self initSearchBar];
    
    [self setHeaderTitle:@"Choose Friend"];
    [self setCoutingValue:0 animate:NO];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)viewWillLayoutSubviews {
    [super viewWillLayoutSubviews];
    
    // Without this, the collection view will crash when show and hide itself with message: attribute for indexPath not exist
    [self.friendChoosedCollectionView.collectionViewLayout invalidateLayout];
}

#pragma mark - Init views

- (void)initHeaderTitleView {
    
    self.headerTitleView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 200, self.navigationController.navigationBar.frame.size.height)];
    self.headerTitleView.backgroundColor = [UIColor clearColor];
    
    self.headerTitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.headerTitleView.frame.size.width, 0.4*self.headerTitleView.frame.size.height)];
    self.headerTitleLabel.textColor = [UIColor blackColor];
    self.headerTitleLabel.font = [UIFont systemFontOfSize:16];
    self.headerTitleLabel.textAlignment = NSTextAlignmentCenter;
    [self.headerTitleView addSubview:self.headerTitleLabel];
    
    self.headerCountingLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0.4*self.headerTitleView.frame.size.height, self.headerTitleView.frame.size.width, 18.0)];
    self.headerCountingLabel.textColor = [UIColor blackColor];
    self.headerCountingLabel.font = [UIFont systemFontOfSize:12];
    self.headerCountingLabel.textAlignment = NSTextAlignmentCenter;
    [self.headerTitleView addSubview:self.headerCountingLabel];
    
    self.navigationItem.titleView = self.headerTitleView;
}

- (void)initSearchBar {
    
    self.searchBarView.backgroundImage = [[UIImage alloc] init];
    self.searchBarView.delegate = self;
}

- (void)initFriendCollectionView {
    
    self.friendChoosedCollectionView.dataSource = self;
    self.friendChoosedCollectionView.delegate = self;
    self.defaultFriendChoosedCollectionHeight = 58;
    self.friendChoosedcollectionHeightConstraint.constant = 0;
    self.friendChoosedCollectionView.showsHorizontalScrollIndicator = NO;
    self.friendChoosedCollectionView.bounces = YES;
    self.friendChoosedCollectionView.prefetchingEnabled = NO;
}

- (void)initFriendTableView {
    
    self.friendTableView.dataSource = self;
    self.friendTableView.delegate = self;
    self.friendTableView.separatorColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.05];
    self.friendTableView.sectionIndexBackgroundColor = [UIColor clearColor];
}

- (void)setHeaderTitle:(NSString *)title {
    
    self.headerTitleLabel.text = title;
}

- (void)setCoutingValue:(NSUInteger)num animate:(BOOL)animated{
    
    self.headerCountingLabel.text = [NSString stringWithFormat:@"%ld/%ld", num, self.maxSelectedContact];
    
    if (animated) {
        [UIView animateWithDuration:0.2 animations:^{
            self.headerCountingLabel.transform = CGAffineTransformMakeScale(1.3, 1.3);
        } completion:^(BOOL finished) {
            [UIView animateWithDuration:0.2 animations:^{
                self.headerCountingLabel.transform = CGAffineTransformMakeScale(1.0, 1.0);
            } completion:^(BOOL finished) {
                
            }];
        }];
    }
}

#pragma mark - UISearchBarDelegate

- (BOOL)searchBarShouldBeginEditing:(UISearchBar *)searchBar {
    
    [self.dataProvider prepareForSearch];
    return YES;
}

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText {
    
    [self.dataProvider performSearchText:searchText];
    [self.friendTableView reloadData];
}

- (void)forceEndSearch {
    
    [self.dataProvider completeSearch];
//    [self.searchBarView endEditing:YES];
    [self.searchBarView setText:@""];
    [self.friendTableView reloadData];
}

#pragma mark - Select contact logic

- (void)didSelectContact:(CSContact *)contact {
    
    if (self.selectedContacts.count == 0) {
        [self.friendChoosedCollectionView.collectionViewLayout invalidateLayout];
        self.friendChoosedcollectionHeightConstraint.constant = self.defaultFriendChoosedCollectionHeight;
        [UIView animateWithDuration:0.13 animations:^{
            
            [self.view layoutIfNeeded];
            
        } completion:^(BOOL finished) {
            
            [self.selectedContacts addObject:contact];
            [self.friendChoosedCollectionView reloadData];
            
            [self setCoutingValue:self.selectedContacts.count animate:YES];
        }];
    } else {
        [self.friendChoosedCollectionView performBatchUpdates:^{
            
            [self.selectedContacts addObject:contact];
            NSUInteger index = [self.selectedContacts indexOfObject:contact];
            NSIndexPath * indexPath = [NSIndexPath indexPathForRow:index inSection:0];
            
            [self.friendChoosedCollectionView insertItemsAtIndexPaths:@[indexPath]];
            
        } completion:^(BOOL finished) {
            
            [self.friendChoosedCollectionView.collectionViewLayout invalidateLayout];
            [self.friendChoosedCollectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForRow:self.selectedContacts.count - 1 inSection:0]
                                                     atScrollPosition:UICollectionViewScrollPositionNone animated:YES];
            [self setCoutingValue:self.selectedContacts.count animate:YES];
        }];
        
        
    }
    
    [self forceEndSearch];
}

- (void)didDeselectContact:(CSContact *)contact {
    
    if (self.selectedContacts.count == 1) {
        self.friendChoosedcollectionHeightConstraint.constant = 0;
        [UIView animateWithDuration:0.13 animations:^{
            [self.view layoutIfNeeded];
        } completion:nil];
    }
    
    [self.friendChoosedCollectionView performBatchUpdates:^{
        
        NSUInteger index = [self.selectedContacts indexOfObject:contact];
        [self.selectedContacts removeObject:contact];
        NSIndexPath * indexPath = [NSIndexPath indexPathForRow:index inSection:0];
        
        [self.friendChoosedCollectionView deleteItemsAtIndexPaths:@[indexPath]];
        
    } completion:^(BOOL finished) {
        
        [self.friendChoosedCollectionView.collectionViewLayout invalidateLayout];
        [self setCoutingValue:self.selectedContacts.count animate:YES];
        
    }];
    
    [self forceEndSearch];
}

#pragma mark - UICollectionViewDelegate

- (void)collectionView:(UICollectionView *)collectionView willDisplayCell:(UICollectionViewCell *)cell forItemAtIndexPath:(NSIndexPath *)indexPath {
    
    CSContact * contact = self.selectedContacts[indexPath.row];
    CSSelectedContactCollectionViewCell * csCell = (CSSelectedContactCollectionViewCell *) cell;
    [csCell setContact:contact];
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {

    [self forceEndSearch];
    
    CSSelectedContactCollectionViewCell * csCell = (CSSelectedContactCollectionViewCell *) [collectionView cellForItemAtIndexPath:indexPath];
    [csCell toggleHighlight];
    
    CSContact * contact = self.selectedContacts[indexPath.row];
    NSIndexPath * tableIndexPath = [self getIndexPathOfFriendTableForContact:contact];
    
    [self.friendTableView selectRowAtIndexPath:tableIndexPath animated:YES scrollPosition:UITableViewScrollPositionTop];
}

- (void)collectionView:(UICollectionView *)collectionView didDeselectItemAtIndexPath:(NSIndexPath *)indexPath {
    
    CSSelectedContactCollectionViewCell * csCell = (CSSelectedContactCollectionViewCell *) [collectionView cellForItemAtIndexPath:indexPath];
    [csCell setHighlight:NO];
}

#pragma mark - UICollectionViewDataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    
    return self.selectedContacts.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    UICollectionViewCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:kCSSelectedContactCollectionViewCellID forIndexPath:indexPath];
    return cell;
}

#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return 64;
}

- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForHeaderInSection:(NSInteger)section {
    
    NSString * sectionKey = [self.dataProvider getContactIndex][section];
    if ([sectionKey compare:kCSProviderSearchKey] == NSOrderedSame) {
        return 0;
    }
    return 24;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    
    NSString * sectionKey = [self.dataProvider getContactIndex][section];
    if ([sectionKey compare:kCSProviderSearchKey] == NSOrderedSame) {
        return 0;
    }
    return 1;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    CSContactTableViewCell * contactCell = (CSContactTableViewCell *) cell;
    CSContact * contact = [self getContactAtIndexPath:indexPath];
    contactCell.contact = contact;
    
    // Override this view for customize selection highligh color for cell
    UIView *myBackView = [[UIView alloc] initWithFrame:cell.frame];
    myBackView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.05];
    cell.selectedBackgroundView = myBackView;
    
    if ([self.selectedContacts containsObject:contact]) {
        [contactCell setSelect:YES];
    } else {
        [contactCell setSelect:NO];
    }
    
    // hide seperator when this cell is the last cell in section
    if (indexPath.row == [self tableView:tableView numberOfRowsInSection:indexPath.section] - 1) {
        [contactCell hideSeperator];
    } else {
        [contactCell showSeperator];
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
    // No need section view when user is searching
    NSString * sectionKey = [self.dataProvider getContactIndex][section];
    if ([sectionKey compare:kCSProviderSearchKey] == NSOrderedSame) {
        return nil;
    }
    
    UIView * headerView = [[UIView alloc] initWithFrame:CGRectMake(16, 0, tableView.frame.size.width, 24)];
    headerView.backgroundColor = [UIColor colorWithWhite:1.0 alpha:0.9];
    
    UILabel * headerKeyLabel = [[UILabel alloc] initWithFrame:headerView.frame];
    UIFont * headerFont = [UIFont boldSystemFontOfSize:12];
    headerKeyLabel.font = headerFont;
    headerKeyLabel.text = sectionKey;
    headerKeyLabel.textColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.5];
    
    [headerView addSubview:headerKeyLabel];
    
    return headerView;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    
    // No need footer view when user is searching
    NSString * sectionKey = [self.dataProvider getContactIndex][section];
    if ([sectionKey compare:kCSProviderSearchKey] == NSOrderedSame) {
        return nil;
    }
    
    UIView * dividerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.frame.size.width, 1)];
    dividerView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.05];
    return dividerView;
}

- (NSIndexPath *)tableView:(UITableView *)tableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (self.selectedContacts.count < self.maxSelectedContact) {
        return indexPath;
    } else {
        CSContact * selectedContact = [self getContactAtIndexPath:indexPath];
        if ([self.selectedContacts containsObject:selectedContact]) {
            return indexPath; // case: deselect cell when maximum selected contact reached
        }
        [self showMessage:[NSString stringWithFormat:@"You may select %ld friends at maximum", self.maxSelectedContact]];
        return nil;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:NO];

    CSContact * selectedContact = [self getContactAtIndexPath:indexPath];
    CSContactTableViewCell * cell = [tableView cellForRowAtIndexPath:indexPath];
    
    if ([self.selectedContacts containsObject:selectedContact]) {
        [self didDeselectContact:selectedContact];
        [cell setSelect:NO];
    } else {
        [self didSelectContact:selectedContact];
        [cell setSelect:YES];
    }
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return [[self.dataProvider getContactIndex] count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    NSString * sectionKey = [self.dataProvider getContactIndex][section];
    return [[[self.dataProvider getContactDictionary] objectForKey:sectionKey] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath; {
    
    return [tableView dequeueReusableCellWithIdentifier:kCSContactTableViewCellID];
}

- (NSArray<NSString *> *)sectionIndexTitlesForTableView:(UITableView *)tableView {
    NSString * firstSectionKey = [self.dataProvider getContactIndex][0];
    if ([firstSectionKey compare:kCSProviderSearchKey] == NSOrderedSame) {
        return nil;
    }
    NSString * searchIcon = UITableViewIndexSearch;
    NSString * hastagIcon = @"#";
    NSArray * indexWithIcon = [[@[searchIcon] arrayByAddingObjectsFromArray:[self.dataProvider getContactIndex]] arrayByAddingObject:hastagIcon];
    
    return indexWithIcon;
}

- (NSInteger)tableView:(UITableView *)tableView sectionForSectionIndexTitle:(NSString *)title atIndex:(NSInteger)index {
    
    if (index == 0) return 0; // search icon
    else if (index == [self.dataProvider getContactIndex].count + 2 - 1) return index - 2; // hastag icon
    else return index - 1; // normal index
}

#pragma mark - UIScrollViewDelegate

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    
    [self.searchBarView endEditing:YES];
}

#pragma mark - Utils

- (CSContact *)getContactAtIndexPath: (NSIndexPath *)indexPath {
    
    NSString * sectionKey = [self.dataProvider getContactIndex][[indexPath section]];
    NSArray * contactListOfKey = [[self.dataProvider getContactDictionary] objectForKey:sectionKey];
    CSContact * contact = contactListOfKey[indexPath.row];
    return contact;
}

- (NSIndexPath *)getIndexPathOfFriendTableForContact:(CSContact *)contact {
    
    NSString * sectionKey = [contact.fullname substringWithRange:NSMakeRange(0, 1)].uppercaseString;
    NSUInteger section = [[self.dataProvider getContactIndex] indexOfObject:sectionKey];
    
    NSArray * contactList = [[self.dataProvider getContactDictionary] objectForKey:sectionKey];
    NSUInteger row = [contactList indexOfObject:contact];
    
    return [NSIndexPath indexPathForRow:row inSection:section];
}

- (void)showMessage:(NSString *)message {
    
    UIAlertController * alert = [UIAlertController alertControllerWithTitle:@"Message"
                                                                    message:message
                                                             preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction * dismissAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDestructive handler:nil];
    [alert addAction:dismissAction];
    [dismissAction setValue:[UIColor blueColor] forKey:@"titleTextColor"];
    
    [self presentViewController:alert animated:YES completion:nil];
}

- (void)printSelectedContacts {
    
    for (CSContact * contact in self.selectedContacts) {
        NSLog(@"%@", contact.fullname);
    }
}

- (void)printIndexPath:(NSIndexPath *)index {
    
    NSLog(@"Section %ld row %ld", (long)index.section, (long)index.row);
}

@end
