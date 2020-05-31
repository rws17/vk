//
//  AccessToken.h
//  APITest
//
//  Created by Дмитрий Стародубцев on 12.05.2020.
//  Copyright © 2020 Дмитрий Стародубцев. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface AccessToken : NSObject

@property(strong, nonatomic) NSString* token;
@property(strong, nonatomic) NSDate* expiretionDate;
@property(strong, nonatomic) NSString* UserID;

@end

NS_ASSUME_NONNULL_END
