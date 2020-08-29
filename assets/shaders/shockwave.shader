shader_type canvas_item;

uniform vec2 center;
uniform float force : hint_range(-0.5, 0.5) = 0.1;
uniform float size : hint_range(0, 2.0) = 0.5;
uniform float thickness : hint_range(0.0, 0.5) = 0.1;

void fragment() {
	float screenRatio = SCREEN_PIXEL_SIZE.x / SCREEN_PIXEL_SIZE.y;
	vec2 scaledUV = (SCREEN_UV - vec2(0.5, 0.0)) / vec2(screenRatio, 1.0) + vec2(0.5, 0.0);
	float mask = (1.0 - smoothstep(size - 0.1, size, length(scaledUV - center))) *
			smoothstep(size - thickness - 0.1, size - thickness, length(scaledUV - center));
	vec2 displacement = normalize(SCREEN_UV - center) * force * mask;
	//COLOR = texture(SCREEN_TEXTURE, SCREEN_UV - displacement);
	float offset = 0.2;
	COLOR = vec4(
		texture(SCREEN_TEXTURE, SCREEN_UV + displacement).r,
		texture(SCREEN_TEXTURE, SCREEN_UV).g,
		texture(SCREEN_TEXTURE, SCREEN_UV - displacement).b,
		1.0
	);
	//COLOR.rgb = vec3(mask);
}