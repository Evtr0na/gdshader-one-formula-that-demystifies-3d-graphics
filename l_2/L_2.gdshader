shader_type canvas_item;

//-----------------------------------------------------------------
//-- base_state
//-----------------------------------------------------------------
const int max_points = 128;
uniform float radius = 1.0;
uniform float smooth_values = 1.0;
uniform float game_width;
uniform float game_higth;
uniform float line_width;
uniform vec4 color:source_color;
uniform vec4 color_1:source_color;
uniform int point_count;
uniform vec2 points[max_points];




//-----------------------------------------------------------------
//-- Draw Line
//-----------------------------------------------------------------
float segment_distance (vec2 a,vec2 b ,vec2 p){
    vec2 ap = p - a;
    vec2 ab = b - a;
    float h = clamp(dot(ap, ab)/max( dot(ab,ab) ,0.00001), 0.0, 1.0);
    return length(ap - ab*h);
}

float draw_line (vec2 a, vec2 b, vec2 p){
    return 1.0 - smoothstep(
    line_width - smooth_values,
    line_width + smooth_values,
    segment_distance(a, b, p)
    );
    
}


//-----------------------------------------------------------------
//-- Draw Point
//-----------------------------------------------------------------
float draw_point(vec2 p_,float m){
    
    float circle = 0.0 ; 
    for (int i = 0;i < point_count;i++){
        
        //抵消比例问题        
        vec2 delta = vec2(p_) - points[i]; 
        circle = 0.0;
        float dist = length(delta);
        
        // float dist = distance(vec2(UV.x*game_width,UV.y*game_higth), points[i]);
        //smoothstep(a, b, x) x如果小于a则输出1.0，大于b则0.0，中间就平滑过渡
        circle = 1.0 - smoothstep(radius-smooth_values, radius+smooth_values, dist);
        m = max(m,circle);
    }
    return m;
}
    
void fragment() {
    vec2 pixel = vec2(UV.x*game_width,UV.y*game_higth);
    float mask = 0.0;
    mask = max( mask,draw_point(pixel, mask) );
    COLOR =  mix(color, color_1, 1.0-mask);
    
}
