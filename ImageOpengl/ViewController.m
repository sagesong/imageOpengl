//
//  ViewController.m
//  ImageOpengl
//
//  Created by Lightning on 15/9/16.
//  Copyright (c) 2015年 Lightning. All rights reserved.
//

#import "ViewController.h"
#import <OpenGLES/gltypes.h>

enum {
    vertexShader,
    fragmentShader
};

enum {
    vertexCoord,
    textureCoord,
    numOfAttribute
};

enum {
    textureUniform,
    NumUniform
};

GLint Uiforms[NumUniform];


@interface ViewController ()
{
    GLuint _frameBuffer;
    GLuint _renderBuffer;
    GLint _program;
    EAGLContext *_context;
}


@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor purpleColor];
    [self setupGL];
    [self loadShaders];
    [self prepareData];
}

- (void)loadShaders
{
    GLuint vertex,fragment;
    NSString *vertexPath = [[NSBundle mainBundle] pathForResource:@"shader.vsh" ofType:nil];
    const char *path = [[NSString stringWithContentsOfFile:vertexPath encoding:NSUTF8StringEncoding error:nil] UTF8String];
    if (!path) {
        NSLog(@"Failed to load vertex shader");
    }
    vertex = glCreateShader(GL_VERTEX_SHADER);
    glShaderSource(vertex, 1, &path, NULL);
    glCompileShader(vertex);
    
#if defined(DEBUG)
    GLint logLength;
    glGetShaderiv(vertex, GL_INFO_LOG_LENGTH, &logLength);
    if (logLength > 0) {
        GLchar *log = (GLchar *)malloc(logLength);
        glGetShaderInfoLog(vertex, logLength, &logLength, log);
        NSLog(@"Shader compile log:\n%s", log);
        free(log);
    }
#endif
    
    NSString *fragmentPath = [[NSBundle mainBundle] pathForResource:@"shader.fsh" ofType:nil];
    const char *fragmentP = [[NSString stringWithContentsOfFile:fragmentPath encoding:NSUTF8StringEncoding error:nil] UTF8String];
    fragment = glCreateShader(GL_FRAGMENT_SHADER);
    glShaderSource(fragment, 1, &fragmentP, NULL);
    glCompileShader(fragment);
    
#if defined(DEBUG)
    GLint logLength1;
    glGetShaderiv(fragment, GL_INFO_LOG_LENGTH, &logLength1);
    if (logLength1 > 0) {
        GLchar *log = (GLchar *)malloc(logLength1);
        glGetShaderInfoLog(fragment, logLength1, &logLength1, log);
        NSLog(@"Shader compile log:\n%s", log);
        free(log);
    }
#endif
    
    GLint program;
    program = glCreateProgram();
    _program = program;
    
    glBindAttribLocation(program, vertexCoord, "vertexCoord");
//    glBindAttribLocation(program, textureCoord, "textureCoord");
//    
//    Uiforms[textureUniform] = glGetUniformLocation(program, "textureSam");
    
    glAttachShader(program, vertex);
    glAttachShader(program, fragment);
    
    [self linkProgram:program];
    [self validateProgram:program];
    glClearColor(0.0, 0.0, 0.0, 0.0);

}

- (BOOL)linkProgram:(GLuint)prog
{
    GLint status;
    glLinkProgram(prog);
    
#if defined(DEBUG)
    GLint logLength;
    glGetProgramiv(prog, GL_INFO_LOG_LENGTH, &logLength);
    if (logLength > 0) {
        GLchar *log = (GLchar *)malloc(logLength);
        glGetProgramInfoLog(prog, logLength, &logLength, log);
        NSLog(@"Program link log:\n%s", log);
        free(log);
    }
#endif
    
    glGetProgramiv(prog, GL_LINK_STATUS, &status);
    if (status == 0) {
        return NO;
    }
    
    return YES;
}

- (BOOL)validateProgram:(GLuint)prog
{
    GLint logLength, status;
    
    glValidateProgram(prog);
    glGetProgramiv(prog, GL_INFO_LOG_LENGTH, &logLength);
    if (logLength > 0) {
        GLchar *log = (GLchar *)malloc(logLength);
        glGetProgramInfoLog(prog, logLength, &logLength, log);
        NSLog(@"Program validate log:\n%s", log);
        free(log);
    }
    
    glGetProgramiv(prog, GL_VALIDATE_STATUS, &status);
    if (status == 0) {
        return NO;
    }
    
    return YES;
}

