//
//  UserManagerConst.swift
//  FrameworkStruct
//
//  Created by  jggg on 2022/3/11.
//

/**
 * 用户管理器常量定义
 */
import Foundation

//MARK: 常量定义
///身高区间:100-250cm
var userHeightRange: NumberEnumerator = NumberEnumerator(range: (100, 250), step: 1)

///体重区间:20-200kg
var userWeightRange: NumberEnumerator = NumberEnumerator(range: (20, 200), step: 1)
