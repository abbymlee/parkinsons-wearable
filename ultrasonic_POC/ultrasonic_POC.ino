#define purpleTrig    10
#define purpleEcho    9

#define orangeTrig    6
#define orangeEcho    7

void setup()
{
    Serial.begin(9600);
    pinMode(purpleTrig, OUTPUT);
    pinMode(purpleEcho, INPUT);

    pinMode(orangeTrig, OUTPUT);
    pinMode(orangeEcho, INPUT);
}

void loop()
{

    digitalWrite(purpleTrig, HIGH);
    delayMicroseconds(10);
    digitalWrite(purpleTrig, LOW);

    long purpleDuration = pulseIn(purpleEcho, HIGH);
    float purpleDistance = purpleDuration * 0.034 / 2; // Convert to cm
    
    Serial.print("Purple Distance: ");
    Serial.print(purpleDistance);
    Serial.print(" cm");
        
    digitalWrite(orangeTrig, HIGH);
    delayMicroseconds(10);
    digitalWrite(orangeTrig, LOW);

    long orangeDuration = pulseIn(orangeEcho, HIGH);
    float orangeDistance = orangeDuration * 0.034 / 2; // Convert to cm

    Serial.print("          Orange Distance: ");
    Serial.print(orangeDistance);
    Serial.println(" cm");

    delay(2000);

}
