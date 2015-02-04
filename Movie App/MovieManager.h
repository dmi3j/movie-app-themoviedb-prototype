//
//  MovieManager.h
//  Movie App
//
//  Created by Dmitry Beloborodov on 04/02/15.
//  Copyright (c) 2015 Mobile Solutions. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "common.h"

@class MovieDetails;

#define MOVIE_MANAGER               [MovieManager sharedInstance]
#define APP_DOMAIN                  @"biz.mobisol.movieapp"

#define BASE_API_URL                @"https://api.themoviedb.org/3"
#define IMAGE_BASE_URL              @"https://image.tmdb.org/t/p/original"

typedef NS_ENUM(NSInteger, MAErrorCode) {
    MAErrorCodeNoResults,
    MAErrorCodeNetworkIssue,
    MAErrorCodeWrongInput
};

@interface MovieManager : NSObject

+ (MovieManager *)sharedInstance;

@property (nonatomic, readonly) NSString *apiKey;
@property (nonatomic, strong) NSDateFormatter *movieReleaseDateFormatter;

- (void)getMostPopularMoviesListWithSuccess:(void (^)(NSArray *moviesList))success
                                    failure:(void (^)(NSError *error))failure;

- (void)getDetailsForMovieWithID:(NSString *)movieID
                         success:(void (^)(MovieDetails *movieDetails))success
                         failure:(void (^)(NSError *error))failure;
@end
