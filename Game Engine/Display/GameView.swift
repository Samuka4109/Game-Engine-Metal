import MetalKit

class GameView: MTKView {

    var vertices: [Vertex]!
    
    var vertexBuffer: MTLBuffer!
    
    required init(coder: NSCoder) {
        super.init(coder: coder)
        
        self.device = MTLCreateSystemDefaultDevice()
        
        Engine.Ignite(device: device!)
        
        self.clearColor = Preferences.ClearColor
        
        self.colorPixelFormat = Preferences.MainPixelFormat
        
        createVertices()
        
        createBuffers()
        
    }
    
    func createVertices(){
        vertices = [
            Vertex(position: SIMD3( 0, 1,0), color: SIMD4(1,0,0,1)),
            Vertex(position: SIMD3(-1,-1,0), color: SIMD4(0,1,0,1)),
            Vertex(position: SIMD3( 1,-1,0), color: SIMD4(0,0,1,1))
        ]
    }
    // ficar de olho nesse device?
    func createBuffers(){
        vertexBuffer = Engine.Device.makeBuffer(bytes: vertices, length: Vertex.stride(vertices.count), options: [])
    }
  
    override func draw(_ dirtyRect: NSRect){
        guard let drawable = self.currentDrawable, let currentRenderPassDescriptor = self.currentRenderPassDescriptor else { return }
        
        let commandBuffer = Engine.CommandQueue.makeCommandBuffer()
        let renderCommandEncoder = commandBuffer?.makeRenderCommandEncoder(descriptor: currentRenderPassDescriptor)
        
        renderCommandEncoder?.setRenderPipelineState(RenderPipelineStateLibrary.PipelineState(.Basic))
        renderCommandEncoder?.setVertexBuffer(vertexBuffer, offset: 0, index: 0)
        renderCommandEncoder?.drawPrimitives(type: .triangle, vertexStart: 0, vertexCount: vertices.count)
        
        renderCommandEncoder?.endEncoding()
        commandBuffer?.present(drawable)
        commandBuffer?.commit()
    }
}
