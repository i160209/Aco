//
//  Gif.swift
//  Neo
//
//  Created by Meow on 05/05/2020.
//  Copyright © 2020 Meow. All rights reserved.
//

import Gifu
import Foundation

class Gif: UIImageView, GIFAnimatable {
  public lazy var animator: Animator? = {
    return Animator(withDelegate: self)
  }()

  override public func display(_ layer: CALayer) {
    updateImageIfNeeded()
  }
}
