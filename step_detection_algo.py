import matplotlib.pyplot as plt
import pandas as pd
import random

def read_sensor_data(filename):
    
    values = []
    with open(filename, "r") as f:
        for line in f:
            words = line.strip().split(" ")
            if words[0] != "Received":
                continue
            values.append(float(words[2]))

    return values


def noise():
    return random.uniform(0.85, 1.15) 


steps_csv = pd.read_csv("step_length_dual.csv")
right = steps_csv["Right Foot (cm)"]
left = steps_csv["Left Foot (cm)"]

# right = [r * noise() for r in right]
# left = [l * noise() for l in left]
front = read_sensor_data("realdata2.txt")

plt.plot(front, label="front")
# plt.plot(right, label='right')
# plt.plot(left, label='left')
plt.ylim(0, 300)
plt.legend()
plt.show()

class StepLengthAlgorithm:
    def __init__(self, min_threshold=12, max_threshold=70):
        self.window = [] 
        self.step_lengths = [] 
        self.min_threshold = min_threshold
        self.max_threshold = max_threshold 

    def update(self, new_value):
        
        # update window
        self.window.append(round(new_value, 3))
        if len(self.window) > 5:
            self.window.pop(0)

        # moving average of window
        avg = sum(self.window) / len(self.window)
        
        # remove avgs that are unrealistic for a human step length
        if avg > self.max_threshold or len(self.window) < 3:
            return self.step_lengths
        

        # calculate conditions for a "peak", measurement of concern is self.window[-2]
        potential_step = self.window[-2]
        increasing_before = potential_step > self.window[-3]
        decreasing_after = potential_step > self.window[-1]
        # print(increasing_before and decreasing_after, round(avg, 3), self.window, potential_step)

        if increasing_before and decreasing_after:
            if potential_step > self.min_threshold:
                self.step_lengths.append(potential_step) 
                
        return self.step_lengths

# Example usage
detector = StepLengthAlgorithm()
for value in front:
    steps_lengths = detector.update(value)

print("calculated step lengths:", steps_lengths)