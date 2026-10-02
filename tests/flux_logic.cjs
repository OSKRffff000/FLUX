// Ejecuta funciones puras y métodos de progresión de sintaxis compartida GML/JS.
// No sustituye la compilación ni la prueba de eventos en GameMaker.
const fs = require('node:fs');
const vm = require('node:vm');
const assert = require('node:assert/strict');
function extract(source, marker) {
  const start = source.indexOf(marker);
  assert(start >= 0, marker);
  const brace = source.indexOf('{', start);
  let depth = 1, end = brace + 1;
  while (depth) {
    if (source[end] === '{') depth++;
    if (source[end] === '}') depth--;
    end++;
  }
  return source.slice(start, end);
}
const core = fs.readFileSync('scripts/flux_core/flux_core.gml', 'utf8');
const manager = fs.readFileSync('objects/obj_game_manager/Create_0.gml', 'utf8');
const ctx = vm.createContext({
  max: Math.max, min: Math.min, abs: Math.abs,
  clamp: (n,a,b) => Math.max(a, Math.min(b,n)),
  point_distance: (a,b,c,d) => Math.hypot(c-a,d-b),
  array_create: (n,v) => Array(n).fill(v),
  skill_points:100, spent_points:0, equipped_pet:-1,
  evolution:-1, evolution_pending:-1, evolution_deferred:false,
  state:'tree', save_progress: () => {}, pets: [],
});
vm.runInContext(extract(core, 'function flux_segment_hit') + '\n' + extract(core, 'function flux_segments_near'), ctx);
assert(ctx.flux_segment_hit(-100,0,100,0,8), 'Proyectil rápido cruza la nave');
assert(!ctx.flux_segment_hit(-100,9,100,9,8), 'Paso cercano sin impacto');
assert(ctx.flux_segment_hit(0,0,0,0,8), 'Cuerpo sin movimiento');
assert(ctx.flux_segments_near(-10,0,10,0,0,-50,0,50,1), 'Cruce de láser entre frames');
assert(!ctx.flux_segments_near(-10,0,10,0,30,-50,30,50,1), 'Láser alejado');
ctx.array_length = a => a.length;
ctx.array_push = (a,v) => a.push(v);
ctx.variable_struct_get_names = Object.keys;
ctx.variable_struct_get = (s,k) => s[k];
ctx.variable_struct_set = (s,k,v) => { s[k]=v; };
ctx.sqrt=Math.sqrt;
ctx.global={};
const catalogSource=fs.readFileSync('scripts/flux_upgrades/flux_upgrades.gml','utf8');
vm.runInContext(extract(catalogSource,'function flux_upgrade_catalog'),ctx);
ctx.branches=ctx.flux_upgrade_catalog();
const expected=JSON.parse(fs.readFileSync('tests/flux_upgrade_catalog.json','utf8'));
assert.equal(ctx.branches.length,5);
for(let b=0;b<5;b++) {
  assert.equal(ctx.branches[b].nodes.length,10);
  for(let n=0;n<10;n++) {
    const node=ctx.branches[b].nodes[n];
    assert.equal(node.name,expected[b][1][n][0]);
    assert.equal(node.description,expected[b][1][n][1]);
    assert.equal(node.cost,n+1);
  }
}
for (const name of ['rebuild_stats','evaluate_evolution','buy_node']) vm.runInContext(extract(manager, name+' = function'), ctx);
ctx.rebuild_stats();
assert.equal(ctx.buy_node(0,1),false, 'Rechaza salto de requisito');
for(let n=0;n<5;n++) assert(ctx.buy_node(0,n));
assert.equal(ctx.spent_points,15);
assert.equal(ctx.evolution,-1,'Ofrecer nunca equivale a aceptar');
assert.equal(ctx.state,'evolution');
assert.equal(ctx.evolution_pending,0);
ctx.state='tree';ctx.evolution_deferred=true;
assert(ctx.buy_node(0,5));
assert.equal(ctx.state,'tree','Posponer evita nuevas ventanas automáticas');
ctx.evaluate_evolution(true);
assert.equal(ctx.state,'evolution','Se puede reabrir desde el árbol');
ctx.evolution=0;ctx.rebuild_stats();
assert.equal(ctx.evolution,0,'Recalcular conserva la elección');
const balance=ctx.skill_points;
assert.equal(ctx.buy_node(0,5),false);
assert.equal(ctx.skill_points,balance,'Compra repetida no cobra');
ctx.skill_points=0;
assert.equal(ctx.buy_node(1,0),false,'No permite saldo negativo');
ctx.evolution=2;ctx.equipped_pet=0;ctx.pets=[{stat:'damage',bonus:0.15}];
ctx.rebuild_stats();
assert(Math.abs(ctx.stats.damage-2.4*1.3)<1e-9,'Nodriza duplica el bono de mascota');
assert.equal(ctx.global.mejoras_adquiridas,6);
assert.equal(ctx.branches[0].nodes[6].state,'disponible');
assert.equal(ctx.branches[0].nodes[7].state,'bloqueado');
// Todos los topes son totales, nunca la suma de los porcentajes previos.
ctx.equipped_pet=-1;
for(const branch of ctx.branches) for(const node of branch.nodes) node.purchased=true;
ctx.rebuild_stats();
assert.equal(ctx.upgrades_bought,50);assert.equal(ctx.spent_points,275);
assert.equal(ctx.stats.damage,5);assert(Math.abs(ctx.stats.rate-80)<1e-9);
assert.equal(ctx.stats.projectile_scale,2);assert.equal(ctx.stats.projectile_speed,2275);
assert(Math.abs(ctx.stats.angular_speed-92.3)<1e-9);
assert.equal(ctx.stats.crit,1);assert.equal(ctx.stats.crit_multiplier,4);
assert.equal(ctx.stats.duration,21);assert.equal(ctx.stats.buff_spawn_multiplier,3);
assert.equal(ctx.stats.turn_iframes,0.5);assert.equal(ctx.stats.micro_jump,8);
assert.equal(ctx.stats.double_buff_chance,0.05);assert(ctx.stats.buff_double_points);
// Reset y reconstrucción son idempotentes y restauran estados de bloqueo.
for(const branch of ctx.branches) for(const node of branch.nodes) node.purchased=false;
ctx.rebuild_stats();ctx.rebuild_stats();
assert.equal(ctx.stats.damage,1);assert.equal(ctx.stats.rate,4);assert.equal(ctx.upgrades_bought,0);
assert.equal(ctx.branches[0].nodes[0].state,'disponible');assert.equal(ctx.branches[0].nodes[1].state,'bloqueado');
console.log('OK: colisión barrida, láseres, prerrequisitos, umbral, posponer, elección persistente, saldo y mascota.');
ctx.pi=Math.PI;
ctx.lerp=(a,b,t)=>a+(b-a)*t;
ctx.ceil=Math.ceil;
ctx.lengthdir_x=(r,a)=>r*Math.cos(a*Math.PI/180);
ctx.lengthdir_y=(r,a)=>-r*Math.sin(a*Math.PI/180);
ctx.global={flux:{orbit_radius:245}};
vm.runInContext(extract(core,'function flux_sweep_hit'),ctx);
const sx=ctx.lengthdir_x(245,10),sy=ctx.lengthdir_y(245,10);
const ship={prev_x:sx,prev_y:sy,x:sx,y:sy,hit_radius:8};
assert(ctx.flux_sweep_hit({x:0,y:0,prev_heading:0,sweep_delta:20,beam_length:900,beam_width:12},ship),'Barrido alcanza nave aunque ambos rayos extremos no la toquen');
assert(!ctx.flux_sweep_hit({x:0,y:0,prev_heading:40,sweep_delta:20,beam_length:900,beam_width:12},ship),'Barrido lejano no mata');
console.log('OK: barrido angular entre frames y zona segura.');

