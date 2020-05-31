//
//  ServerManager.m
//  APITest
//
//  Created by Дмитрий Стародубцев on 11.05.2020.
//  Copyright © 2020 Дмитрий Стародубцев. All rights reserved.
//

#import "ServerManager.h"
#import "AFNetworking.h"
#import "User.h"
#import "LoginViewController.h"
#import "AccessToken.h"

@interface ServerManager ()

@property (strong, nonatomic) AFHTTPRequestOperationManager* requestOperationManager;
@property (strong, nonatomic) AccessToken* accessToken;

@end

@implementation ServerManager

+(ServerManager*) sharedManager {
    
    static ServerManager* manager = nil;
    
    static dispatch_once_t onceToken;
    
    dispatch_once(&onceToken, ^{
        manager = [[ServerManager alloc] init];
    });
    
    return manager;
    
}

-(id) init {
    self = [super init];
    
    if (self) {
        
        NSURL* url = [NSURL URLWithString:@"https://api.vk.com/method/"];
        
        self.requestOperationManager = [[AFHTTPRequestOperationManager alloc] initWithBaseURL:url];
    }
    return self;
}


-(void) authorizeUser:(void(^)(User* user)) completion {
    
    LoginViewController* vc =
    [[LoginViewController alloc] initWithCompletionBlock:^(AccessToken *token) {
        
        self.accessToken = token;
        
        if (token) {
            
            [self getUser:self.accessToken.UserID
                onSuccess:^(User* user) {
                if  (completion) {
                    completion(nil);
                }
            }
                onFailure:^(NSError *error, NSInteger statusCode) {
                completion(nil);
            }];
            
        } else if (completion) {
            completion(nil);
        }
        
    }];
    
    UINavigationController* nav = [[UINavigationController alloc] initWithRootViewController:vc];
    
    UIViewController* mainVC =  [[[UIApplication sharedApplication] windows] firstObject].rootViewController;
    
    [mainVC presentViewController:nav
                         animated:YES
                       completion:nil];
    
}

- (void) getUser:(NSString*) userID
       onSuccess:(void(^)(User* user)) success
       onFailure:(void(^)(NSError* error, NSInteger statusCode)) failure {
    
    NSDictionary* params =
    [NSDictionary dictionaryWithObjectsAndKeys:
     userID,       @"user_ids",
     @"photo_50",  @"fields",
     @"nom",       @"name_case",nil];
    
    [self.requestOperationManager
     GET:@"users.get"
     parameters:params
     success:^(AFHTTPRequestOperation *operation, NSDictionary* responseObject) {
        NSLog(@"JSON: %@", responseObject);
        
        NSDictionary* raw = [responseObject objectForKey:@"response"];
        
        NSMutableArray* dictsArray =  [raw objectForKey:@"items"];
        
        if ([dictsArray count] > 0) {
            User* user = [[User alloc] initWithServerResponse:[dictsArray firstObject]];
            if (success) {
                success(user);
            }
        }else {
            if (failure) {
                failure(nil, operation.response.statusCode);
            }
            
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error);
        
        if (failure) {
            failure(error, operation.response.statusCode);
        }
    }];
    
}


- (void) getFriendsWithOfSet:(NSInteger) offset
                       count:(NSInteger) count
                   onSuccess:(void(^)(NSArray* friends)) success
                   onFailure:(void(^)(NSError* error, NSInteger statusCode)) failure {
    
    NSDictionary* params =
    [NSDictionary dictionaryWithObjectsAndKeys:
     @"44124504",             @"user_id",
     @"name",                 @"order",
     @(count),                @"count",
     @(offset),               @"offset",
     @"photo_50",             @"fields",
     self.accessToken.token,  @"access_token",
     @"nom",                  @"name_case",
     @"5.92",                 @"v",
     nil];
    
    [self.requestOperationManager
     GET:@"friends.get"
     parameters:params
     success:^(AFHTTPRequestOperation *operation, NSDictionary* responseObject) {
        NSLog(@"JSON: %@", responseObject);
        
        NSDictionary* raw = [responseObject objectForKey:@"response"];
        
        NSMutableArray* dictsArray =  [raw objectForKey:@"items"];
        
        NSMutableArray* objectsArray = [NSMutableArray array];
        
        for (NSDictionary* dict in dictsArray) {
            User* user = [[User alloc] initWithServerResponse:dict];
            [objectsArray addObject:user];
        }
        
        if (success) {
            success(objectsArray);
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error);
        
        if (failure) {
            failure(error, operation.response.statusCode);
        }
    }];
}

@end
