/*****************************************************************************\

segment_atlas_common.glsl
Author: Forrester Cole (fcole@cs.princeton.edu)
Copyright (c) 2009 Forrester Cole

Helper functions for the various segment atlas shader programs.

libnpr is distributed under the terms of the GNU General Public License.
See the COPYING file for details.

\*****************************************************************************/

#define M_2PI 6.28318531

// Converting from linear indices to 2D coordinates and back:

float coordinateToIndex( vec2 coord, float buf_size )
{
    vec2 floor_coord = floor(coord);
    return floor_coord.x + floor_coord.y*buf_size;
}

vec2 indexToCoordinate( float index, float buf_size )
{
    return vec2(mod(index, buf_size), floor(index / buf_size) );
}

// Packing and unpacking values in the segment atlas offset texture:

float unpackNumSamples(vec4 offset_texel)
{
    return offset_texel.b;
}

float unpackArcLength(vec4 offset_texel)
{
    return offset_texel.a;
}

float unpackSampleOffset(vec4 offset_texel)
{
    return offset_texel.r;
}

float unpackArcLengthOffset(vec4 offset_texel)
{
    return offset_texel.g;
}

vec4 packOffsetTexel(float num_samples, float arc_length)
{
    return vec4(num_samples, arc_length, num_samples, arc_length);
}

vec4 packOffsetTexel(float num_samples, float arc_length,
                     float num_samples_offset, float arc_length_offset)
{
    return vec4(num_samples_offset, arc_length_offset, num_samples, arc_length);
}

// Packing and unpacking values in the 3D vertex positions:

float unpackPathStart(vec4 texel)
{
    return texel.r;
}

float unpackPathEnd(vec4 texel)
{
    return texel.g;
}

float unpackPathLength(vec4 texel)
{
    return texel.b;
}

// Projecting and unprojecting:

vec2 clipToWindow(sampler2DRect clip_positions, vec4 viewport, vec2 coordinate)
{
    vec4 clip = texture2DRect(clip_positions, coordinate);
    vec3 post_div = clip.xyz / clip.w;
    return (post_div.xy + vec2(1.0,1.0)) * 0.5 * viewport.zw;
}

vec2 clipToWindow(vec4 clip, vec4 viewport)
{
    vec3 post_div = clip.xyz / clip.w;
    return (post_div.xy + vec2(1.0,1.0)) * 0.5 * viewport.zw;
}

vec3 clipToWindow(vec4 clip, vec4 viewport, vec2 depthRange)
{
    vec3 post_div = clip.xyz / clip.w;
    vec3 clipPos;
    clipPos.xy = (post_div.xy + vec2(1.0,1.0)) * 0.5 * viewport.zw;
    clipPos.z  = (depthRange[1] - depthRange[0])/2.0 * post_div.z + (depthRange[1] + depthRange[0])/2.0;
    return clipPos;
}

// Path id encoding and decoding.

bool idEqualGreaterThan( vec3 a, vec3 b )
{
    float ida = a.b * 256.0 * 256.0 + a.g * 256.0 + a.r;
    float idb = b.b * 256.0 * 256.0 + b.g * 256.0 + b.r;
    const float small = 0.001;
    return ida - idb > -small;
}

bool idsEqual( vec3 a, vec3 b )
{
    float ida = a.b * 256.0 * 256.0 + a.g * 256.0 + a.r;
    float idb = b.b * 256.0 * 256.0 + b.g * 256.0 + b.r;
    const float small = 0.001;
    return abs(ida - idb) < small;
}

vec3 idToColor( float id )
{
    id = id + 1.0;
    float blue = floor(id / (256.0 * 256.0));
    float green = floor(id / 256.0) - blue * 256.0;
    float red = id - green * 256.0 - blue * 256.0 * 256.0;
    return vec3(red, green, blue) / 255.0;
}


