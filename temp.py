import pandas as pd

# Read the file while skipping lines that contain "Discovered Device"
# df = pd.read_csv(
#     "realdata2.txt", 
#     sep=": ", 
#     header=None, 
#     names=["Label", "Value"], 
#     engine="python",
#     skiprows=lambda x: "Discovered Device" in open("your_file.txt").readlines()[x]
# )

# # Keep only the numeric values
# df = df[df["Label"] == "Received"][["Value"]]

# print(df)

with open("realdata2.txt", "r") as f:
    for line in f:
        words = line.strip().split(" ")
        if words[0] != "Received":
            continue
        print(words[2])

    # lines = [line.strip() for line in f if not line.startswith("Discovered")]