//
//  MainViewController.m
//  Yelp
//
//  Created by Timothy Lee on 3/21/14.
//  Copyright (c) 2014 codepath. All rights reserved.
//

#import "MainViewController.h"
#import "YelpClient.h"
#import "Business.h"
#import "BusinessCell.h"
#import "FilterViewController.h"

NSString * const kYelpConsumerKey = @"lz6iqbZA3As1WtPc5dUlMg";
NSString * const kYelpConsumerSecret = @"OTN1X7WzRffRVRnAcVAS3wymksM";
NSString * const kYelpToken = @"mi5LJ4utH37Tty_tFOD2sclLF1hNtOiU";
NSString * const kYelpTokenSecret = @"VTScNLImMtw_yM8ILLg36vbGpI0";

@interface MainViewController () <UITableViewDataSource, UITableViewDelegate, FilterViewControllerDelegate, UISearchBarDelegate>

@property (nonatomic, strong) YelpClient *client;
@property (nonatomic, strong) NSArray* businesses;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) BusinessCell * prototypeCell;
@property (nonatomic, strong) NSMutableDictionary* lastFilters;

@property (nonatomic, strong) UIActivityIndicatorView *loadingView;
@property (nonatomic, strong) UIRefreshControl* refreshControl;
@property BOOL isRequestActive;

-(void) fetchBusinessWithQuery:(NSString*)query params:(NSDictionary*)params;
@end

@implementation MainViewController

-(void) fetchBusinessWithQuery:(NSString*)query params:(NSDictionary*)params{
    [self.client searchWithTerm:query params:params success:^(AFHTTPRequestOperation *operation, id response) {
        NSLog(@"response: %@", response);
        NSArray* businssDictionaries = response[@"businesses"];
        self.businesses = [Business businessesWithDictinaries:businssDictionaries];
        //reload the table view once the data retreived
        [self.tableView reloadData];
        self.isRequestActive = TRUE;
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"error: %@", [error description]);
    }];
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // You can register for Yelp API keys here: http://www.yelp.com/developers/manage_api_keys
        self.client = [[YelpClient alloc] initWithConsumerKey:kYelpConsumerKey consumerSecret:kYelpConsumerSecret accessToken:kYelpToken accessSecret:kYelpTokenSecret];
        [self fetchBusinessWithQuery:@"Restaurants" params:nil];
        
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    
    //update the view controller about the castom cell
    [self.tableView registerNib:[UINib nibWithNibName:@"BusinessCell" bundle:nil] forCellReuseIdentifier:@"BusinessCell"];
    
    //dynamic raw cell high dimension
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    
    self.title = @"Yelp";
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Filters" style:UIBarButtonItemStylePlain target:self action:@selector(onFilterButton)];
    UISearchBar* usb = [[UISearchBar alloc]init];
    self.navigationItem.titleView = usb;
    usb.delegate = self;

    //adding ui refresh controller
    self.refreshControl = [[UIRefreshControl alloc] init];
    [self.refreshControl addTarget:self action:@selector(onRefresh) forControlEvents:UIControlEventValueChanged];
    [self.tableView insertSubview:self.refreshControl atIndex:0];
    self.isRequestActive = FALSE;
    UIView *tableFooterView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 50)];
    self.loadingView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    [self.loadingView startAnimating];
    self.loadingView.center = tableFooterView.center;
    [tableFooterView addSubview:self.loadingView];
    self.tableView.tableFooterView = tableFooterView;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.businesses.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    //we are in the last cell
    if (indexPath.row == self.businesses.count-1 && self.isRequestActive == FALSE) {
        [self fetchBusinessWithQuery:@"Restuerants" params:self.lastFilters];
        [self.loadingView stopAnimating];
        [self.tableView reloadData ];
        [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
        [self.tableView selectRowAtIndexPath:0 animated:YES
                              scrollPosition:UITableViewScrollPositionTop];
    }
    BusinessCell* cell = [tableView dequeueReusableCellWithIdentifier:@"BusinessCell"];
    cell.business = self.businesses[indexPath.row];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self.prototypeCell layoutIfNeeded];
    
    CGSize size = [self.prototypeCell.contentView systemLayoutSizeFittingSize:UILayoutFittingCompressedSize];
    return size.height+1;
}

#pragma mark - ui search bar delegate
- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar{
    NSString* query = searchBar.text;
    [self fetchBusinessWithQuery:query params:self.lastFilters];
    NSLog(@"Search clicked -> Fire new network query: %@\n filter:%@" ,query, self.lastFilters);
}

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar{
    NSString* query = @"Restuerants";
    [self fetchBusinessWithQuery:query params:self.lastFilters];
    NSLog(@"Search clicked -> Fire new network query: %@\n filter:%@" ,query, self.lastFilters);
}

- (void) onRefresh{
    NSString* query = @"Restuerants";
    [self fetchBusinessWithQuery:query params:self.lastFilters];
    [self.refreshControl endRefreshing];
    NSLog(@"Refresh clicked -> Fire new network query: Restaurants\n filter:%@" , self.lastFilters);
}

#pragma mark - filter delegate
- (void)filterViewController:(FilterViewController *)filterViewController didChangeFilters:(NSDictionary *)filters{
//    fire new network event
    [self fetchBusinessWithQuery:@"Restaurants" params:filters];
    NSLog(@"Fire new network event: %@" , filters);
    [self.lastFilters removeAllObjects];
    self.lastFilters = [filters mutableCopy];
}


#pragma mark - private method 

- (void) onFilterButton {
    FilterViewController* vc = [[FilterViewController alloc] init];
    vc.delegate = self;
    UINavigationController* nvc = [[UINavigationController alloc] initWithRootViewController:vc];
    [self presentViewController:nvc animated:YES completion:nil];
}

- (BusinessCell *)prototypeCell
{
    if (!_prototypeCell)
    {
        _prototypeCell = [self.tableView dequeueReusableCellWithIdentifier:@"BusinessCell"];
    }
    return _prototypeCell;
}

@end
