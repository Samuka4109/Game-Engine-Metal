
#include <metal_stdlib>
using namespace metal;

struct VertexIn{
    float3 position;
    float4 color;
};

struct rasterizerData{
    float4 position [[ position ]];
    float4 color;
};

vertex rasterizerData basic_vertex_shader(const device VertexIn * vertices [[ buffer(0) ]],
                                  uint vertexID [[ vertex_id ]]){
    
    rasterizerData rd;
    
    rd.position = float4 (vertices[vertexID].position, 1);
    rd.color = vertices[vertexID].color;
    
    return rd;
    
}

fragment half4 basic_fragment_shader(rasterizerData rd [[ stage_in ]]){
    float4 color = rd.color;
    
    return half4(color.r, color.g, color.b, color.a);
}
 