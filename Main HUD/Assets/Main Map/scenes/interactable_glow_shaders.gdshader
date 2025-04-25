shader_type canvas_item;

uniform vec4 line_color = vec4(1.0, 1.0, 0.0, 1.0); // Yellow glow color
uniform float line_thickness = 10.0; // Glow width
uniform bool glow_enabled = false; // Controlled by GDScript

const vec2 OFFSETS[8] = {
	vec2(-1, -1), vec2(-1, 0), vec2(-1, 1),
	vec2(0, -1),              vec2(0, 1),
	vec2(1, -1),  vec2(1, 0), vec2(1, 1)
};

void fragment() {
	vec4 base_color = texture(TEXTURE, UV);

	if (glow_enabled) {
		vec2 size = TEXTURE_PIXEL_SIZE * line_thickness;
		float outline = 0.0;

		for (int i = 0; i < OFFSETS.length(); i++) {
			outline += texture(TEXTURE, UV + size * OFFSETS[i]).a;
		}
		outline = min(outline, 1.0);

		COLOR = mix(base_color, line_color, outline - base_color.a);
	} else {
		COLOR = base_color;
	}
}
