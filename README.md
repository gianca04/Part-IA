# part_ia

#Finalidad de la APP:
- Part-IA utiliza Firestore para almacenar un conjunto de recetas, las cuales seran mostradas dentro de la interfaz.
- Part-IA cuenta con una apartado de "Chat" donde se integra el API de gemini para poder generar recetas en base a una fotografia o texto.

# Estructura en Firebase:
recetas {
 String recetaId;
 String nombre;
 String descripcion;
 String imagen;
 number tiempo;
 number porciones;
 number costo;
 array ingredientes {
            0 map {
                STRING nombre 
                NUMBER cantidad
}
 number calorias;
 number proteinas;
 number grasas;
 number carbohidratos;
 number likes;
 String linkVideo;
 String tipoPlato;
 String dificultad;
 array pasos;

INDICES COMPUESTOS PARA BUSQUEDAS CON GEMINI:
ingredientes y tiempo
ingredientes y categoria
tiempo y categoria
ingredientes, tiempo y categoria
