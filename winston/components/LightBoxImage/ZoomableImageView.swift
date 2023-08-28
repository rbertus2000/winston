//
//  ZoomableImageView.swift
//  winston
//
//  Created by Daniel Inama on 27/08/23.
//

import Foundation
import UIKit
import SwiftUI

//Source https://stackoverflow.com/a/64110231
struct ZoomableScrollView<Content: View>: UIViewRepresentable {
  private var content: Content
  private var onTap: (()->())?
  
  
  init(onTap: (()->())? = nil, @ViewBuilder content: () -> Content) {
    self.content = content()
    //set up helper class
    self.onTap = onTap
  }
  
  
  
  
  func makeUIView(context: Context) -> UIScrollView {
    // set up the UIScrollView
    let scrollView = UIScrollView()
    scrollView.delegate = context.coordinator  // for viewForZooming(in:)
    scrollView.maximumZoomScale = 20
    scrollView.minimumZoomScale = 1
    scrollView.bouncesZoom = true
    scrollView.showsVerticalScrollIndicator = false
    scrollView.showsHorizontalScrollIndicator = false
    
    
    // create a UIHostingController to hold our SwiftUI content
    let hostedView = context.coordinator.hostingController.view!
    hostedView.translatesAutoresizingMaskIntoConstraints = true
    hostedView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
    hostedView.frame = scrollView.bounds
    scrollView.addSubview(hostedView)
    
    
    let doubleTapGesture = UITapGestureRecognizer(target: context.coordinator, action: #selector(Coordinator.handleDoubleTap(_:)))
    doubleTapGesture.numberOfTapsRequired = 2
    scrollView.addGestureRecognizer(doubleTapGesture)
    
    let tapGesture = UITapGestureRecognizer(target: context.coordinator, action: #selector(Coordinator.handleTap(_:)))
    tapGesture.numberOfTapsRequired = 1
    tapGesture.require(toFail: doubleTapGesture)
    scrollView.addGestureRecognizer(tapGesture)
    
    return scrollView
  }
  
  
  func updateUIView(_ uiView: UIScrollView, context: Context) {
    // update the hosting controller's SwiftUI content
    context.coordinator.hostingController.rootView = self.content
    assert(context.coordinator.hostingController.view.superview == uiView)
    
  }
  
  func makeCoordinator() -> Coordinator {
    return Coordinator(hostingController: UIHostingController(rootView: self.content), onTap: self.onTap)
  }
  
  // MARK: - Coordinator
  
  class Coordinator: NSObject, UIScrollViewDelegate {
    var hostingController: UIHostingController<Content>
    var onTap: (() -> ())?
    
    init(hostingController: UIHostingController<Content>, onTap: (() -> ())? = nil) {
      self.hostingController = hostingController
      self.onTap = onTap
    }
    
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
      return hostingController.view
    }
    
    @objc func handleTap(_ gestureRecognizer: UITapGestureRecognizer) {
      onTap?()
    }
    
    @objc func handleDoubleTap(_ gestureRecognizer: UITapGestureRecognizer) {
      if let scrollView = gestureRecognizer.view as? UIScrollView {
        if scrollView.zoomScale == 1 {
          let tapLocation = gestureRecognizer.location(in: scrollView)
          let zoomRect = CGRect(origin: tapLocation, size: CGSize(width: 100, height: 100))
          scrollView.zoom(to: zoomRect, animated: true)
        } else {
          scrollView.setZoomScale(1, animated: true)
        }
      }
    }
  }
  
}


