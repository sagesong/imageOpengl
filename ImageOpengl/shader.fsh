

varying lowp vec2 outputTexture;
uniform sampler2D textureSam;

void main()
{
    gl_FragColor = texture2D(textureSam,outputTexture);
}