import MetalKit

class Renderer: NSObject {
    
    var gameObject: GameObject = GameObject()
}

extension Renderer: MTKViewDelegate{
    
    func mtkView(_ view: MTKView, drawableSizeWillChange size: CGSize) {
        //when the window is resized
    }
    
    func draw(in view: MTKView) {
        guard let drawable = view.currentDrawable, let currentRenderPassDescriptor = view.currentRenderPassDescriptor else { return }
        let commandBuffer = Engine.CommandQueue.makeCommandBuffer()
        let renderCommandEncoder = commandBuffer?.makeRenderCommandEncoder(descriptor: currentRenderPassDescriptor)
        
        gameObject.render(renderCommandEncoder: renderCommandEncoder!)
        
        renderCommandEncoder?.endEncoding()
        commandBuffer?.present(drawable)
        commandBuffer?.commit()
    }
}
