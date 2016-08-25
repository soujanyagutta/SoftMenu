//
//  ViewController.h
//  SoftMenu
//
//  Created by ACCENDO on 22/08/16.
//  Copyright © 2016 ACCENDO. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ViewController : UIViewController
@property (weak, nonatomic) IBOutlet UITextField *usernameTextField;
- (IBAction)signinButton:(id)sender;
@property (weak, nonatomic) IBOutlet UITextField *passwordTextField;


@end

