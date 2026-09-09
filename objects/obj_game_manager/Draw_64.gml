draw_set_alpha(1); draw_set_color(c_white);
draw_set_halign(fa_left); draw_set_valign(fa_top);
if (state == "playing" || state == "tree" || state == "dying") exit;
draw_set_color(c_black); draw_set_alpha(0.94); draw_rectangle(0,0,720,1280,false);
draw_set_alpha(1); draw_set_color(c_white);
draw_text(30,60,"FLUX");
draw_text(30,105,"Creditos: " + string(coins) + "    Puntos disponibles: " + string(skill_points));
switch (state) {
    case "menu":
        draw_text(160,290,"Orbita. Esquiva. Sobrevive.");
        flux_button(160,440,400,80,"Jugar",true);
        flux_button(160,550,400,80,"Arbol de Mejoras",true);
        flux_button(160,660,400,80,"Tienda de Mascotas",true);
        draw_text(70,840,"Cada planeta otorga 20 creditos y 1 punto de mejora.");
        break;
    case "dead":
        draw_text(160,400,"Nave destruida");
        flux_button(160,550,400,80,"Continuar/Reintentar",true);
        flux_button(160,660,400,80,"Ir al Arbol de Mejoras",true);
        break;

    case "evolution":
        draw_text(70,260,"Evolucion disponible: " + evolution_names[evolution_pending]);
        draw_text_ext(70,640,evolution_descriptions[evolution_pending],28,580);
        flux_ship_shape(360,480,evolution_pending,90,4);
        flux_button(90,850,240,80,"Aceptar",true);
        flux_button(390,850,240,80,"Posponer",true);
        draw_text(70,980,"Puedes aceptar despues desde el arbol.");
        break;
    case "shop":
        draw_text(30,170,"Tienda de Mascotas | Una mascota equipada a la vez");
        for (var _p=0; _p<array_length(pets); ++_p) {
            var _yy=280+_p*220, _pet=pets[_p];
            draw_set_color(c_white);
            draw_circle(65,_yy+35,25,true); draw_circle(57,_yy+31,3,false); draw_circle(73,_yy+31,3,false);
            draw_text(110,_yy,_pet.name + " | " + string(_pet.price) + " creditos");
            draw_text_ext(30,_yy+110,_pet.description + (evolution==2 ? " Nodriza: bono duplicado." : ""),24,660);
            flux_button(460,_yy+20,230,65,equipped_pet==_p ? "Equipada" : (_pet.owned ? "Equipar" : "Comprar"),true);
        }
        flux_button(160,1090,400,70,"Volver al menu",true);
        break;
}
draw_set_color(c_white); draw_text(25,1010,notice);
