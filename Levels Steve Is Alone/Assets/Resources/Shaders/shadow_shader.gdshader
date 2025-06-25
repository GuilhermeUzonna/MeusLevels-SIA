shader_type canvas_item;

uniform sampler2D screen_texture : hint_screen_texture, repeat_disable, filter_linear_mipmap;

uniform vec2 pixel_offset;
uniform vec4 shadow_color : source_color;

void fragment() {
	vec4 current_pixel = texture(screen_texture, SCREEN_UV);
	vec4 target_pixel = texture(screen_texture, SCREEN_UV + SCREEN_PIXEL_SIZE * pixel_offset);
	if(target_pixel.rgb == vec3(1.0, 1.0, 1.0) && current_pixel.rgb != vec3(1.0, 1.0, 1.0)){
		COLOR = shadow_color;
	}else{
		COLOR = vec4(0.0, 0.0, 0.0, 0.0);
	}
}
//vec2(SCREEN_UV.x + SCREEN_PIXEL_SIZE.x * pixel_offset_x, SCREEN_UV.y - SCREEN_PIXEL_SIZE.y * pixel_offset_y)