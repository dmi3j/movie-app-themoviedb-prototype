//
//  MovieDetails.h
//  Movie App
//
//  Created by Dmitry Beloborodov on 04/02/15.
//  Copyright (c) 2015 Mobile Solutions. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MovieDetails : NSObject

@property (nonatomic, copy) NSString *overview;
@property (nonatomic, strong) NSArray *genres;

#pragma mark - read only
@property (nonatomic, readonly) NSString *genresAsString;

- (instancetype)initMovieWithDictionary:(NSDictionary *)movieDictionary;

@end
