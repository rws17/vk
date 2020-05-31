//
//  LoginViewController.m
//  APITest
//
//  Created by Дмитрий Стародубцев on 12.05.2020.
//  Copyright © 2020 Дмитрий Стародубцев. All rights reserved.
//

#import "LoginViewController.h"
#import "AccessToken.h"

@interface LoginViewController ()<WKNavigationDelegate>

@property (copy, nonatomic) LoginCompletionBlock completionBlock;

@end

@implementation LoginViewController

- (id) initWithCompletionBlock:(LoginCompletionBlock)completionBlock{
    self = [super init];
    if (self) {
        self.completionBlock = completionBlock;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    CGRect frame = self.view.frame;
    
    WKWebView* webView = [[WKWebView alloc] initWithFrame:frame];
    webView.navigationDelegate = self;
    
    NSString* urlString = [NSString stringWithFormat:@"https://oauth.vk.com/authorize?client_id=7462458&display=mobile&redirect_uri=https://oauth.vk.com/blank.html/&scope=%@&response_type=token&v=5.92&state=123456",  [self getScope]];
    
    NSURL *nsurl = [NSURL URLWithString:urlString];
    
    NSURLRequest* nsrequest =  [NSURLRequest requestWithURL:nsurl];
    [webView loadRequest:nsrequest];
    [self.view addSubview:webView];
    
    self.navigationItem.title = @"Login";
    
}

- (NSString*) getScope {
    
    NSInteger photoScope = 4;
    NSInteger wallScope = 8192;
    NSInteger friendsScope = 2;
    NSInteger videoScope = 16;
    
    
    NSInteger scope = photoScope + wallScope + friendsScope+ videoScope;
    return [NSString stringWithFormat:@"%ld",scope];;
}

- (void)webView:(WKWebView *)webView didFailProvisionalNavigation:(null_unspecified WKNavigation *)navigation withError:(NSError *)error{
    NSLog(@"Error = %@", error.description);
}

- (void)webView:(WKWebView *)webView decidePolicyForNavigationAction:(WKNavigationAction *)navigationAction decisionHandler:(void (^)(WKNavigationActionPolicy))decisionHandler{
    
    if ([[[navigationAction.request URL] host] isEqualToString:@"oauth.vk.com"]) {
        
        NSString* query = [[navigationAction.request URL] description];
        
        if ([query containsString:@"https://oauth.vk.com/authorize?client_id=7462458"]) {
            decisionHandler(WKNavigationActionPolicyAllow);
            return;
        }
        
        AccessToken* token = [self getTokenFromResponce:query];
        
        if (self.completionBlock) {
            self.completionBlock(token);
            [self dismissViewControllerAnimated:true completion:nil];
        }
    }
    decisionHandler(WKNavigationActionPolicyAllow);
}

- (AccessToken*) getTokenFromResponce:(NSString*) query {
    
    AccessToken* token = [[AccessToken alloc] init];
    
    NSArray* array = [query componentsSeparatedByString:@"#"];
    
    if ([array count] > 1) {
        query = [array lastObject];
    }
    
    NSArray* pairs = [query componentsSeparatedByString:@"&"];
    
    for (NSString* pair in pairs) {
        
        NSArray* values = [pair componentsSeparatedByString:@"="];
        
        if ([values count] == 2) {
            
            NSString* key = [values firstObject];
            
            if ([key isEqualToString:@"access_token"]) {
                token.token = [values lastObject];
            } else if ([key isEqualToString:@"expires_in"]) {
                
                NSTimeInterval interval = [[values lastObject] doubleValue];
                
                token.expiretionDate = [NSDate dateWithTimeIntervalSinceNow:interval];
                
            } else if ([key isEqualToString:@"user_id"]) {
                
                token.UserID = [values lastObject];
            }
        }
    }
    
    return token;
}


@end
