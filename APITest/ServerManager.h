//
//  ServerManager.h
//  APITest
//
//  Created by Дмитрий Стародубцев on 11.05.2020.
//  Copyright © 2020 Дмитрий Стародубцев. All rights reserved.
//

#import <Foundation/Foundation.h>

@class User;

NS_ASSUME_NONNULL_BEGIN

@interface ServerManager : NSObject

@property(strong, nonatomic, readonly) User* currentUser;


+(ServerManager*) sharedManager;


-(void) authorizeUser:(void(^)(User* user)) completion;

-(void) getUser:(NSString*) userID
      onSuccess:(void(^)(User* user)) success
      onFailure:(void(^)(NSError* error, NSInteger statusCode)) failure;

- (void) getFriendsWithOfSet:(NSInteger) offset
                       count:(NSInteger) count
                   onSuccess:(void(^)(NSArray* friends)) success
                   onFailure:(void(^)(NSError* error, NSInteger statusCode)) failure;


@end

NS_ASSUME_NONNULL_END
