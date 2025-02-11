import processing.serial.*;

Serial myPort;  
String val;
float voltage = 0;
float displayedVoltage = 0;

// Historial para la gráfica en tiempo real
float[] voltageHistory = new float[100];
int graphStartX = 50;  // Posición X de inicio de la gráfica
int graphWidth = 700;  // Ancho de la gráfica
int graphHeight = 200; // Altura de la gráfica

void setup() {
  size(800, 600);
  myPort = new Serial(this, "COM3", 9600);
  myPort.bufferUntil('\n');

  // Personalización de la interfaz
  textAlign(CENTER, CENTER);
  textSize(32);
}

void draw() {
  // Temas de colores dinámicos según el voltaje
  if (displayedVoltage <= 2.0) {
    background(100, 150, 255);  // Azul claro
  } else if (displayedVoltage <= 4.0) {
    background(255, 200, 100);  // Naranja
  } else {
    background(255, 100, 100);  // Rojo
  }

  // Actualizar voltaje instantáneamente
  displayedVoltage = voltage;

  // Dibujar el medidor circular
  fill(255);
  noStroke();
  ellipse(width / 2, height / 2 - 100, 300, 300);  // Círculo principal del medidor

  // Relleno del medidor circular
  fill(100, 200, 250);
  arc(width / 2, height / 2 - 100, 300, 300, -PI / 2, map(displayedVoltage, 0, 5, -PI / 2, PI * 1.5), PIE);

  // Mostrar el voltaje en el centro del medidor
  fill(0);
  textSize(48);
  text(nf(displayedVoltage, 1, 2) + " V", width / 2, height / 2 - 100);

  // Actualizar el historial de la gráfica
  for (int i = 0; i < voltageHistory.length - 1; i++) {
    voltageHistory[i] = voltageHistory[i + 1];  // Mueve los valores a la izquierda
  }
  voltageHistory[voltageHistory.length - 1] = displayedVoltage;  // Añade el valor actual

  // Dibujar el área de la gráfica
  fill(255);
  stroke(0);
  rect(graphStartX, height - graphHeight - 50, graphWidth, graphHeight);  // Caja de la gráfica

  // Dibujar la gráfica de historial
  stroke(0, 0, 255);
  noFill();
  beginShape();
  for (int i = 0; i < voltageHistory.length; i++) {
    float x = map(i, 0, voltageHistory.length - 1, graphStartX, graphStartX + graphWidth);
    float y = map(voltageHistory[i], 0, 5, height - 50, height - graphHeight - 50);  
    vertex(x, y);
  }
  endShape();
}

void serialEvent(Serial myPort) {
  val = myPort.readStringUntil('\n');  
  if (val != null) {
    val = trim(val);  
    if (val.startsWith("Voltaje: ")) {
      String voltStr = val.substring(9, val.length() - 2);
      voltage = float(voltStr);  
    }
  }
}
