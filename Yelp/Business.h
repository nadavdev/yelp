//
//  Buisiness.h
//  Yelp
//
//  Created by Nadav Golbandi on 1/30/15.
//  Copyright (c) 2015 codepath. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Business : NSObject

@property (nonatomic, strong) NSString* imageUrl;
@property (nonatomic, strong) NSString* name;
@property (nonatomic, strong) NSString* ratingImageUrl;
@property (nonatomic, assign) NSInteger numReviews;
@property (nonatomic, strong) NSString* address;
@property (nonatomic, strong) NSString* categories;
@property (nonatomic, assign) CGFloat distance;

+ (NSArray*) businessesWithDictinaries:(NSArray*) dictionaries;
@end