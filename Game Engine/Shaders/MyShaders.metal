
#include <metal_stdlib>
using namespace metal;

struct VertexIn{
    float3 position [[ attribute(0) ]];
    float4 color [[ attribute(1) ]];
};

struct rasterizerData{
    float4 position [[ position ]];
    float4 color;
};

struct ModelConstants{
    float4x4 modelMatrix;
};

vertex rasterizerData basic_vertex_shader(const VertexIn vIn [[ stage_in ]],
                                          constant ModelConstants &modelConstants [[ buffer(1) ]]){
    
    rasterizerData rd;
    
    rd.position = modelConstants.modelMatrix * float4(vIn.position, 1);
    rd.color = vIn.color;
    
    return rd;
    
}

fragment half4 basic_fragment_shader(rasterizerData rd [[ stage_in ]]){
    float4 color = rd.color;
    
    return half4(color.r, color.g, color.b, color.a);
}
 
