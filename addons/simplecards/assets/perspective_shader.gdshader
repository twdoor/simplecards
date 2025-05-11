shader_type canvas_item;

// Camera FOV
uniform float fov : hint_range(1, 179) = 90;
uniform bool cull_back = true;
uniform float y_rot : hint_range(-90, 90) = 0.0; // Limitado a ±30 grados
uniform float x_rot : hint_range(-30, 30) = 0.0; // Limitado a ±30 grados
uniform float inset : hint_range(0, 1) = 0.0;

varying flat vec2 o;
varying vec3 p;

void vertex() {
    // Limitar los valores dentro del shader por seguridad
    float limited_y_rot = clamp(y_rot, -90.0, 90.0);
    float limited_x_rot = clamp(x_rot, -30.0, 30.0);

    float sin_b = sin(limited_y_rot / 180.0 * PI);
    float cos_b = cos(limited_y_rot / 180.0 * PI);
    float sin_c = sin(limited_x_rot / 180.0 * PI);
    float cos_c = cos(limited_x_rot / 180.0 * PI);

    mat3 inv_rot_mat;
    inv_rot_mat[0][0] = cos_b;
    inv_rot_mat[0][1] = 0.0;
    inv_rot_mat[0][2] = -sin_b;

    inv_rot_mat[1][0] = sin_b * sin_c;
    inv_rot_mat[1][1] = cos_c;
    inv_rot_mat[1][2] = cos_b * sin_c;

    inv_rot_mat[2][0] = sin_b * cos_c;
    inv_rot_mat[2][1] = -sin_c;
    inv_rot_mat[2][2] = cos_b * cos_c;

    float t = tan(fov / 360.0 * PI);
    p = inv_rot_mat * vec3((UV - 0.5), 0.5 / t);
    float v = (0.5 / t) + 0.5;
    p.xy *= v * inv_rot_mat[2].z;
    o = v * inv_rot_mat[2].xy;

    VERTEX += (UV - 0.5) / TEXTURE_PIXEL_SIZE * t * (1.0 - inset);
}

void fragment() {
    if (cull_back && p.z <= 0.0) discard;
    vec2 uv = (p.xy / p.z).xy - o;
    COLOR = texture(TEXTURE, uv + 0.5);
    COLOR.a *= step(max(abs(uv.x), abs(uv.y)), 0.5);
}