//
//  NewVisitPage.m
//  CRMApp
//
//  Created by Gaurav on 22/11/14.
//  Copyright (c) 2014 Weird Logics. All rights reserved.
//

#import "NewVisitPage.h"

#import <Parse/Parse.h>

@interface NewVisitPage ()

@end

@implementation NewVisitPage

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    PFUser *user = [PFUser currentUser];
    NSLog(@"user: %@", user);
}

-(void) viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.backgroundColor = [UIColor darkGrayColor];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
