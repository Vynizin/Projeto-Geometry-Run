shader_type canvas_item;

void fragment() {
    vec2 uv = UV;
    COLOR = mix(
        vec4(0.1, 0.1, 0.15, 1.0),
        vec4(0.15, 0.05, 0.2, 1.0),
        uv.y
    );
}

//void light() {
//	// Called for every pixel for every light affecting the CanvasItem.
//	// Uncomment to replace the default light processing function with this one.
//}
