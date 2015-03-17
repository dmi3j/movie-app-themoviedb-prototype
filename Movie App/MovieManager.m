//
//  MovieManager.m
//  Movie App
//
//  Created by Dmitry Beloborodov on 04/02/15.
//  Copyright (c) 2015 Mobile Solutions. All rights reserved.
//

#import "MovieManager.h"
#import <AFNetworking/AFNetworking.h>
#import "Movie.h"
#import "MovieDetails.h"

#define API_KEY             @"d62ea96e64c4622cc931084236674c60"

@interface MovieManager ()

@end

@implementation MovieManager

#pragma mark - Singleton

+ (MovieManager *)sharedInstance
{
    static dispatch_once_t pred;
    static MovieManager *shared = nil;

    dispatch_once(&pred, ^{
        shared = [[MovieManager alloc] init];
    });
    return shared;
}

#pragma mark - Properties

- (NSString *)apiKey
{
    // TODO: hide key
    return API_KEY;
}

- (NSDateFormatter *)movieReleaseDateFormatter
{
    if (!_movieReleaseDateFormatter) {
        _movieReleaseDateFormatter = [[NSDateFormatter alloc] init];
        _movieReleaseDateFormatter.dateFormat = @"yyyy-MM-dd";
    }
    return _movieReleaseDateFormatter;
}

#pragma mark -

- (void)getMostPopularMoviesListWithSuccess:(void (^)(NSArray *moviesList))success
                                    failure:(void (^)(NSError *error))failure
{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{

        NSString *string = [NSString stringWithFormat:@"%@/discover/movie?sort_by=popularity.desc&api_key=%@", BASE_API_URL, self.apiKey];
        // uncomment this to read simple statis JSON file
//        string = @"https://raw.githubusercontent.com/dmi3j/movie-app-themoviedb-prototype/master/movie-request-example.json";
        NSURL *url = [NSURL URLWithString:string];
        NSURLRequest *request = [NSURLRequest requestWithURL:url];
        AFHTTPRequestOperation *moviesListFetchOperation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
        moviesListFetchOperation.responseSerializer = [AFJSONResponseSerializer serializer];
        // uncomment this to read simple statis JSON file
//        moviesListFetchOperation.responseSerializer.acceptableContentTypes = nil;
        [moviesListFetchOperation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject)
        {
            dispatch_async(dispatch_get_main_queue(), ^{

                NSMutableArray *results = [NSMutableArray arrayWithCapacity:0];
                NSArray *moviesList = [(NSDictionary *)responseObject objectForKey:@"results"];
                if (moviesList.count > 0) {
                    for (NSDictionary *rawMovie in moviesList) {
                        Movie *movie = [[Movie alloc] initMovieWithDictionary:rawMovie];
                        if (movie) [results addObject:movie];
                    }
                }

                if (results.count > 0) {
                    success(results);
                } else {

                    NSError *error = [NSError errorWithDomain:APP_DOMAIN
                                                         code:MAErrorCodeNoResults
                                                     userInfo:@{NSLocalizedDescriptionKey : @"Failed to fetch movies list",
                                                                NSLocalizedFailureReasonErrorKey : @"Movie manager failure"}];
                    failure(error);
                }

            });

        }
                                                        failure:^(AFHTTPRequestOperation *operation, NSError *error)
        {
            dispatch_async(dispatch_get_main_queue(), ^{
                DLog(@"Failure fetching movies");
                failure(error);
            });
        }];
        
        [moviesListFetchOperation start];
    });
}

- (void)getDetailsForMovieWithID:(NSString *)movieID
                         success:(void (^)(MovieDetails *movieDetails))success
                         failure:(void (^)(NSError *error))failure
{
    if (!movieID.length) {

        NSError *error = [NSError errorWithDomain:APP_DOMAIN
                                             code:MAErrorCodeWrongInput
                                         userInfo:@{NSLocalizedDescriptionKey : @"No valid movie ID provided",
                                                    NSLocalizedFailureReasonErrorKey : @"Movie manager failure"}];
        failure(error);
    } else {

    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{

        // https://api.themoviedb.org/3/movie/228967?api_key=d62ea96e64c4622cc931084236674c60
        NSString *string = [NSString stringWithFormat:@"%@/movie/%@?api_key=%@", BASE_API_URL, movieID, self.apiKey];
        NSURL *url = [NSURL URLWithString:string];
        NSURLRequest *request = [NSURLRequest requestWithURL:url];
        AFHTTPRequestOperation *moviesDetailsFetchOperation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
        moviesDetailsFetchOperation.responseSerializer = [AFJSONResponseSerializer serializer];

        [moviesDetailsFetchOperation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject)
         {
             dispatch_async(dispatch_get_main_queue(), ^{

//                 NSMutableArray *results = [NSMutableArray arrayWithCapacity:0];
                 MovieDetails *resultMovieDetails = [[MovieDetails alloc] initMovieWithDictionary:(NSDictionary *)responseObject];

                 if (resultMovieDetails) {
                     success(resultMovieDetails);
                 } else {
                     NSError *error = [NSError errorWithDomain:APP_DOMAIN
                                                          code:MAErrorCodeNoResults
                                                      userInfo:@{NSLocalizedDescriptionKey : @"Failed to fetch movies details",
                                                                 NSLocalizedFailureReasonErrorKey : @"Movie manager failure"}];
                     failure(error);
                 }

//                 NSArray *moviesList = [(NSDictionary *)responseObject objectForKey:@"results"];
//                 if (moviesList.count > 0) {
//                     for (NSDictionary *rawMovie in moviesList) {
//                         Movie *movie = [[Movie alloc] initMovieWithDictionary:rawMovie];
//                         if (movie) [results addObject:movie];
//                     }
//                 }
//
//                 if (results.count > 0) {
//                     success(results);
//                 } else {
//
//                     NSError *error = [NSError errorWithDomain:APP_DOMAIN
//                                                          code:MAErrorCodeNoResults
//                                                      userInfo:@{NSLocalizedDescriptionKey : @"Failed to fetch movies list",
//                                                                 NSLocalizedFailureReasonErrorKey : @"Movie manager failure"}];
//                     failure(error);
//                 }

             });

         }
                                                        failure:^(AFHTTPRequestOperation *operation, NSError *error)
         {
             dispatch_async(dispatch_get_main_queue(), ^{
                 DLog(@"Failure fetching movie details");
                 failure(error);
             });
         }];
        
        [moviesDetailsFetchOperation start];
    });
    }
}

@end
