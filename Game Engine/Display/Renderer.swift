import MetalKit

class Renderer: NSObject {
    public static var ScreenSize = SIMD2<Float>(repeating: 0)
    
    init(_ mtkView: MTKView) {
        super.init()
        updateScreenSize(view: mtkView)
    }
    
}

extension Renderer: MTKViewDelegate{
    
    public func updateScreenSize(view: MTKView){
        Renderer.ScreenSize = SIMD2<Float>(Float(view.bounds.width), Float(view.bounds.height))
    }
    
    func mtkView(_ view: MTKView, drawableSizeWillChange size: CGSize) {
        updateScreenSize(view: view)
    }
    
    func draw(in view: MTKView) {
        guard let drawable = view.currentDrawable, let currentRenderPassDescriptor = view.currentRenderPassDescriptor else { return }
        
        let commandBuffer = Engine.CommandQueue.makeCommandBuffer()
        let renderCommandEncoder = commandBuffer?.makeRenderCommandEncoder(descriptor: currentRenderPassDescriptor)
        
        SceneManager.TickScene(renderCommandeEncoder: renderCommandEncoder!, deltaTime: 1 / Float(view.preferredFramesPerSecond))
        
        renderCommandEncoder?.endEncoding()
        commandBuffer?.present(drawable)
        commandBuffer?.commit()
    }
    
}
