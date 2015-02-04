//
//  MovieDetailsController.m
//  Movie App
//
//  Created by Dmitry Beloborodov on 04/02/15.
//  Copyright (c) 2015 Mobile Solutions. All rights reserved.
//

#import "MovieDetailsController.h"
#import "common.h"
#import "MovieManager.h"
#import "Movie.h"
#import "MovieDetails.h"

#import <SDWebImage/UIImageView+WebCache.h>
#import <AXRatingView/AXRatingView.h>

@interface MovieDetailsController ()

@property (weak, nonatomic) IBOutlet UIImageView *backdropImage;
@property (weak, nonatomic) IBOutlet UITextView *longDescription;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicator;
@property (weak, nonatomic) IBOutlet UILabel *releaseYearValue;
@property (weak, nonatomic) IBOutlet UILabel *genresValue;

@property (weak, nonatomic) IBOutlet AXRatingView *ratingView;
@property (nonatomic) BOOL requestInProgress;
@property (nonatomic, strong) NSDateFormatter *yearDateFormatter;

@end

@implementation MovieDetailsController

#pragma mark - Properties

- (NSDateFormatter *)yearDateFormatter
{
    if (!_yearDateFormatter) {
        _yearDateFormatter = [[NSDateFormatter alloc] init];
        _yearDateFormatter.dateFormat = @"yyyy";
    }
    return _yearDateFormatter;
}

#pragma mark - Lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];

    self.longDescription.text =
    self.releaseYearValue.text =
    self.genresValue.text = @"";

    self.ratingView.numberOfStar = 10;
    self.ratingView.value = 0;
    self.ratingView.userInteractionEnabled = NO;

    WeakSelf weakSelf = self;
    [self.activityIndicator startAnimating];
    [self.backdropImage sd_setImageWithURL:_movie.defaultBackdropURL
                          placeholderImage:nil
                                   options:SDWebImageRefreshCached
                                 completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL)
     {
         [weakSelf.activityIndicator stopAnimating];
     }];

    self.title = self.movie.title;

    if (self.movie.movieDetails) {
        [self displatMovieDetails];
    } else {
        [self updateData];
    }
}

#pragma mark - 

- (void)displatMovieDetails
{
    self.longDescription.text = self.movie.movieDetails.overview;
    self.releaseYearValue.text = [self.yearDateFormatter stringFromDate:self.movie.releaseDate];
    self.genresValue.text = self.movie.movieDetails.genresAsString;
    self.ratingView.value = self.movie.voteAverage.floatValue;
}

- (void)updateData
{
    if (self.requestInProgress) return;

    WeakSelf weakSelf = self;

    [MOVIE_MANAGER getDetailsForMovieWithID:self.movie.movieID success:^(MovieDetails *movieDetails) {
        if (movieDetails) {
            weakSelf.movie.movieDetails = movieDetails;
            [weakSelf displatMovieDetails];
        }
        weakSelf.requestInProgress = NO;
    } failure:^(NSError *error) {
        weakSelf.requestInProgress = NO;
    }];
}

@end
