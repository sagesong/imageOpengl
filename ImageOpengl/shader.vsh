
attribute vec4 vertexCoord;
attribute vec2 textureCoord;

varying lowp vec2 outputTexture;

void main()
{
    gl_Position = vertexCoord;
    outputTexture = textureCoord;
}