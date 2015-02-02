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
NSString * const kYelpToken = @"FBd_b3mgPy8J6EPiUZ8sCTJZ3L2kuYd6";
NSString * const kYelpTokenSecret = @"2DsOst3ttPyqM0fwRwNktnBYaWo";

@interface MainViewController () <UITableViewDataSource, UITableViewDelegate, FilterViewControllerDelegate>

@property (nonatomic, strong) YelpClient *client;
@property (nonatomic, strong) NSArray* businesses;
@property (weak, nonatomic) IBOutlet UITableView *tableView;

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
    BusinessCell* cell = [tableView dequeueReusableCellWithIdentifier:@"BusinessCell"];
    cell.business = self.businesses[indexPath.row];
    return cell;
}

#pragma mark - filter delegate
- (void)filterViewController:(FilterViewController *)filterViewController didChangeFilters:(NSDictionary *)filters{
//    fire new network event
    [self fetchBusinessWithQuery:@"Restaurants" params:filters];
    NSLog(@"Fire new network event: %@" , filters);
}


#pragma mark - private method 

- (void) onFilterButton {
    FilterViewController* vc = [[FilterViewController alloc] init];
    vc.delegate = self;
    UINavigationController* nvc = [[UINavigationController alloc] initWithRootViewController:vc];
    [self presentViewController:nvc animated:YES completion:nil];
}

@end
