import MetalKit

class SandboxScene: Scene{
    
    var debugCamera = DebugCamera()
    
    override func buildScene() {
        addCamera(debugCamera)
        
        debugCamera.position.z = 100
        
        addCubes()
    }
    
    var cubeCollection1: CubeCollection!
    //var cubeCollection2: CubeCollection!

    func addCubes(){
        
        cubeCollection1 = CubeCollection(cubesWide: 20, cubesHigh: 20, cubesBack: 20)
        cubeCollection1.position.x = 0
        addChild(cubeCollection1)
        
       /* cubeCollection2 = CubeCollection(cubesWide: 20, cubesHigh: 20, cubesBack: 20)
        cubeCollection2.position.x = 16
        addChild(cubeCollection2)*/
    }
    
    override func update(deltaTime: Float) {
        cubeCollection1.rotation.z += deltaTime
       // cubeCollection2.rotation.z += deltaTime
        super.update(deltaTime: deltaTime)
    }
}