- (void)setupGL
{
    
    CAEAGLLayer *layer = (CAEAGLLayer *)self.view.layer;
    layer.opaque = TRUE;
    layer.drawableProperties = @{kEAGLDrawablePropertyColorFormat : kEAGLColorFormatRGBA8 ,kEAGLDrawablePropertyRetainedBacking : @(NO)};
    EAGLContext *context = [[EAGLContext alloc] initWithAPI:kEAGLRenderingAPIOpenGLES2];
    [EAGLContext setCurrentContext:context];
    _context = context;
    glDisable(GL_DEPTH_TEST);

    glGenFramebuffers(1, &_frameBuffer);
    glBindFramebuffer(GL_FRAMEBUFFER, _frameBuffer);
    
    glGenRenderbuffers(1, &_renderBuffer);
    glBindRenderbuffer(GL_RENDERBUFFER, _renderBuffer);
    [context renderbufferStorage:GL_RENDERBUFFER fromDrawable:layer];

    glFramebufferRenderbuffer(GL_FRAMEBUFFER, GL_COLOR_ATTACHMENT0, GL_RENDERBUFFER, _renderBuffer);
    if (glCheckFramebufferStatus(GL_FRAMEBUFFER) != GL_FRAMEBUFFER_COMPLETE) {
        NSLog(@"Failed to make complete framebuffer object %x", glCheckFramebufferStatus(GL_FRAMEBUFFER));
    }
    
    GLint width,height;
    glGetRenderbufferParameteriv(GL_RENDERBUFFER, GL_RENDERBUFFER_WIDTH, &width);
    glGetRenderbufferParameteriv(GL_RENDERBUFFER, GL_RENDERBUFFER_HEIGHT, &height);
    
    NSLog(@"width-%d height-%d--%@---%@",width,height,NSStringFromCGRect(self.view.layer.bounds),NSStringFromClass([self.view class]));
}

- (void)prepareData
{
    GLfloat vertex[] = {
      -0.5f,0.5f,0.0f,-0.5f,-0.5f,-0.0f,0.5f,-0.5f,0.0f
    };
    GLuint vertexBuffer;
//    glGenBuffers(1, &vertexBuffer);
//    glBindBuffer(GL_ARRAY_BUFFER, vertexBuffer);
//    glGenVertexArraysOES(1, &vertexBuffer);
//    glBindVertexArrayOES(vertexBuffer);
//    glBindBuffer(GL_ARRAY_BUFFER, vertexCoord);
    glClear(GL_COLOR_BUFFER_BIT);
    glViewport(0, 0, 375, 667);
    glUseProgram(_program);

    glVertexAttribPointer(vertexCoord, 3, GL_FLOAT, GL_FALSE, 0, vertex);
    glEnableVertexAttribArray(vertexCoord);
    GLfloat texture[] = {
        0.0f,1.0f,0.0f,0.0f,1.0f,0.0f
    };
    /*
    UIImage *image = [UIImage imageNamed:@"leaves.gif"];
    size_t width = CGImageGetWidth(image.CGImage);
    size_t height = CGImageGetHeight(image.CGImage);
    
    GLubyte *bytes = (GLubyte *)malloc(width * height * 4);
    CGColorSpaceRef space = CGColorSpaceCreateDeviceRGB();
    
    CGContextRef context = CGBitmapContextCreate(bytes, width, height, 8, width * 4, space, kCGImageAlphaPremultipliedLast | kCGBitmapByteOrder32Big);
    CGContextDrawImage(context, CGRectMake(0, 0, width, height), image.CGImage);
    CGContextRelease(context);
    CFRelease(space);
    
    //    GLuint textureBuffer;
//    glGenTextures(1, &textureBuffer);
//    glBindTexture(GL_TEXTURE_2D, textureBuffer);
//    glBindBuffer(GL_ARRAY_BUFFER, textureCoord);
    glEnableVertexAttribArray(textureCoord);
    glVertexAttribPointer(textureCoord, 2, GL_FLOAT, GL_FALSE, 0, texture);
    glActiveTexture(GL_TEXTURE0);
    glTexImage2D(GL_TEXTURE_2D, 0, GL_RGBA, (int)width, (int)height, 0, GL_RGBA, 0, bytes);
    
    glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MIN_FILTER, GL_LINEAR);
    glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MAG_FILTER, GL_LINEAR);
    glTexParameterf(GL_TEXTURE_2D, GL_TEXTURE_WRAP_S, GL_CLAMP_TO_EDGE);
    glTexParameterf(GL_TEXTURE_2D, GL_TEXTURE_WRAP_T, GL_CLAMP_TO_EDGE);
    
    glUniform1i(Uiforms[textureUniform], 0);
    
    */
    glDrawArrays(GL_TRIANGLES, 0, 3);
    
    [_context presentRenderbuffer:_renderBuffer];
    
}



@end
