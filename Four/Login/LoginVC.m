//
//  LoginVC.m
//  Four
//
//  Created by Bohui Moon on 10/10/15.
//  Copyright © 2015 SCSC. All rights reserved.
//

#import "LoginVC.h"
#import "UIView+Border.h"
#import <Parse/Parse.h>


@interface LoginVC()

@property (nonatomic, strong) IBOutlet UILabel *messageLabel;
@property (nonatomic, strong) IBOutlet UITextField *usernameField;
@property (nonatomic, strong) IBOutlet UITextField *passwordField;

@property (nonatomic, strong) IBOutlet UIButton *loginButton;
@property (nonatomic, strong) IBOutlet UIButton *signupButton;

@end



@implementation LoginVC
#pragma mark Init
/**
 * Called when VC's is loaded.
 */
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.messageLabel.text = @"";
    [self.loginButton setBorderWidth:2.0 color:[UIColor whiteColor]];
    [self.signupButton setBorderWidth:2.0 color:[UIColor whiteColor]];
}


#pragma mark - Events
/**
 * Called when user hits return on a UITextField.
 * If username field, bring password field into focus.
 * If password field, attempt a login.
 */
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if (textField == self.usernameField)
    {
        [self.passwordField becomeFirstResponder];
    }
    else if (textField == self.passwordField)
    {
        NSString *username = self.usernameField.text;
        if (username.length == 0)
        {
            self.messageLabel.text = @"Enter a username";
            return NO;
        }
        
        [self loginWithUsername:username password:self.passwordField.text];
    }
    return YES;
}

/**
 * Called when user presses the login button.
 * Check that both fields are not empty, and attempt a login.
 */
- (IBAction)loginPressed:(id)sender
{
    NSString *username = self.usernameField.text;
    NSString *password = self.passwordField.text;
    
    if (username.length == 0)
    {
        self.messageLabel.text = @"Enter a username";
        return;
    }
    else if (password.length == 0)
    {
        self.messageLabel.text = @"Enter a password";
        return;
    }
    
    [self loginWithUsername:username password:password];
}

/**
 * Called when user presses the sign up button.
 * Check that both fields are not empty, and attempt a sign up.
 */
- (IBAction)signupPressed:(id)sender
{
    NSString *username = self.usernameField.text;
    NSString *password = self.passwordField.text;
    
    if (username.length == 0)
    {
        self.messageLabel.text = @"Enter a username";
        return;
    }
    else if (password.length == 0)
    {
        self.messageLabel.text = @"Enter a password";
        return;
    }
    
    [self signupWithUsername:username password:password];
}


/**
 * Attempt a login with the given username and password.
 * Display message on error, or present main app on login.
 */
- (void)loginWithUsername:(NSString *)username password:(NSString *)password
{
    [PFUser logInWithUsernameInBackground:username password:password
     block:^(PFUser *user, NSError *error)
     {
         if (error)
         {
             self.messageLabel.text = @"Error during login";
             if ([[error userInfo][@"error"] isEqualToString:@"invalid login parameters"])
             {
                 self.messageLabel.text = @"Incorrect username/password";
             }
             return;
         }
         
         //segue to some view
         NSLog(@"%@", [PFUser currentUser]);
         [self performSegueWithIdentifier:@"loginSegue" sender:nil];
     }];
}

/**
 * Attempt to cretae a new user from username and password.
 * Display message on error, or present main app with new user.
 */
- (void)signupWithUsername:(NSString *)username password:(NSString *)password
{
    PFUser *newuser = [PFUser user];
    newuser.username = username;
    newuser.password = password;
    
    [newuser signUpInBackgroundWithBlock:^(BOOL succeeded, NSError *error)
    {
        if (error)
        {
            self.messageLabel.text = [error userInfo][@"error"];
            return;
        }
        
        //segue to some view
        NSLog(@"%@", [PFUser currentUser]);
        [self performSegueWithIdentifier:@"loginSegue" sender:nil];
    }];
}

@end
