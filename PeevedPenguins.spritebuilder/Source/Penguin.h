//
//  Penguin.h
//  PeevedPenguins
//
//  Created by Ding ZHAO on 2/5/15.
//  Copyright (c) 2015 Apportable. All rights reserved.
//

#import "CCSprite.h"

@interface Penguin : CCSprite
//avoid next attempt before it has been launched
@property (nonatomic, assign) BOOL launched;

@end
