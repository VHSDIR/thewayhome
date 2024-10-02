shader_type canvas_item;
uniform float blur_radius : hint_range(1.0, 20.0) = 5.0;
uniform sampler2D source_texture;
void fragment() {
    vec2 uv = FRAGCOORD.xy / SCREEN_PIXEL_SIZE;
    vec4 color = vec4(0.0);
    float total = 0.0;
    for (float x = -blur_radius; x <= blur_radius; x++) {
        for (float y = -blur_radius; y <= blur_radius; y++) {
            vec2 offset = vec2(x, y) * SCREEN_PIXEL_SIZE;
            color += texture(source_texture, uv + offset);
            total += 1.0;
        }
    }
    color /= total;
    COLOR = color;
}
