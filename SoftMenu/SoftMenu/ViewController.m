//
//  ViewController.m
//  SoftMenu
//
//  Created by ACCENDO on 22/08/16.
//  Copyright © 2016 ACCENDO. All rights reserved.
//

#import "ViewController.h"
#import "MenuViewController.h"

@interface ViewController ()<NSURLSessionDataDelegate,NSURLConnectionDelegate>
{
    NSMutableData *res;
}

@end

@implementation ViewController
@synthesize usernameTextField;
@synthesize passwordTextField;


- (void)viewDidLoad
{

    [self hideBar];
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}

-(BOOL) NSStringIsValidEmail:(NSString *)checkString
{
    BOOL stricterFilter = NO;
    NSString *stricterFilterString = @"^[A-Z0-9a-z\\._%+-]+@([A-Za-z0-9-]+\\.)+[A-Za-z]{2,4}$";
    NSString *laxString = @"^.+@([A-Za-z0-9-]+\\.)+[A-Za-z]{2}[A-Za-z]*$";
    NSString *emailRegex = stricterFilter ? stricterFilterString : laxString;
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    return [emailTest evaluateWithObject:checkString];
}


-(void)hideBar
{
    self.navigationController.navigationBarHidden = YES;
}


-(void)showAlert:(NSString *)str
{
    UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"Alert" message:str delegate:self cancelButtonTitle:@"cancel"    otherButtonTitles:@"ok", nil];
    [alert show];
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)signinButton:(id)sender {
    if ([usernameTextField.text isEqualToString:@""])
    {
        
        [self showAlert:@"Please enter Username"];
        [self.usernameTextField becomeFirstResponder];
        
    }
    else if(![self NSStringIsValidEmail:usernameTextField.text])
    {
        [self showAlert:@"Please enter valid Username"];
        [self.usernameTextField becomeFirstResponder];
        
    }
    
    else if([passwordTextField.text isEqualToString:@""]) {
        
        [self showAlert:@"Please enter password"];
        [self.passwordTextField becomeFirstResponder];
        
    }
    else
    {
        NSLog(@" login values are %@,%@",usernameTextField.text,passwordTextField.text);
        [self loginService:usernameTextField.text :passwordTextField.text];
    }
}
-(void)loginService:(NSString *)str1 :(NSString *)str2
{
    
    UIDevice *device = [UIDevice currentDevice];
    
    NSString *currentDeviceId = [[device identifierForVendor]UUIDString];
    
//    NSDictionary *dic=@{@"email":str1,@"password":str2,@"device_id":currentDeviceId};
    
//    NSLog(@"dictionary  values are %@",dic);
        
    NSURL *url = [NSURL URLWithString:@"http://172.16.1.10/sm_dev/api/Login"];
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url
                                                           cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:60.0];
    
//    NSError *jsonSerializationError;
    
//    NSData *requestData = [NSJSONSerialization dataWithJSONObject:dic options:nil error:&jsonSerializationError];
//    
    [request setHTTPMethod:@"POST"];
    
    
    [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"content-type"];
    //this is hard coded based on your suggested values, obviously you'd probably need to make this more dynamic based on your application's specific data to send
    NSString *postString =[NSString stringWithFormat: @"email=%@&password=%@&deviceid=%@",str1,str2,currentDeviceId];
    NSData *data = [postString dataUsingEncoding:NSUTF8StringEncoding];
    [request setHTTPBody:data];
    [request setValue:[NSString stringWithFormat:@"%u", [data length]] forHTTPHeaderField:@"Content-Length"];
    
    [request setValue:@"api" forHTTPHeaderField:@"Username"];
    [request setValue:@"password" forHTTPHeaderField:@"Password"];
     
    
    NSURLConnection *connection = [[NSURLConnection alloc] initWithRequest:request delegate:self];
    
    if( connection )
    {
        res = [[NSMutableData alloc] init];
    }
}

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response;
{
    [res setLength:0];
    
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data;
{
    
    [res appendData:data];
}


- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error;
{
    NSLog(@"%@",[error localizedDescription]);
}
- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    NSError *error=nil;
    NSDictionary *resdic=[NSJSONSerialization JSONObjectWithData:res options:kNilOptions error:&error];

    NSLog(@"Responce %@",resdic);
    
    MenuViewController *mvc=[self.storyboard instantiateViewControllerWithIdentifier:@"MenuViewController"];
    
        [self.navigationController pushViewController:mvc animated:YES];
    
}
@end