// Retícula: 50 centros únicos, vecinos sucesivos pegados y hitbox hexagonal.
vm.runInContext(extract(catalogSource,'function flux_hex_contains'),ctx);
assert(ctx.flux_hex_contains(0,0,52));
assert(!ctx.flux_hex_contains(51,44,52));
assert(!ctx.flux_hex_contains(0,46,52));
const honey=fs.readFileSync('objects/obj_arbol_mejoras/Create_0.gml','utf8');
vm.runInContext(honey.replace(/\bmod\b/g,'%'),ctx);
assert.equal(ctx.nodes.length,50);
assert.equal(new Set(ctx.nodes.map(n=>n.wx.toFixed(5)+','+n.wy.toFixed(5))).size,50);
for(let b=0;b<5;b++) for(let n=0;n<10;n++) {
  const now=ctx.nodes[b*10+n],prev=n?ctx.nodes[b*10+n-1]:{wx:0,wy:0};
  assert(Math.abs(Math.hypot(now.wx-prev.wx,now.wy-prev.wy)-Math.sqrt(3)*52)<1e-8);
}
console.log('OK: 50 textos, topes de estadísticas, contador, reinicio, retícula y selección hexagonal.');
// Guardado real de métodos GML con un INI en memoria: nivel 10 y compatibilidad de claves.
const saved=new Map();
ctx.ini_open=()=>{};ctx.ini_close=()=>{};
ctx.ini_write_real=(section,key,value)=>saved.set(section+':'+key,value);
ctx.string=String;
ctx.global.vol_maestro=1;ctx.global.vol_musica=0.6;ctx.global.vol_sfx=0.8;
ctx.coins=17;ctx.skill_points=8;ctx.pets=[];
for(let n=0;n<10;n++) ctx.branches[4].nodes[n].purchased=true;
ctx.rebuild_stats();
vm.runInContext(extract(manager,'save_progress = function'),ctx);
ctx.save_progress();assert.equal(saved.get('tree:4_9'),true);
ctx.branches=ctx.flux_upgrade_catalog();
for(let b=0;b<5;b++) for(let n=0;n<10;n++) {
  ctx.branches[b].nodes[n].purchased=!!saved.get('tree:'+b+'_'+n) && (!n || ctx.branches[b].nodes[n-1].purchased);
}
ctx.rebuild_stats();assert.equal(ctx.upgrades_bought,10);assert.equal(ctx.stats.duration,21);
// Cadencia y control: ejecutar Step real con las APIs del motor sustituidas.
let heldLeft=false,heldRight=false,shots=0;
const shipCtx=vm.createContext({
  gm:{state:'playing',stats:{angular_speed:92.3,rate:80,turn_iframes:0.5,turn_trail:true,clean_turn:true,micro_jump:8,coast_brake:true},
      evolution:-1,center_x:360,center_y:610,orbit_radius:245},
  FluxBuff:{Frenesi:0,Bombardeo:1},
  flux_dt:()=>1/60,device_mouse_check_button:()=>false,device_mouse_x:()=>0,
  keyboard_check:k=>k===1?heldLeft:heldRight,vk_left:1,vk_right:2,mb_left:1,room_width:720,
  max:Math.max,min:Math.min,abs:Math.abs,power:Math.pow,pi:Math.PI,
  lengthdir_x:ctx.lengthdir_x,lengthdir_y:ctx.lengthdir_y,point_direction:()=>180,
  array_length:a=>a.length,array_push:(a,v)=>a.push(v),array_delete:(a,i,n)=>a.splice(i,n),
  buff_active:()=>false,instance_exists:()=>false,
  fire_bullet:()=>{shots++;},x:605,y:610,prev_x:605,prev_y:610,
  turn_immunity:0,turn_clean:false,turn_echoes:[],last_input_direction:0,
  angular_velocity:0,orbit_direction:0,orbit_angle:0,shot_timer:0,bombard_timer:0,
});
const shipStep=fs.readFileSync('objects/obj_nave/Step_0.gml','utf8').replace(/\bmod\b/g,'%').replace(/\bexit;/g,'return;');
vm.runInContext('function tick(){'+shipStep+'}',shipCtx);
for(let i=0;i<60;i++) shipCtx.tick();
assert(shots>=80 && shots<=81,'80 disparos/s incluso a 60 FPS');
assert.equal(shipCtx.orbit_angle,0,'Sin entrada inicial, nave quieta');
heldRight=true;shipCtx.tick();heldRight=false;heldLeft=true;shipCtx.tick();
assert.equal(shipCtx.turn_immunity,0.5);assert(shipCtx.turn_clean);assert.equal(shipCtx.turn_echoes.length,1);
heldLeft=false;const speedBefore=shipCtx.angular_velocity;shipCtx.tick();
assert(Math.abs(shipCtx.angular_velocity-speedBefore*0.8)<1e-9,'Frenado de 20% al soltar');
console.log('OK: persistencia de 10 niveles, cadencia alta, inversión protegida, estela y frenado.');
// Pausa: los mismos IDs y voces se restauran, sin reiniciar las entidades.
const active=new Set([101,102,103]),pausedAudio=new Set(),stoppedAudio=new Set();
const pauseCtx=vm.createContext({
  global:{pausa:false},state:'playing',paused_instances:[],paused_voices:[],
  pause_snapshot:-1,pause_world_objects:[1,2],bgm_instance:501,sfx_voices:[502],
  block_gameplay_touch:false,application_surface:-1,
  array_length:a=>a.length,array_push:(a,v)=>a.push(v),
  sprite_exists:()=>false,surface_exists:()=>false,
  instance_number:t=>t===1?2:1,
  instance_find:(t,i)=>t===1?101+i:103,
  instance_deactivate_object:id=>active.delete(id),
  instance_activate_object:id=>active.add(id),
  audio_is_playing:()=>true,
  audio_pause_sound:id=>pausedAudio.add(id),
  audio_resume_sound:id=>pausedAudio.delete(id),
  audio_stop_sound:id=>{stoppedAudio.add(id);pausedAudio.delete(id);},
});
for(const name of ['begin_pause','end_pause','resume_run'])
  vm.runInContext(extract(manager,name+'=function'),pauseCtx);
