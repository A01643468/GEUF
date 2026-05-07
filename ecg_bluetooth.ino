/*
 * ECG Monitor con AD8232 + Arduino UNO + HC-05 (Bluetooth Clasico)
 *
 * Pinout AD8232 -> Arduino UNO:
 *   OUTPUT  -> A0
 *   LO+     -> D10
 *   LO-     -> D11
 *   3.3V    -> 3.3V
 *   GND     -> GND
 *
 * Pinout HC-05 -> Arduino UNO:
 *   VCC     -> 5V
 *   GND     -> GND
 *   TXD     -> D2  (RX del Arduino, via SoftwareSerial)
 *   RXD     -> D3  (TX del Arduino, con divisor de tension a 3.3V)
 *
 *  IMPORTANTE: el RX del HC-05 es de 3.3V. Usar divisor de tension:
 *  resistencia 1k entre D3 y RX, y 2k entre RX y GND.
 *
 * Envia por Bluetooth, una linea por muestra:
 *   ECG:1234,BPM:75,LEAD:ON\n
 */

#include <SoftwareSerial.h>

SoftwareSerial bluetooth(2, 3);  // RX, TX

#define ECG_PIN A0
#define LO_PLUS 10
#define LO_MINUS 11

unsigned long lastBeat = 0;
unsigned long beatIntervals[5] = {0, 0, 0, 0, 0};
int beatIndex = 0;
int bpm = 0;
int threshold = 550;
bool aboveThreshold = false;

unsigned long lastSend = 0;

void setup() {
  Serial.begin(9600);
  bluetooth.begin(9600);

  pinMode(LO_PLUS, INPUT);
  pinMode(LO_MINUS, INPUT);

  Serial.println("ECG Monitor listo");
}

void loop() {
  bool leadOff = (digitalRead(LO_PLUS) == 1) || (digitalRead(LO_MINUS) == 1);
  int ecgValue = leadOff ? 0 : analogRead(ECG_PIN);

  if (!leadOff) {
    if (ecgValue > threshold && !aboveThreshold) {
      aboveThreshold = true;
      unsigned long now = millis();
      if (lastBeat > 0) {
        unsigned long interval = now - lastBeat;
        if (interval > 300 && interval < 2000) {
          beatIntervals[beatIndex] = interval;
          beatIndex = (beatIndex + 1) % 5;

          unsigned long sum = 0;
          int count = 0;
          for (int i = 0; i < 5; i++) {
            if (beatIntervals[i] > 0) {
              sum += beatIntervals[i];
              count++;
            }
          }
          if (count > 0) bpm = 60000 / (sum / count);
        }
      }
      lastBeat = now;
    } else if (ecgValue < threshold) {
      aboveThreshold = false;
    }
  }

  if (millis() - lastSend >= 20) {
    lastSend = millis();
    bluetooth.print("ECG:");
    bluetooth.print(ecgValue);
    bluetooth.print(",BPM:");
    bluetooth.print(bpm);
    bluetooth.print(",LEAD:");
    bluetooth.println(leadOff ? "OFF" : "ON");
  }
}
