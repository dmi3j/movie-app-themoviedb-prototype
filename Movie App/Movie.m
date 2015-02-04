//
//  Movie.m
//  Movie App
//
//  Created by Dmitry Beloborodov on 04/02/15.
//  Copyright (c) 2015 Mobile Solutions. All rights reserved.
//

#import "Movie.h"
#import "MovieManager.h"

@implementation Movie

- (instancetype)initMovieWithDictionary:(NSDictionary *)movieDictionary
{
    self = [super init];

    if (self) {
        self.movieID = [[movieDictionary objectForKey:@"id"] description];
        self.originalTitle = [movieDictionary objectForKey:@"original_title"];
        self.title = [movieDictionary objectForKey:@"title"];
        self.posterImagePath = [movieDictionary objectForKey:@"poster_path"];
        self.backdropImagePath = [movieDictionary objectForKey:@"backdrop_path"];
        self.voteAverage = [movieDictionary objectForKey:@"vote_average"];
        self.releaseDate = [MOVIE_MANAGER.movieReleaseDateFormatter dateFromString:[movieDictionary objectForKey:@"release_date"]];
    }
    
    return self;
}

- (NSURL *)defaultPosterURL
{
    NSString *urlString = [NSString stringWithFormat:@"%@%@?api_key=%@", IMAGE_BASE_URL, self.posterImagePath, MOVIE_MANAGER.apiKey];
    return [NSURL URLWithString:urlString];
}

- (NSURL *)defaultBackdropURL
{
    NSString *urlString = [NSString stringWithFormat:@"%@%@?api_key=%@", IMAGE_BASE_URL, self.backdropImagePath, MOVIE_MANAGER.apiKey];
    return [NSURL URLWithString:urlString];
}

@end
