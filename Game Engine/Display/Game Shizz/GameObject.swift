import MetalKit

class GameObject {
    
    
    var vertices: [Vertex]!
    var vertexBuffer: MTLBuffer!
    
    init() {
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
        vertexBuffer = Engine.Device.makeBuffer(bytes: vertices, length: Vertex.stride(vertices.count), options: [])
    }
    
    func render(renderCommandEncoder: MTLRenderCommandEncoder){
        renderCommandEncoder.setRenderPipelineState(RenderPipelineStateLibrary.PipelineState(.Basic))
        renderCommandEncoder.setVertexBuffer(vertexBuffer, offset: 0, index: 0)
        renderCommandEncoder.drawPrimitives(type: .triangle, vertexStart: 0, vertexCount: vertices.count)
        
        
    }
}
