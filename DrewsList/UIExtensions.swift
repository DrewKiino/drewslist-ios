

// Author: Andrew Aquino
import Cartography

extension UIViewController {
  public func fillSuperview(of controller: UIViewController?) {
    if let controller = controller {
      controller.addChildViewController(self)
      controller.view.addSubview(self.view)
      self.view.fillSuperview()
      self.didMove(toParentViewController: controller)
    }
  }
  public func anchorToBottom(of controller: UIViewController?,  height: CGFloat) {
    if let controller = controller {
      controller.addChildViewController(self)
      controller.view.addSubview(self.view)
      constrain(self.view, controller.view) { (view, superview) in
        view.left == superview.left
        view.right == superview.right
        view.bottom == superview.bottom
        view.height == height
      }
      self.didMove(toParentViewController: controller)
    }
  }
}

extension UIView {
  @discardableResult
  public func removeAllConstraints() -> Self {
    removeConstraints(constraints)
    let superview = self.superview
    removeFromSuperview()
    superview?.addSubview(self)
    return self
  }
  public enum Center {
    case x
    case y
  }
  @discardableResult
  public func center(_ center: UIView.Center, offsetBy offset: CGFloat) -> Self {
    if let superview = self.superview {
      constrain(self, superview) { view, superview in
        switch center {
        case .x:
          view.centerX == superview.centerX + offset
          break
        case .y:
          view.centerY == superview.centerY + offset
          break
        }
      }
    }
    return self
  }
  @discardableResult
  public func center(_ center: UIView.Center? = nil, alongView view: UIView? = nil) -> Self {
    if let superview = view ?? self.superview {
      constrain(self, superview) { view, superview in
        if let center = center {
          switch center {
          case .x:
            view.centerX == superview.centerX
            break
          case .y:
            view.centerY == superview.centerY
            break
          }
        } else {
          view.center == superview.center
        }
      }
    }
    return self
  }
  @discardableResult
  public func fillSuperview(padding: CGFloat) -> Self {
    return fillSuperview(left: padding, right: padding, top: padding, bottom: padding)
  }
  @discardableResult
  public func fillSuperview(left: CGFloat = 0, right: CGFloat = 0, top: CGFloat = 0, bottom: CGFloat = 0) -> Self {
    if let superview = self.superview {
      constrain(self, superview) { view, superview in
        view.left == superview.left + left
        view.right == superview.right - right
        view.top == superview.top + top
        view.bottom == superview.bottom - bottom
      }
    }
    return self
  }
  @discardableResult
  public func matching(_ dimensions: UIView.Dimension...) -> Self {
    guard let superview = self.superview else { return self }
    constrain(self, superview) { view, superview in
      for dimension in dimensions {
        switch dimension {
        case .width:
          view.width == superview.width
          break
        case .height:
          view.height == superview.height
          break
        }
      }
    }
    return self
  }
  @discardableResult
  public func width(_ width: CGFloat, constraintBlock: ((NSLayoutConstraint) -> ())? = nil) -> Self {
    return size(width: width, height: 0, constraintBlock: constraintBlock)
  }
  @discardableResult
  public func height(_ height: CGFloat, constraintBlock: ((NSLayoutConstraint) -> ())? = nil) -> Self {
    return size(width: 0, height: height, constraintBlock: constraintBlock)
  }
  @discardableResult
  public func size(width: CGFloat, height: CGFloat, constraintBlock: ((NSLayoutConstraint) -> ())? = nil) -> Self {
    constrain(self) { view in
      if width > 0 {
        let constraint = view.width == width
        constraintBlock?(constraint)
      }
      if height > 0 {
        let constraint = view.height == height
        constraintBlock?(constraint)
      }
    }
    return self
  }
  public enum Dimension {
    case width
    case height
  }
  public enum Position{
    case left
    case right
    case top
    case bottom
    case topLeft
    case topRight
    case bottomLeft
    case bottomRight
  }
  @discardableResult
  public func anchor(_ position: UIView.Position, of anchorView: UIView, padding: CGFloat = 0, matching dimensions: UIView.Dimension...) -> Self {
    guard let superview = self.superview else { return self }
    constrain(self, anchorView, superview) { view, anchorView, superview in
      for dimension in dimensions {
        switch dimension {
        case .width: view.width == anchorView.width
          break
        case .height: view.height == anchorView.height
          break
        }
      }
      switch position {
      case .left:
        view.centerY == anchorView.centerY
        if !dimensions.contains(.width) {
          view.left == superview.left + padding
        }
        break
      case .right: 
        view.centerY == anchorView.centerY
        if !dimensions.contains(.width) {
          view.right == superview.right - padding
        }
        break
      case .top:
        view.centerX == anchorView.centerX
        if !dimensions.contains(.height) {
          view.top == superview.top + padding
        }
        break
      case .bottom:
        view.centerX == anchorView.centerX
        if !dimensions.contains(.height) {
          view.bottom == superview.bottom - padding
        }
        break
      default:
        break
      }
    }
    return anchor(position, of: anchorView, padding: padding, constraintBlock: nil)
  }
  @discardableResult
  public func anchor(_ positions: UIView.Position..., padding: CGFloat = 0) -> Self {
    if let superview = self.superview {
      constrain(self, superview) { view, superview in
        for position in positions {
          switch position {
          case .top:
            view.top == superview.top + padding
            break
          case .bottom:
            view.bottom == superview.bottom - padding
            break
          case .left:
            view.left == superview.left + padding
            break
          case .right:
            view.right == superview.right - padding
            break
          default:
            break
          }
        }
      }
    }
    return self
  }
  @discardableResult
  public func anchor(_ position: UIView.Position, of anchorView: UIView, padding: CGFloat = 0, constraintBlock: ((NSLayoutConstraint) -> ())? = nil) -> Self {
    constrain(self, anchorView) { view, anchorView in
      switch position {
      case .left:
        let constraint = view.right == anchorView.left - padding
        constraintBlock?(constraint)
        break
      case .right:
        let constraint = view.left == anchorView.right + padding
        constraintBlock?(constraint)
        break
      case .top:
        let constraint = view.bottom == anchorView.top - padding
        constraintBlock?(constraint)
        break
      case .bottom:
        let constraint = view.top == anchorView.bottom + padding
        constraintBlock?(constraint)
        break
      case .topLeft:
        view.bottom == anchorView.top - padding
        view.right == anchorView.left - padding
        break
      case .topRight:
        view.bottom == anchorView.top - padding
        view.left == anchorView.right + padding
        break
      case .bottomLeft:
        view.top == anchorView.bottom + padding
        view.right == anchorView.left - padding
        break
      case .bottomRight:
        view.top == anchorView.bottom + padding
        view.left == anchorView.right + padding
        break
      }
    }
    return self
  }
}
