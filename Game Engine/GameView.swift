
import MetalKit

class GameView: MTKView {

    var commandQueue: MTLCommandQueue!
    var renderPipelineState: MTLRenderPipelineState!
    
    var vertices: [Vertex]!
    
    var vertexBuffer: MTLBuffer!
    
    required init(coder: NSCoder) {
        super.init(coder: coder)
        
        self.device = MTLCreateSystemDefaultDevice()
        
        self.clearColor = MTLClearColor(red: 0.43, green: 0.73, blue: 0.35, alpha: 1.0)
        
        self.colorPixelFormat = .bgra8Unorm
        
        self.commandQueue = device?.makeCommandQueue()
        
        createRenderPipelineState()
        
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
    
    func createBuffers(){
        vertexBuffer = device?.makeBuffer(bytes: vertices, length: Vertex.stride(vertices.count), options: [])
    }
    
    func createRenderPipelineState(){
        
        let library = device?.makeDefaultLibrary()
        let vertexFunction = library?.makeFunction(name: "basic_vertex_shader")
        let fragmentFunction = library?.makeFunction(name: "basic_fragment_shader")
        
        let vertexDescriptor = MTLVertexDescriptor()
        
        //Position
        vertexDescriptor.attributes[0].format = .float3
        vertexDescriptor.attributes[0].bufferIndex = 0
        vertexDescriptor.attributes[0].offset = 0
        
        //Color
        vertexDescriptor.attributes[1].format = .float4
        vertexDescriptor.attributes[1].bufferIndex = 0
        vertexDescriptor.attributes[1].offset = SIMD3<Float>.size()
        
        vertexDescriptor.layouts[0].stride = Vertex.stride()
        
        let renderPipeLineDescriptor = MTLRenderPipelineDescriptor()
        renderPipeLineDescriptor.colorAttachments[0].pixelFormat = .bgra8Unorm
        renderPipeLineDescriptor.vertexFunction = vertexFunction
        renderPipeLineDescriptor.fragmentFunction = fragmentFunction
        renderPipeLineDescriptor.vertexDescriptor = vertexDescriptor
        
        do{
            renderPipelineState = try device?.makeRenderPipelineState(descriptor: renderPipeLineDescriptor)
        }catch let error as NSError{
            print(error)
        }
        
        
    }
    
    override func draw(_ dirtyRect: NSRect){
        guard let drawable = self.currentDrawable, let currentRenderPassDescriptor = self.currentRenderPassDescriptor else { return }
        
        let commandBuffer = commandQueue.makeCommandBuffer()
        let renderCommandEncoder = commandBuffer?.makeRenderCommandEncoder(descriptor: currentRenderPassDescriptor)
        renderCommandEncoder?.setRenderPipelineState(renderPipelineState)
        
        renderCommandEncoder?.setVertexBuffer(vertexBuffer, offset: 0, index: 0)
        renderCommandEncoder?.drawPrimitives(type: .triangle, vertexStart: 0, vertexCount: vertices.count)
        
        renderCommandEncoder?.endEncoding()
        commandBuffer?.present(drawable)
        commandBuffer?.commit()
    }
}
