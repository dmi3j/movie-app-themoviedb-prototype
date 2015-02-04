//
//  Movie.h
//  Movie App
//
//  Created by Dmitry Beloborodov on 04/02/15.
//  Copyright (c) 2015 Mobile Solutions. All rights reserved.
//

#import <Foundation/Foundation.h>

@class MovieDetails;

@interface Movie : NSObject

@property (nonatomic, copy) NSString *movieID;
@property (nonatomic, copy) NSString *originalTitle;
@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *posterImagePath;
@property (nonatomic, copy) NSString *backdropImagePath;
@property (nonatomic, copy) NSDate *releaseDate;
@property (nonatomic, strong) NSNumber *voteAverage;

@property (nonatomic, strong) MovieDetails *movieDetails;

#pragma mark - read only
@property (nonatomic, readonly) NSURL *defaultPosterURL;
@property (nonatomic, readonly) NSURL *defaultBackdropURL;

- (instancetype)initMovieWithDictionary:(NSDictionary *)movieDictionary;

@end
