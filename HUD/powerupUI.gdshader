shader_type canvas_item;

// Glow color
uniform vec4 glow_color : source_color = vec4(1.0, 0.5, 0.2, 1.0);

// Thickness of the border
uniform float thickness = 0.025;

// Soft fade of the border edge
uniform float softness = 0.012;

// Timer intensity (goes from 1 → 0 over time)
uniform float intensity : hint_range(0.0, 1.0) = 1.0;

// Adds wavy/fading style
uniform float pulse_speed = 3.0;

void fragment() {
    vec2 uv = UV;

    // Distance from nearest edge (border logic)
    float d = min(min(uv.x, 1.0 - uv.x), min(uv.y, 1.0 - uv.y));

    // Core border band
    float border = smoothstep(thickness + softness, thickness, d);

    // Fade away from middle outward
    float radial_fade = 1.0 - length(uv - vec2(0.5));

    // Add stylish pulsation
    float pulse = 0.5 + 0.5 * sin(TIME * pulse_speed);

    // Final alpha combines everything
    float alpha = border * intensity * radial_fade * pulse;

    COLOR = vec4(glow_color.rgb, glow_color.a * alpha);
}
