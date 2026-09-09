varying vec2 v_vTexcoord;
varying vec4 v_vColour;
void main() {
    vec4 colour=v_vColour*texture2D(gm_BaseTexture,v_vTexcoord);
    float gray=dot(colour.rgb,vec3(0.299,0.587,0.114));
    gl_FragColor=vec4(vec3(gray),colour.a);
}
