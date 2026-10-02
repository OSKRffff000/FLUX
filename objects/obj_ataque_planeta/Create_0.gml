heading=0; velocity=120; radius=9; tint=make_color_rgb(255,0,150);
prev_x=x; prev_y=y; trail_timer=0;

image_blend=tint;

telegraph=0;warning_duration=0.55;age=0;max_life=14;
trail_points=[];trail_length=14;trail_width=1;glow_scale=random_range(0.85,1.22);
pulse_phase=random(2*pi);rhythmic=false;cull_margin=100;
warning_x=x;warning_y=y;
