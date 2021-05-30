shader_type canvas_item;

uniform float Distance = 0.2;
uniform float Speed = 6.0;

void vertex() {
    VERTEX.x += sin(TIME*Speed)*Distance; // offset vertex x by sine function on time elapsed
}