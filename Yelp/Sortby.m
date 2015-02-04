//
//  Sortby.m
//  Yelp
//
//  Created by Nadav Golbandi on 2/3/15.
//  Copyright (c) 2015 codepath. All rights reserved.
//

#import "Sortby.h"

@implementation Sortby

- (id)init{
    self = [super init];
    if(self){
        self.values = [[NSArray alloc] initWithObjects:@"Best matched", @"Distance",@"Highest Rated",nil];
    }
    return self;
    
}
@end
