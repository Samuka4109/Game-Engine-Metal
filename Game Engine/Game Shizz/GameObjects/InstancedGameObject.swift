import MetalKit

class InstancedGameObject: Node {
    private var _mesh: Mesh!
    
    var material = Material()
    
    internal var _nodes: [Node] = []
    private var _modelConstants: [ModelConstants] = []
    
    private var _modelConstantsBuffer: MTLBuffer!
    
    init(meshType: MeshTypes, instanceCount: Int) {
        super.init()
        self._mesh = MeshLibrary.Mesh(meshType)
        self._mesh.setInstancedCount(instanceCount)
        self.generateInstances(instanceCount)
        self.createBuffers(instanceCount)
    }
    
    func generateInstances(_ instanceCount: Int) {
        for _ in 0..<instanceCount {
            _nodes.append(Node())
            _modelConstants.append(ModelConstants())
        }
    }
    
    func createBuffers(_ instanceCount: Int) {
        _modelConstantsBuffer = Engine.Device.makeBuffer(length: ModelConstants.stride(instanceCount), options: [])
    }
    
    private func updateModelConstantsBuffer() {
        var pointer = _modelConstantsBuffer.contents().bindMemory(to: ModelConstants.self, capacity: _modelConstants.count)
        for node in _nodes {
            pointer.pointee.modelMatrix = matrix_multiply(self.modelMatrix, node.modelMatrix)
            pointer = pointer.advanced(by: 1)
        }
    }
        
        override func update(deltaTime: Float) {
            
            updateModelConstantsBuffer()
            
            super.update(deltaTime: deltaTime)
        }
    }
    
    extension InstancedGameObject: Renderable {
        func doRender(_ renderCommandEncoder: MTLRenderCommandEncoder) {
            renderCommandEncoder.setRenderPipelineState(RenderPipelineStateLibrary.PipelineState(.Instanced))
            renderCommandEncoder.setDepthStencilState(DepthStencilStateLibrary.DepthStencilState(.Less))
            
            //Vertex Shader
            renderCommandEncoder.setVertexBuffer(_modelConstantsBuffer, offset: 0, index: 2)
            
            //Fragment Shader
            renderCommandEncoder.setFragmentBytes(&material, length: Material.stride, index: 1)
    
            _mesh.drawPrimitives(renderCommandEncoder)
        }
    }
    
    //Material Properties
    extension InstancedGameObject {
        public func setColor(_ color: SIMD4<Float>) {
            self.material.color = color
            self.material.useMaterialColor = true
        }
    }
