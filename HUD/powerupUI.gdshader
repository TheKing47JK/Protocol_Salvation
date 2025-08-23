shader_type canvas_item;

// Glow color
uniform vec4 glow_color : source_color = vec4(1.0, 0.5, 0.2, 1.0);

// Thickness of the border
uniform float thickness = 0.025;

// Soft fade of the border edge
uniform float softness = 0.012;

// Timer intensity (goes from 1 → 0 over time)
uniform float intensity : hint_range(0.0, 1.0) = 1.0;

// Minimum intensity value for the glow (keeps it visible)
uniform float min_intensity : hint_range(0.0, 1.0) = 0.2; 

// Base pulse speed (slow at the start)
uniform float base_pulse_speed = 2.0;

// Max pulse speed (fast at the end)
uniform float max_pulse_speed = 10.0;

// Custom elapsed time uniform for pulsation control
uniform float elapsed_time : hint_range(0.0, 1000.0) = 0.0;

void fragment() {
    vec2 uv = UV;

    // Distance from nearest edge
    float d = min(min(uv.x, 1.0 - uv.x), min(uv.y, 1.0 - uv.y));

    // Core border band
    float border = smoothstep(thickness + softness, thickness, d);

    // Fade away from center outward
    float radial_fade = 1.0 - length(uv - vec2(0.5));

    // Pulse speed increases as intensity decreases
    float pulse_speed = mix(base_pulse_speed, max_pulse_speed, 1.0 - intensity);

    // Pulsation, now using elapsed_time
    float pulse = 0.5 + 0.5 * sin(elapsed_time * pulse_speed);

    // The final alpha should never go below glow_color.a * min_intensity
    // We linearly interpolate between min_intensity and 1.0 based on _current_intensity
    float effective_intensity = mix(min_intensity, 1.0, intensity); 

    // Final alpha
    float alpha = border * effective_intensity * radial_fade * pulse; 

    COLOR = vec4(glow_color.rgb, glow_color.a * alpha);
}