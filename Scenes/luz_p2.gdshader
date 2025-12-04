shader_type spatial;

uniform float altura : hint_range(0.0, 5.0) = 1.0;
uniform float frecuencia : hint_range(0.1, 10.0) = 2.0;
uniform float velocidad : hint_range(0.1, 5.0) = 1.0;

void vertex() {
    // Mueve cada vértice individualmente para crear la forma de ola
    VERTEX.y += sin(VERTEX.x * frecuencia + TIME * velocidad) * altura;
    VERTEX.y += cos(VERTEX.z * frecuencia + TIME * velocidad) * altura; // Añade complejidad
}

void fragment() {
    ALBEDO = vec3(0.0, 0.3, 0.8); // Color azul agua
    ROUGHNESS = 0.1;
    METALLIC = 0.5;
}