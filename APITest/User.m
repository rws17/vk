//
//  User.m
//  APITest
//
//  Created by Дмитрий Стародубцев on 12.05.2020.
//  Copyright © 2020 Дмитрий Стародубцев. All rights reserved.
//

#import "User.h"

@implementation User

-(id) initWithServerResponse: (NSDictionary*) responseObject {
    
    self = [super init];
    
    if (self) {
        
        self.firstName = [responseObject objectForKey:@"first_name"];
        self.lastName = [responseObject objectForKey:@"last_name"];
        
        NSString* urlString = [responseObject objectForKey:@"photo_50"];
        
        if (urlString) {
            self.imageURL = [NSURL URLWithString:urlString];
        }

    }
    return self;
}


@end
