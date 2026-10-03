shader_type spatial;
// World-space grid for blockout geometry, so scale and motion are readable
// without textures. Projects onto the plane facing the surface normal.

uniform vec3 base_color : source_color = vec3(0.42, 0.45, 0.48);
uniform vec3 line_color : source_color = vec3(0.28, 0.3, 0.33);
uniform float cell_size = 1.0;
uniform float line_width : hint_range(0.0, 0.5) = 0.03;
uniform float roughness_value : hint_range(0.0, 1.0) = 0.85;

varying vec3 world_position;
varying vec3 world_normal;

void vertex() {
	world_position = (MODEL_MATRIX * vec4(VERTEX, 1.0)).xyz;
	world_normal = normalize((MODEL_MATRIX * vec4(NORMAL, 0.0)).xyz);
}

void fragment() {
	vec3 n = abs(world_normal);
	vec3 p = world_position / cell_size;
	vec2 uv = n.y >= max(n.x, n.z) ? p.xz : (n.x >= n.z ? p.zy : p.xy);
	vec2 dist = abs(fract(uv - 0.5) - 0.5);
	vec2 aa = fwidth(uv);
	vec2 lines = 1.0 - smoothstep(vec2(line_width) - aa, vec2(line_width) + aa, dist);
	ALBEDO = mix(base_color, line_color, max(lines.x, lines.y));
	ROUGHNESS = roughness_value;
}
