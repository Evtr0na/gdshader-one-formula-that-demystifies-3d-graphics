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
uniform float line_width;

float segment_distance (vec2 a,vec2 b ,vec2 p){
    vec2 ap = p - a;
    vec2 ab = b - a;
    float h = clamp(dot(ap, ab)/max( dot(ab,ab) ,0.00001), 0.0, 1.0);
    return length(ap - ab*h);
}

//-----------------------------------------------------------------
//-- Draw Line
//-----------------------------------------------------------------

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
    
    mask = max(mask,draw_line(points[0], points[1], pixel));    
    mask = max(mask,draw_line(points[1], points[2], pixel));    
    mask = max(mask,draw_line(points[2], points[3], pixel));    
    mask = max(mask,draw_line(points[3], points[0], pixel));    
    
    mask = max(mask,draw_line(points[4], points[5], pixel));    
    mask = max(mask,draw_line(points[5], points[6], pixel));    
    mask = max(mask,draw_line(points[6], points[7], pixel));    
    mask = max(mask,draw_line(points[7], points[4], pixel));    
    
    
    mask = max(mask,draw_line(points[4], points[0], pixel));    
    mask = max(mask,draw_line(points[5], points[1], pixel));    
    mask = max(mask,draw_line(points[6], points[2], pixel));    
    mask = max(mask,draw_line(points[7], points[3], pixel));    
    
    mask  = max(mask, draw_point(pixel,mask) );
    COLOR = mix(color_1,color,mask);
    
}