pauseCtx.begin_pause();assert(pauseCtx.global.pausa);assert.equal(pauseCtx.state,'paused');
assert.equal(active.size,0);assert.equal(pausedAudio.size,2);
pauseCtx.begin_pause();assert.equal(pauseCtx.paused_instances.length,3,'Pausar de nuevo no pierde los IDs');
pauseCtx.resume_run();assert.equal(pauseCtx.state,'playing');assert(!pauseCtx.global.pausa);
assert.equal(active.size,3);assert.equal(pausedAudio.size,0);assert(pauseCtx.block_gameplay_touch);
pauseCtx.begin_pause();pauseCtx.state='tree';pauseCtx.resume_run();
assert(pauseCtx.global.pausa,'Árbol conserva la partida detenida');
pauseCtx.state='paused';pauseCtx.resume_run();assert.equal(active.size,3);
pauseCtx.begin_pause();pauseCtx.end_pause(false);assert.equal(stoppedAudio.size,2);
console.log('OK: congelación selectiva, reanudación, árbol durante pausa y limpieza de audio.');
// Variante estrella: dos segundos de aviso, cinco activos y giro angular continuo.
const laserTest=vm.createContext({
  global:{flux:{state:'playing',attack_impact:()=>{}}},
  noone:-4,c_white:0xffffff,x:360,y:610,delta_time:100000,
  instance_exists:()=>false,instance_destroy:()=>{laserTest.destroyed=true;},
  min:Math.min,max:Math.max,lerp:(a,b,t)=>a+(b-a)*t,
  lengthdir_x:ctx.lengthdir_x,lengthdir_y:ctx.lengthdir_y,
});
vm.runInContext(fs.readFileSync('objects/obj_laser_planeta/Create_0.gml','utf8'),laserTest);
laserTest.mode='star';laserTest.life=5;laserTest.sweep_speed=12;
vm.runInContext('function tick(){'+fs.readFileSync('objects/obj_laser_planeta/Step_0.gml','utf8').replace(/\bexit;/g,'return;')+'}',laserTest);
for(let i=0;i<19;i++) laserTest.tick();
assert(laserTest.telegraph>0);assert.equal(laserTest.heading,0);
laserTest.tick();assert(laserTest.telegraph<1e-8);
for(let i=0;i<10;i++) laserTest.tick();
assert(Math.abs(laserTest.heading-12)<1e-7);
laserTest.global.flux.state='paused';const remaining=laserTest.life;laserTest.tick();assert.equal(laserTest.life,remaining);
laserTest.global.flux.state='playing';
for(let i=0;i<41;i++) laserTest.tick();
assert(laserTest.destroyed,'La variante de ocho rayos termina tras cinco segundos activos');
// El proyectil padre no avanza ni envejece durante su advertencia.
const enemyTest=vm.createContext({
 global:{flux:{state:'playing'}},x:100,y:100,make_color_rgb:()=>0xff00ff,
 random:()=>0,random_range:(a,b)=>(a+b)/2,pi:Math.PI,
 flux_world_dt:()=>1/60,max:Math.max,min:Math.min,
 array_push:(a,v)=>a.push(v),array_length:a=>a.length,array_delete:(a,i,n)=>a.splice(i,n),
 lengthdir_x:ctx.lengthdir_x,lengthdir_y:ctx.lengthdir_y,
 room_width:720,room_height:1280,flux_burst:()=>{},instance_destroy:()=>{},
});
vm.runInContext(fs.readFileSync('objects/obj_ataque_planeta/Create_0.gml','utf8'),enemyTest);
vm.runInContext('function tick(){'+fs.readFileSync('objects/obj_ataque_planeta/Step_0.gml','utf8').replace(/\bexit;/g,'return;')+'}',enemyTest);
enemyTest.telegraph=0.5;enemyTest.tick();assert.equal(enemyTest.x,100);assert.equal(enemyTest.age,0);
enemyTest.telegraph=0;enemyTest.tick();assert(enemyTest.x>100);assert.equal(enemyTest.trail_points.length,1);
console.log('OK: estrella láser 2+5 s, rotación, pausa, avisos y estelas de proyectiles.');
