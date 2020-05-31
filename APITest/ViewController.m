//
//  ViewController.m
//  APITest
//
//  Created by Дмитрий Стародубцев on 11.05.2020.
//  Copyright © 2020 Дмитрий Стародубцев. All rights reserved.
//

#import "ViewController.h"
#import "ServerManager.h"
#import "User.h"
#import "UIImageView+AFNetworking.h"

@interface ViewController ()

@property (strong, nonatomic) NSMutableArray* friendsArray;

@end

@implementation ViewController

static NSInteger friendsInReqest = 10;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.friendsArray = [NSMutableArray array];
}

-(void) viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    [[ServerManager sharedManager] authorizeUser:^(User * user) {
        [self getFriendsFromServer];
        
        NSLog(@"AUTHORUZED!");
        NSLog(@"%@ %@", user.firstName, user.lastName);
        
    }];
}

#pragma mark - API

-(void) getFriendsFromServer {
    
    [[ServerManager sharedManager]
     getFriendsWithOfSet:[self.friendsArray count]
     count:friendsInReqest
     onSuccess:^(NSArray *friends) {
        
        [self.friendsArray addObjectsFromArray:friends];
        
        NSMutableArray* newPath = [NSMutableArray array];
        
        for (int i = (int)[self.friendsArray count] - (int)[friends count]; i < [self.friendsArray count]; i++) {
            [newPath addObject:[NSIndexPath indexPathForRow:i inSection:0]];
        }
        
        [self.tableView beginUpdates];
        [self.tableView insertRowsAtIndexPaths:newPath withRowAnimation:UITableViewRowAnimationTop];
        [self.tableView endUpdates];
        
    }
     
     onFailure:^(NSError *error, NSInteger statusCode) {
        NSLog(@"error = %@, code = %ld",[error localizedDescription], statusCode);
    }];
}

#pragma mark - UITableViewDataSourse

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return [self.friendsArray count] + 1;
    
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString* identifier = @"Cell";
    
    UITableViewCell* cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    
    if (indexPath.row == [self.friendsArray count]) {
        cell.textLabel.text = @"LOAD MORE";
        cell.imageView.image = nil;
        
    }else {
        
        User* friend = [self.friendsArray objectAtIndex:indexPath.row];
        
        cell.textLabel.text = [NSString stringWithFormat:@"%@ %@",friend.firstName, friend.lastName];
        
        NSURLRequest* request = [NSURLRequest requestWithURL:friend.imageURL];
        
        __weak UITableViewCell* weakCell = cell;
        
        cell.imageView.image = nil;
        
        [cell.imageView
         setImageWithURLRequest:request
         placeholderImage:nil
         success:^(NSURLRequest *request, NSHTTPURLResponse *response, UIImage *image) {
            weakCell.imageView.image = image;
            [weakCell layoutSubviews];
            
        }
         failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error) {
            
        }];
        
    }
    
    return cell;
    
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (indexPath.row  == [self.friendsArray count]) {
        
        [self getFriendsFromServer];
    }
    
}




@end
