for(var _i=0;_i<array_length(ship_sprites);++_i) if(sprite_exists(ship_sprites[_i])) sprite_delete(ship_sprites[_i]);

if(bgm_instance!=-1) audio_stop_sound(bgm_instance);

reset_camera();
if(view_camera[0]==world_camera) view_camera[0]=-1;
camera_destroy(world_camera);
