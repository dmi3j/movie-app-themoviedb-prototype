//
//  MovieDetails.m
//  Movie App
//
//  Created by Dmitry Beloborodov on 04/02/15.
//  Copyright (c) 2015 Mobile Solutions. All rights reserved.
//

#import "MovieDetails.h"
#import "MovieManager.h"

@implementation MovieDetails

@synthesize genresAsString = _genresAsString;

- (instancetype)initMovieWithDictionary:(NSDictionary *)movieDictionary
{
    self = [super init];

    if (self) {

        self.overview = [movieDictionary objectForKey:@"overview"];

        NSMutableArray *genres = [NSMutableArray arrayWithCapacity:0];
        NSArray *rawGenres = [movieDictionary objectForKey:@"genres"];
        for (NSDictionary *currentGenre in rawGenres) {
            [genres addObject:[currentGenre objectForKey:@"name"]];
        }
        self.genres = genres;
    }

    return self;
}

- (NSString *)genresAsString
{
    if (!_genresAsString) {
        if (self.genres.count > 0) {
            NSMutableString *genresString = [NSMutableString string];
            for (NSString *currentGenre in self.genres) {
                [genresString appendFormat:@"%@, ", currentGenre];
            }
            _genresAsString = [genresString substringToIndex:[genresString length] - 2];
        } else {
            _genresAsString = @"---";
        }
    }
    return _genresAsString;
}

@end
