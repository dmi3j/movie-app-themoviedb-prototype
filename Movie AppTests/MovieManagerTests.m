//
//  MovieManagerTests.m
//  Movie App
//
//  Created by Dmitry Beloborodov on 04/02/15.
//  Copyright (c) 2015 Mobile Solutions. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <XCTest/XCTest.h>

#import "MovieManager.h"
#import "Movie.h"
#import "MovieDetails.h"

#define TIME_OUT_INTERVAL       60

@interface MovieManagerTests : XCTestCase

@end

@implementation MovieManagerTests

- (void)setUp {
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testGetMostPopularMoviesListWithSuccess
{
    __block BOOL hasCalledBack = NO;

    [MOVIE_MANAGER getMostPopularMoviesListWithSuccess:^(NSArray *moviesList) {
        XCTAssertTrue(moviesList.count > 0, @"Should be at least one result");

        for (Movie *currentMovie in moviesList) {
            XCTAssertTrue(currentMovie.title.length > 0, @"Movie should have title");
            DLog(@"movie title = %@", currentMovie.title);
            XCTAssertTrue(currentMovie.originalTitle.length > 0, @"Movie should have original title");
            DLog(@"movie original title = %@", currentMovie.originalTitle);
        }
        hasCalledBack = YES;
    } failure:^(NSError *error) {
        XCTFail(@"Failed because of %@", error.description);
        hasCalledBack = YES;
    }];

    NSDate *loopUntil = [NSDate dateWithTimeIntervalSinceNow:TIME_OUT_INTERVAL];
    while (hasCalledBack == NO && [loopUntil timeIntervalSinceNow] > 0) {
        [[NSRunLoop currentRunLoop] runMode:NSDefaultRunLoopMode beforeDate:loopUntil];
    }

    if (!hasCalledBack) {
        XCTFail(@"Failed on timeout");
    }
}

#define MOVIE_ID    @"260346" // movie id "Taken 3"

- (void)testGetDetailsForMovieWithID
{
    __block BOOL hasCalledBack = NO;

    [MOVIE_MANAGER getDetailsForMovieWithID:MOVIE_ID success:^(MovieDetails *movieDetails) {

        XCTAssertTrue(movieDetails.overview.length > 0, @"Movie should have overview");
        hasCalledBack = YES;

    } failure:^(NSError *error) {
        XCTFail(@"Failed because of %@", error.description);
        hasCalledBack = YES;
    }];

    NSDate *loopUntil = [NSDate dateWithTimeIntervalSinceNow:TIME_OUT_INTERVAL];
    while (hasCalledBack == NO && [loopUntil timeIntervalSinceNow] > 0) {
        [[NSRunLoop currentRunLoop] runMode:NSDefaultRunLoopMode beforeDate:loopUntil];
    }

    if (!hasCalledBack) {
        XCTFail(@"Failed on timeout");
    }
}

@end
