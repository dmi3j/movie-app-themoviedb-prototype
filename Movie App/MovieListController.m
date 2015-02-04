//
//  MovieListController.m
//  Movie App
//
//  Created by Dmitry Beloborodov on 04/02/15.
//  Copyright (c) 2015 Mobile Solutions. All rights reserved.
//

#import "MovieListController.h"
#import "common.h"
#import "MovieManager.h"
#import "Movie.h"
#import "MoviePreviewCell.h"
#import "MovieDetailsController.h"

#define DEFAULT_GAP     5.0f

@interface MovieListController ()

@property (nonatomic, strong) NSArray *moviesList;
@property (nonatomic, strong) UIRefreshControl *refreshControl;
@property (nonatomic) BOOL requestInProgress;
@property (nonatomic, strong) Movie *selectedMovie;

@end

@implementation MovieListController

#pragma mark - Properties

- (void)setMoviesList:(NSArray *)moviesList
{
    _moviesList = moviesList;

    [self.collectionView reloadData];
}

- (UIRefreshControl *)refreshControl
{
    if (!_refreshControl) {
        _refreshControl = [[UIRefreshControl alloc] init];
        [_refreshControl addTarget:self action:@selector(refreshControllDragged) forControlEvents:UIControlEventValueChanged];
    }
    return _refreshControl;
}

#pragma mark - Lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];

    [self setupUI];
    [self.refreshControl beginRefreshing];
    [self updateData];
}

- (void)setupUI
{
    self.collectionView.alwaysBounceVertical = YES;
    [self.collectionView addSubview:self.refreshControl];
}

#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"Movie_Details_Segue"]) {
        MovieDetailsController *detailsController = (MovieDetailsController *)segue.destinationViewController;
        detailsController.movie = self.selectedMovie;
    }
}

#pragma mark - UICollectionViewDelegateFlowLayout

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    // we want keep cell aspect ratio 10:17
    CGFloat cellWidth = (self.view.frame.size.width - (4 * DEFAULT_GAP)) / 3;
    CGFloat cellHeight = cellWidth * 17 / 10;
    
    return CGSizeMake(cellWidth, cellHeight);
}

#pragma mark - UICollectionViewDataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.moviesList.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    MoviePreviewCell *cell = (MoviePreviewCell *)[collectionView dequeueReusableCellWithReuseIdentifier:@"MoviePreviewCell" forIndexPath:indexPath];
    Movie *currentMovie = [self.moviesList objectAtIndex:indexPath.row];
    cell.movie = currentMovie;

    return cell;
}

#pragma mark - UICollectionViewDelegate

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    self.selectedMovie = [self.moviesList objectAtIndex:indexPath.row];
    [self performSegueWithIdentifier:@"Movie_Details_Segue" sender:self];
}

#pragma mark -

- (void)refreshControllDragged
{
    [self updateData];
}

- (void)updateData
{
    if (self.requestInProgress) return;

    WeakSelf weakSelf = self;

    [MOVIE_MANAGER getMostPopularMoviesListWithSuccess:^(NSArray *moviesList) {
        weakSelf.moviesList = moviesList;
        [weakSelf.refreshControl endRefreshing];
        weakSelf.requestInProgress = NO;
    } failure:^(NSError *error) {
        [weakSelf.refreshControl endRefreshing];
        weakSelf.requestInProgress = NO;
    }];
}

@end
