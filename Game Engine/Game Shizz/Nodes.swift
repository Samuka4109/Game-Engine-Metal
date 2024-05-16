import MetalKit

class Node{
    
    var position: SIMD3<Float> = SIMD3(repeating: 0)
    var scale: SIMD3<Float> = SIMD3(repeating: 1)
    var rotation: SIMD3<Float> = SIMD3(repeating: 0)
    
    var modelMatrix: matrix_float4x4{
        var modelMatrix = matrix_identity_float4x4
        modelMatrix.translate(direction: position)
        modelMatrix.rotate(angle: rotation.x, axis: X_ASIS)
        modelMatrix.rotate(angle: rotation.y, axis: Y_ASIS)
        modelMatrix.rotate(angle: rotation.z, axis: Z_ASIS)
        modelMatrix.scale(axis: scale)
        return modelMatrix
    }
    
    var children: [Node] = []
    
    func addChild(_ child: Node){
        children.append(child)
    }
    
    func update(deltaTime: Float){
        for child in children{
            child.update(deltaTime: deltaTime)
        }
    }
    
    func render(renderCommandEncoder: MTLRenderCommandEncoder){
        for child in children{
            child.render(renderCommandEncoder: renderCommandEncoder)
        }
        
        if let renderable = self as? Renderable{
            renderable.doRender(renderCommandEncoder)
        }
    }
}
