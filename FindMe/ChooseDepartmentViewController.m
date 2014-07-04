//
//  ChooseDepartmentViewController.m
//  FindMe
//
//  Created by mac on 14-4-28.
//  Copyright (c) 2014年 mac. All rights reserved.
//

#import "ChooseDepartmentViewController.h"
#import "ChooseGradeViewController.h"
@interface ChooseDepartmentViewController (){
    
}
@property(nonatomic, copy) NSString *currentSearchString;
@end

@implementation ChooseDepartmentViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.navigationController.navigationItem.title = @"院系";
    self.title = @"院系";
    mySearchBar = [[UISearchBar alloc]initWithFrame:CGRectMake(0, 0, 320, 40)];
    mySearchBar.delegate = self;
    [mySearchBar setPlaceholder:@"快速找到你的组织吧"];
    
    searchDisplayController = [[UISearchDisplayController alloc]initWithSearchBar:mySearchBar contentsController:self];
    searchDisplayController.active = NO;
    searchDisplayController.delegate = self;
    searchDisplayController.searchResultsDataSource = self;
    searchDisplayController.searchResultsDelegate = self;
    
    
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
	self.tableView.tableHeaderView = mySearchBar;

}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (tableView == self.searchDisplayController.searchResultsTableView) {
        return searchResults.count;
    }
    else {
        return _dataArray.count;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = (UITableViewCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    if (tableView == self.searchDisplayController.searchResultsTableView) {
        cell.textLabel.text = [searchResults[indexPath.row] objectForKey:@"deptName"];
        
    }
    else {
        cell.textLabel.text = [_dataArray[indexPath.row] objectForKey:@"deptName"];
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    [mySearchBar resignFirstResponder];
    NSString *selectedDeptNo;
    NSString *selectedDeptName;
    if (tableView == self.searchDisplayController.searchResultsTableView) {
        selectedDeptNo = [searchResults[indexPath.row] objectForKey:@"deptId"];
        selectedDeptName = [searchResults[indexPath.row] objectForKey:@"deptName"];
    }
    else {
        selectedDeptNo = [_dataArray[indexPath.row] objectForKey:@"deptId"];
        selectedDeptName = [_dataArray[indexPath.row] objectForKey:@"deptName"];
    }
    _user.userDeptNo = selectedDeptNo;
    _user.userDeptName = selectedDeptName;
    [self performSegueWithIdentifier:@"chooseGrade" sender:_user];
}
-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if([[segue identifier] isEqualToString:@"chooseGrade"])
    {
        
        ChooseGradeViewController *controller=(ChooseGradeViewController *)segue.destinationViewController;
        controller.user = _user;
    }
}
#pragma UISearchDisplayDelegate



- (void)searchDisplayControllerWillBeginSearch:(UISearchDisplayController *)controller
{
    searchResults = nil;
    self.currentSearchString = @"";
}

- (void)searchDisplayControllerDidEndSearch:(UISearchDisplayController *)controller
{
    searchResults = nil;
    self.currentSearchString = nil;
}

- (BOOL)searchDisplayController:(UISearchDisplayController *)controller shouldReloadTableForSearchString:(NSString *)searchString
{
    if (searchString.length > 0) { // Should always be the case
        NSArray *personsToSearch = _dataArray;
        if (self.currentSearchString.length > 0 && [searchString rangeOfString:self.currentSearchString].location == 0) { // If the new search string starts with the last search string, reuse the already filtered array so searching is faster
            personsToSearch = searchResults;
        }
        
        searchResults = [personsToSearch filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"deptName contains[cd] %@", searchString]];
    } else {
        searchResults = _dataArray;
    }
    
    self.currentSearchString = searchString;
    
    return YES;
}


@end
