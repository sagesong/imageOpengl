

varying lowp vec2 outputTexture;
uniform sampler2D textureSam;
precision lowp float;

void main()
{
    gl_FragColor = texture2D(textureSam,outputTexture);
//    gl_FragColor = vec4(0.0,1.0,0.0,1.0);
}