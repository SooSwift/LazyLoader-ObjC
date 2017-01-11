//
//  LazyCell.m
//  LazyLoader
//
//  Created by Sachin Sawant on 26/12/16.
//  Copyright © 2016 Sachin Sawant. All rights reserved.
//

#import "LazyCell.h"

@implementation LazyCell

-(void)updateConstraints{
 
    //Remove all default contraints applied due to prototyping cell
    [self.contentView removeConstraints:self.contentView.constraints];
    
    
    NSDictionary *views = [NSDictionary dictionaryWithObjectsAndKeys:self.imgView, @"imgView", self.nameLabel,@"nameLabel", self.descriptionLabel,@"descriptionLabel",nil];
    
    // Constraint for ImageView
    NSArray *constraints = [NSLayoutConstraint constraintsWithVisualFormat:@"H:|[imgView]|" options:0 metrics:nil views:views];
    [self.contentView addConstraints:constraints];
    
    // Constraint for NameLabel
    constraints = [NSLayoutConstraint constraintsWithVisualFormat:@"H:|-10-[nameLabel]-10-|" options:0 metrics:nil views:views];
    [self.contentView addConstraints:constraints];
    
    // Constraint for DescriptionLabel
    self.descriptionLabel.numberOfLines = 0;
    constraints = [NSLayoutConstraint constraintsWithVisualFormat:@"H:|-10-[descriptionLabel]-10-|" options:0 metrics:nil views:views];
    [self.contentView addConstraints:constraints];
    
    
    // Contstraints for Spacing
    constraints = [NSLayoutConstraint constraintsWithVisualFormat:@"V:|[imgView]-5-[nameLabel]" options:0 metrics:nil views:views];
    [self.contentView addConstraints:constraints];
 
    constraints = [NSLayoutConstraint constraintsWithVisualFormat:@"V:[nameLabel]-5-[descriptionLabel]" options:0 metrics:nil views:views];
    [self.contentView addConstraints:constraints];
    
    constraints = [NSLayoutConstraint constraintsWithVisualFormat:@"V:[descriptionLabel]-5-|" options:0 metrics:nil views:views];
    [self.contentView addConstraints:constraints];
    
    
    [super updateConstraints];
}
@end
