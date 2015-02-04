//
//  MoviePreviewCell.m
//  Movie App
//
//  Created by Dmitry Beloborodov on 04/02/15.
//  Copyright (c) 2015 Mobile Solutions. All rights reserved.
//

#import "MoviePreviewCell.h"
#import "common.h"
#import "Movie.h"

#import <SDWebImage/UIImageView+WebCache.h>

@interface MoviePreviewCell ()

@property (weak, nonatomic) IBOutlet UIImageView *moviePoster;
@property (weak, nonatomic) IBOutlet UILabel *movieTitle;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicator;

@end

@implementation MoviePreviewCell

- (void)setMovie:(Movie *)movie
{
    _movie = movie;

    self.movieTitle.text = _movie.title;
    WeakSelf weakSelf = self;
    [self.activityIndicator startAnimating];
    [self.moviePoster sd_setImageWithURL:_movie.defaultPosterURL
                        placeholderImage:nil
                                 options:SDWebImageRefreshCached
                               completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL)
     {
         [weakSelf.activityIndicator stopAnimating];
     }];
}

@end
