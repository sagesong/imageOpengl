
attribute vec4 vertexCoord;
attribute vec2 textureCoord;

uniform float transformMatrix;

varying lowp vec2 outputTexture;

void main()
{
    mat4 matrix = mat4(
                       1.0,0.0,0.0,0.0,
                       0.0,1.0,0.0,transformMatrix,
                       0.0,0.0,1.0,0.0,
                       0.0,0.0,0.0,1.0
    );
    gl_Position = vertexCoord * matrix;
    outputTexture = textureCoord;
}