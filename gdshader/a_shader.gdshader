shader_type canvas_item;
const int max_points = 128;
uniform vec2 points[max_points];
uniform float radius = 0.0;
uniform int point_count;
uniform vec4 color:source_color;
uniform vec4 color_1:source_color;
uniform float smooth_values;
uniform float game_width;
uniform float game_higth;

void fragment() {
    float circle = 0.0 ; 
    float mask = 0.0;
    for (int i = 0;i < point_count;i++){
        circle = 0.0;
        float dist = distance(vec2(UV.x*game_width,UV.y*game_higth), points[i]);
        //smoothstep(a, b, x) x如果小于a则输出1.0，大于b则0.0，中间就平滑过渡
        circle = 1.0 - smoothstep(radius-smooth_values, radius+smooth_values, dist);
        mask = max(mask,circle);
    }
    COLOR = mix(color_1,color,mask);
    
}
