//
//  Result+extension.swift
//  Holk
//
//  Created by 张梦皓 on 2020-03-25.
//  Copyright © 2020 Holk. All rights reserved.
//

extension Swift.Result where Success == Void {
    static var success: Self { .success(()) }
}
