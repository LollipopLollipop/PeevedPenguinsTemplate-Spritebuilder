//
//  Seal.m
//  PeevedPenguins
//
//  Created by Ding ZHAO on 2/5/15.
//  Copyright (c) 2015 Apportable. All rights reserved.
//

#import "Seal.h"

@implementation Seal

// For test purpose
/*
- (id)init {
    self = [super init];
    
    if (self) {
        CCLOG(@"Seal created");
    }
    
    return self;
}*/
- (void)didLoadFromCCB {
    self.physicsBody.collisionType = @"seal";
}
@end
