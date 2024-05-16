import MetalKit

var debugCamera = DebugCamera()
class SandboxScene: Scene{
    override func buildScene() {
        addCamera(debugCamera)
        
        
        let count: Int = 5
        for y in -count..<count{
            for x in -count..<count{
                let Pointer = Pointer(camera: debugCamera)
                Pointer.position.y = Float(Float(y) + 0.5) / Float(count)
                Pointer.position.x = Float(Float(x) + 0.5) / Float(count)
                Pointer.scale = SIMD3<Float>(repeating: 0.1)
                addChild(Pointer)
             
            }
        }
    }
}
