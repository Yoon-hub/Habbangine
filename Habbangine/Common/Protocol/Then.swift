//
//  Then.swift
//  Habbangine
//
//  Created by 윤제 on 6/5/24.
//

import Foundation

public protocol Then {}

extension Then where Self: AnyObject {
    
  @inlinable
  public func then(_ block: (Self) throws -> Void) rethrows -> Self {
    try block(self)
    return self
  }
}

extension NSObject: Then {}
