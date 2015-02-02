//
//  Buisiness.m
//  Yelp
//
//  Created by Nadav Golbandi on 1/30/15.
//  Copyright (c) 2015 codepath. All rights reserved.
//

#import "Business.h"

@implementation Business

- (id) initWithDictionary: (NSDictionary*) dictionary {
    self = [super init];
    if(self){
        NSArray* categories = dictionary[@"categories"];
        NSMutableArray* categoriesName = [NSMutableArray array];
        [categories enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
            [categoriesName addObject:obj[0]];
        }];
        self.categories = [categoriesName componentsJoinedByString:@", "];
        self.name = dictionary[@"name"];
        self.imageUrl = dictionary[@"image_url"];
        if ([dictionary valueForKeyPath:@"location.address"] && [dictionary valueForKeyPath:@"location.nighbarhoods"]) {
            NSArray* hood = [dictionary valueForKeyPath:@"location.nighbarhoods"];
            NSArray* addr = [dictionary valueForKeyPath:@"location.address"];
            if (hood.count > 0 && addr.count > 0) {
                NSString* street = addr[0];
                NSString* nighbarhoods = hood[0];
                self.address = [NSString stringWithFormat:@"%@, %@", street, nighbarhoods];
            }
            else{
            self.address = @"";
            }
        }
        self.numReviews = [dictionary[@"review_count"] integerValue];
        self.ratingImageUrl = dictionary[@"rating_img_url"];
        float milesPerMeter = 0.000621371;
        self.distance = [dictionary[@"distance"] integerValue] * milesPerMeter;
    }
    return self;
}

+ (NSArray*) businessesWithDictinaries:(NSArray*) dictionaries{
    NSMutableArray* newBusnisses = [NSMutableArray array];
    for (NSDictionary* dictionary in dictionaries) {
        Business* business = [[Business alloc]initWithDictionary:dictionary];
        
        [newBusnisses addObject:business];
    }
    return newBusnisses;
}
@end
