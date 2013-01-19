/*****************************************************************************\

stroke_render_spine.frag
Authors:
    Pierre Benard (pierre.benard@laposte.net),
    Forrester Cole (fcole@csail.mit.edu),
    Jingwan Lu (jingwanl@princeton.edu)
Copyright (c) 2012 Pierre Benard, Forrester Cole, Jingwan Lu
Copyright (c) 2009 Forrester Cole

libnpr is distributed under the terms of the GNU General Public License.
See the COPYING file for details.

\*****************************************************************************/

uniform mat4 inverse_projection;
uniform vec4 viewport;

uniform float check_at_spine;

varying vec4 spine_position;
varying vec2 tex_coord;

void main(void)
{
    vec3 spine_window = clipToWindow(spine_position, viewport);
    vec4 camera_pos_w = inverse_projection * spine_position;
    vec3 camera_pos = camera_pos_w.xyz / camera_pos_w.w;

    vec3 test_position = check_at_spine * spine_window + 
                         (1.0 - check_at_spine) * gl_FragCoord.xyz;
    float visibility = 1.0;
    float focus = 1.0;

    vec4 final_color = computePenColor(visibility, focus, vec3(tex_coord,0.0));
    
    gl_FragColor = final_color;
}
