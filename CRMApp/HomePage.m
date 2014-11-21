//
//  HomePage.m
//  CRMApp
//
//  Created by Gaurav on 22/11/14.
//  Copyright (c) 2014 Weird Logics. All rights reserved.
//

#import "HomePage.h"

#import <Parse/Parse.h>
#import "NewVisitPage.h"
#import "UITableView+NXEmptyView.h"

@interface HomePage ()<UITableViewDataSource, UITableViewDelegate>{
    
    IBOutlet UITableView *table;
    IBOutlet UILabel *label;
    
    NSArray *visits;
}

@end

@implementation HomePage

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    table.nxEV_hideSeparatorLinesWhenShowingEmptyView = YES;
}

-(void) viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    
    PFUser *user = [PFUser currentUser];
    if (!user) {
        label.text = @"Not yet signed in";
        [table reloadData];
        return;
    }
    NSString *name = [user[@"name"] componentsSeparatedByString:@" "][0];
    label.text = [NSString stringWithFormat:@"Hey %@", name];
    
    PFQuery *query = [PFQuery queryWithClassName:@"Visit"];
    [query whereKey:@"visitor" equalTo:user];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error){
        if (!error) {
            NSLog(@"visits found: %d", objects.count);
            visits = [NSArray arrayWithArray:objects];
        } else {
            // Log details of the failure
            NSLog(@"Error: %@ %@", error, [error userInfo]);
        }
    }];
    
    if (visits && visits.count) {
        table.hidden = NO;
        [table reloadData];
    }else{
//        table.hidden = YES;
        table.nxEV_emptyView = [[UIView alloc] init];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(UIView *) getEmptyView{
    return nil;
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

-(IBAction)newVisit:(id)sender{
    NSLog(@"new visit");
    
    NewVisitPage *page = [self.storyboard instantiateViewControllerWithIdentifier:@"NewVisitPage"];
    page.modalPresentationStyle = UIModalPresentationCurrentContext;
    page.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
//    page.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(dismissModal)];
    page.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(dismissModal)];
    page.navigationItem.title = @"New Visit?";

    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController: page];
    [self.navigationController presentViewController:nav animated:YES completion:^(void){
        NSLog(@"presented");
    }];
}

-(void) dismissModal{
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(int) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return visits ? visits.count : 0;
}

-(UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    PFObject *visit = [visits objectAtIndex:indexPath.row];
    PFObject *sale = [visit[@"sale"] fetchIfNeeded];
    PFObject *client;
    if (sale) {
        client = [sale[@"client"] fetchIfNeeded];
    }
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"VISIT_CELL"];
    if (cell) {
        if (client) {
            cell.textLabel.text = client[@"company"];
            cell.detailTextLabel.text = [NSString stringWithFormat:@"%@ [%@]", client[@"company"], client[@"mobile"]];
        }else{
            cell.textLabel.text = @"Unknown company";
            cell.detailTextLabel.text = @"Unknown contact person";
        }
    }
    
    return cell;
}

@end
