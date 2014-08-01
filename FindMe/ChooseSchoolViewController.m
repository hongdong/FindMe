#import "AFNetworking.h"
#import "ChooseSchoolViewController.h"
#import "ChooseDepartmentViewController.h"
#import "User.h"
@interface ChooseSchoolViewController (){
    NSArray *_deptArr;
}
@property(nonatomic, copy) NSString *currentSearchString;
@end

@implementation ChooseSchoolViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

    self.title = @"选择学校";
    
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
    NSString *path = [[NSBundle mainBundle] pathForResource:@"school" ofType:@"plist"];
    dataArray = [[NSArray alloc] initWithContentsOfFile:path];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self showHint:@"第一次登入，认真填写信息哦"];

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}
#pragma UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (tableView == self.searchDisplayController.searchResultsTableView) {
        return searchResults.count;
    }
    else {
        return dataArray.count;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = (UITableViewCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    if (tableView == self.searchDisplayController.searchResultsTableView) {
        cell.textLabel.text = [searchResults[indexPath.row] objectForKey:@"scName"];
        
    }
    else {
        cell.textLabel.text = [dataArray[indexPath.row] objectForKey:@"scName"];
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    cell.frame = CGRectMake(320, cell.frame.origin.y, cell.frame.size.width, cell.frame.size.height);
    [UIView animateWithDuration:0.7 animations:^{
        cell.frame = CGRectMake(0, cell.frame.origin.y, cell.frame.size.width, cell.frame.size.height);
    } completion:^(BOOL finished) {
        ;
    }];
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 44;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    [mySearchBar resignFirstResponder];
    NSString *selectedScNo;
    NSString *selectedScName;
    if (tableView == self.searchDisplayController.searchResultsTableView) {
        selectedScNo = [searchResults[indexPath.row] objectForKey:@"scNo"];
        selectedScName = [searchResults[indexPath.row] objectForKey:@"scName"];
    }
    else {
        selectedScNo = [dataArray[indexPath.row] objectForKey:@"scNo"];
        selectedScName = [dataArray[indexPath.row] objectForKey:@"scName"];
    }
    _user.school = [[NSMutableDictionary alloc] initWithDictionary:@{@"_id": selectedScNo,@"schoolName": selectedScName}];
    [HDTool showHUD:@"加载中..."];
    [self departmentList:selectedScNo];
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
        NSArray *personsToSearch = dataArray;
        if (self.currentSearchString.length > 0 && [searchString rangeOfString:self.currentSearchString].location == 0) { // If the new search string starts with the last search string, reuse the already filtered array so searching is faster
            personsToSearch = searchResults;
        }
        
        searchResults = [personsToSearch filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"scName contains[cd] %@", searchString]];
    } else {
        searchResults = dataArray;
    }
    
    self.currentSearchString = searchString;
    
    return YES;
}


#pragma mark - ASIHTTPRequest methods

- (void)departmentList:(NSString *) deptScNo
{
    NSString *urlStr = [NSString stringWithFormat:@"%@/data/school/dept_list.do?schoolId=%@",Host,deptScNo];
    __weak __typeof(&*self)weakSelf = self;
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager GET:urlStr parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if (responseObject&&[responseObject objectForKey:@"department"]) {
            [HDTool successHUD];
            _deptArr = [responseObject objectForKey:@"department"];
            [weakSelf performSegueWithIdentifier:@"chooseDepartment" sender:nil];
        }else{
            [HDTool errorHUD];
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [HDTool errorHUD];
    }];
}

#pragma mark -

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if([[segue identifier] isEqualToString:@"chooseDepartment"])
    {
        ChooseDepartmentViewController *controller=(ChooseDepartmentViewController *)(segue.destinationViewController);
        controller.user = _user;
        controller.dataArray = _deptArr;
    }
}

-(void)dealloc{
    _user = nil;
    _deptArr = nil;
}
@end
