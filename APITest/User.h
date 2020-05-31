//
//  User.h
//  APITest
//
//  Created by Дмитрий Стародубцев on 12.05.2020.
//  Copyright © 2020 Дмитрий Стародубцев. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface User : NSObject

@property (strong, nonatomic) NSString* firstName;
@property (strong, nonatomic) NSString* lastName;
@property (strong, nonatomic) NSURL* imageURL;

-(id) initWithServerResponse: (NSDictionary*) responseObject;

@end

NS_ASSUME_NONNULL_END
