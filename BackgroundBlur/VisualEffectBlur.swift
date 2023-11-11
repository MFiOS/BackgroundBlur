/*
See LICENSE folder for this sample’s licensing information.

Abstract:
The iOS implementation of a UIVisualEffectView's blur and vibrancy.
使用SwiftUI创建模糊效果（Blur Effect）的自定义视图 VisualEffectBlur。
 
这段代码通过 SwiftUI 和 UIKit 的结合，提供了一个易于使用的模糊效果视图，使开发者能够在 SwiftUI 中轻松实现界面的模糊效果。
*/

import SwiftUI

// MARK: - VisualEffectBlur

struct VisualEffectBlur<Content: View>: View {
    // UIBlurEffect.Style 枚举，表示模糊效果的样式，默认为 .systemMaterial
    var blurStyle: UIBlurEffect.Style
    // UIVibrancyEffectStyle 枚举，表示活力效果的样式，默认为 nil。
    var vibrancyStyle: UIVibrancyEffectStyle?
    // 一个用于构建视图的闭包，返回一个 Content 类型的视图。
    var content: Content
    
    init(blurStyle: UIBlurEffect.Style = .systemMaterial, vibrancyStyle: UIVibrancyEffectStyle? = nil, @ViewBuilder content: () -> Content) {
        self.blurStyle = blurStyle
        self.vibrancyStyle = vibrancyStyle
        // 将传递的 content 闭包执行后的结果存储在 self.content 中
        self.content = content()
    }
    
    // Representable 结构体的实例，用于在 SwiftUI 中表示 UIKit 视图。
    var body: some View {
        Representable(blurStyle: blurStyle, vibrancyStyle: vibrancyStyle, content: ZStack { content })
            .accessibility(hidden: Content.self == EmptyView.self)
    }
}

// MARK: - Representable
/*
 Representable 结构体：
     UIViewRepresentable 协议的实现，用于将 UIKit 的 UIVisualEffectView 整合到 SwiftUI 中。
     makeUIView 方法创建了一个 UIVisualEffectView 实例，作为模糊效果的容器。
     updateUIView 方法用于在 SwiftUI 视图发生更改时更新 UIKit 视图。
     makeCoordinator 方法创建了一个 Coordinator 类的实例，用于管理 UIKit 视图的协调。
 */
extension VisualEffectBlur {
    struct Representable<Content: View>: UIViewRepresentable {
        var blurStyle: UIBlurEffect.Style
        var vibrancyStyle: UIVibrancyEffectStyle?
        var content: Content
        
        func makeUIView(context: Context) -> UIVisualEffectView {
            context.coordinator.blurView
        }
        
        func updateUIView(_ view: UIVisualEffectView, context: Context) {
            context.coordinator.update(content: content, blurStyle: blurStyle, vibrancyStyle: vibrancyStyle)
        }
        
        func makeCoordinator() -> Coordinator {
            Coordinator(content: content)
        }
    }
}

// MARK: - Coordinator
/*
 Coordinator 类：
     包含了 UIVisualEffectView、UIVisualEffectView 作为 UIVibrancyEffect 的容器，
     以及 UIHostingController 用于 SwiftUI 视图的容器。
     update 方法用于更新 SwiftUI 视图和模糊效果的样式。
     init 方法中，设置了容器视图的一些属性，并将 SwiftUI 视图
     和模糊效果整合到 UIVisualEffectView 和 UIVibrancyEffect 中。
 */
extension VisualEffectBlur.Representable {
    class Coordinator {
        let blurView = UIVisualEffectView()
        let vibrancyView = UIVisualEffectView()
        let hostingController: UIHostingController<Content>
        
        init(content: Content) {
            hostingController = UIHostingController(rootView: content)
            hostingController.view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
            hostingController.view.backgroundColor = nil
            blurView.contentView.addSubview(vibrancyView)
            blurView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
            vibrancyView.contentView.addSubview(hostingController.view)
            vibrancyView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        }
        
        func update(content: Content, blurStyle: UIBlurEffect.Style, vibrancyStyle: UIVibrancyEffectStyle?) {
            hostingController.rootView = content
            let blurEffect = UIBlurEffect(style: blurStyle)
            blurView.effect = blurEffect
            if let vibrancyStyle = vibrancyStyle {
                vibrancyView.effect = UIVibrancyEffect(blurEffect: blurEffect, style: vibrancyStyle)
            } else {
                vibrancyView.effect = nil
            }
            hostingController.view.setNeedsDisplay()
        }
    }
}

// MARK: - Content-less Initializer
/*
 Content-less Initializer：
    提供了一个特殊的初始化方法，当 Content 类型为 EmptyView 时使用。这用于创建没有内容的模糊效果。
 */
extension VisualEffectBlur where Content == EmptyView {
    init(blurStyle: UIBlurEffect.Style = .systemMaterial) {
        self.init( blurStyle: blurStyle, vibrancyStyle: nil) {
            EmptyView()
        }
    }
}

// MARK: - Previews

struct VisualEffectBlur_Previews: PreviewProvider {
    static var previews: some View {
        ZStack {
            LinearGradient(
                gradient: Gradient(colors: [.red, .blue]),
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            
            VisualEffectBlur(blurStyle: .systemUltraThinMaterial, vibrancyStyle: .fill) {
                Text("Hello World!")
                    .frame(width: 200, height: 100)
            }
        }
        .previewLayout(.sizeThatFits)
    }
}

