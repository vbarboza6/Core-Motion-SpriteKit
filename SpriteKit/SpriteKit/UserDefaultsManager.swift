//
//  UserDefaultsManager.swift
//  SpriteKit
//
//  Created by Vianka Barboza on 9/27/17.
//  Copyright © 2017 Vianka Barboza. All rights reserved.
//

import Foundation

private var userGoal = 0;
private var userSteps = 0;

func getUserGoal () -> Int{
    return userGoal;
}
func setUserGoal(goal: Int) {
    userGoal = goal
}

func getUserSteps () -> Int{
    return userSteps;
}
func setUserSteps(steps: Int) {
    userSteps = steps
}
