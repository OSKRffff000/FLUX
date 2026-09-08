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
const bonuses = JSON.parse(manager.match(/var _bonuses = (.*);/)[1]);
ctx.branches = bonuses.map(values => ({spent:0,nodes:values.map((bonus,n)=>({bonus,cost:n+1,requires:n-1,purchased:false}))}));
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
assert(Math.abs(ctx.stats.damage-(1+bonuses[0].reduce((a,b)=>a+b,0))*1.3)<1e-9,'Nodriza duplica el bono de mascota');
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
