//
//  LoginPage.m
//  CRMApp
//
//  Created by Gaurav on 21/11/14.
//  Copyright (c) 2014 Weird Logics. All rights reserved.
//

#import "LoginPage.h"

#import <Parse/Parse.h>
#import "UIView+Toast.h"
#import "HomePage.h"

static NSString *KEY_U = @"USERNAME";

@interface LoginPage ()<UITextFieldDelegate>{
    
    IBOutlet UITextField *username;
    IBOutlet UITextField *password;
}

@end

@implementation LoginPage

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
//    UIView *paddingView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 40, 90)];
//    username.leftView = paddingView;
//    username.leftViewMode = UITextFieldViewModeAlways;
//    
//    UIView *paddingView2 = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 40, 90)];
//    password.leftView = paddingView2;
//    password.leftViewMode = UITextFieldViewModeAlways;
    
    NSString *x = [[NSUserDefaults standardUserDefaults] objectForKey:KEY_U];
    if (x) {
        username.text = x;
    }
    
    self.navigationController.navigationBar.hidden = YES;
}

-(void) viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    
    PFUser *user = [PFUser currentUser];
    if (user) {
        [PFUser logOut];
    }
    password.text = nil;
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

-(IBAction)login:(id)sender{
    
    [username resignFirstResponder];
    [password resignFirstResponder];
    
    NSString *u = username.text;
    NSString *p = password.text;

    if (!u || u.length==0) {
        [self.view makeToast:@"username missing" duration:1.5 position:CSToastPositionCenter title:@"Check"];
        return;
    }
    if (!p || p.length==0) {
        [self.view makeToast:@"password missing" duration:1.5 position:CSToastPositionCenter title:@"Check"];
        return;
    }
    
    [PFUser logInWithUsernameInBackground:u password:p block:^(PFUser *user, NSError *error) {
        if (user) {
            NSLog(@"user: %@", user);
            [self saveUsernameOnDisk];
            HomePage *page = [self.storyboard instantiateViewControllerWithIdentifier:@"HomePage"];
            [self.navigationController pushViewController:page animated:NO];
        }else{
            [self.view makeToast: [error.userInfo objectForKey:@"error"] duration:3.0 position:CSToastPositionCenter title:@"Error"];
        }
    }];
}

-(BOOL) textFieldShouldReturn:(UITextField *)textField{
    
    if (textField == username) {
        [password becomeFirstResponder];
    }else if (textField == password){
        [self login:nil];
    }
    return YES;
}

-(BOOL) textFieldShouldClear:(UITextField *)textField{
    if (textField == username) {
        password.text = nil;
    }
    return YES;
}

-(void) saveUsernameOnDisk{
    [[NSUserDefaults standardUserDefaults] setObject:username.text forKey:KEY_U];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

@end
