shader_type canvas_item;

uniform float strength: hint_range(0.0, 5) = 0.5;

uniform sampler2D SCREEN : hint_screen_texture, filter_linear_mipmap;

void fragment(){
    vec4 color = texture(SCREEN, SCREEN_UV, strength);
    COLOR = color;
}

//void light() {
	// Called for every pixel for every light affecting the CanvasItem.
	// Uncomment to replace the default light processing function with this one.
//}
