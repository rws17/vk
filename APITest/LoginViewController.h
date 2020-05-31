//
//  LoginViewController.h
//  APITest
//
//  Created by Дмитрий Стародубцев on 12.05.2020.
//  Copyright © 2020 Дмитрий Стародубцев. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <WebKit/WebKit.h>


@class AccessToken;

typedef void(^LoginCompletionBlock)(AccessToken* token);

@interface LoginViewController : UIViewController

- (id) initWithCompletionBlock:(LoginCompletionBlock) completionBlock;

@end
