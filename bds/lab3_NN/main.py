import argparse
import torch
import torch.nn as nn
import pandas as pd
import pickle

class SimpleNN(nn.Module):
    def __init__(self, input_size, hidden_size, num_classes):
        super(SimpleNN, self).__init__()
        self.fc1 = nn.Linear(input_size, hidden_size)
        self.relu = nn.ReLU()
        self.fc2 = nn.Linear(hidden_size, num_classes)
    
    def forward(self, x):
        out = self.fc1(x)
        out = self.relu(out)
        out = self.fc2(out)
        return out

if __name__ == "__main__":
    parser = argparse.ArgumentParser(description="Brain tumor classification")
    parser.add_argument("-m", "--model", dest="model_path", help="Path to model file", default="model.pt")
    parser.add_argument("-s", "--scaler", dest="scaler_path", help="Path to scaler file", default="scaler.pkl")
    parser.add_argument("-i", "--input", dest="input_path", help="Path to input data file", required=True)
    parser.add_argument("-o", "--output", dest="output_path", help="Path to output file", default="predictions.csv")


    args = parser.parse_args()

    model = torch.load(args.model_path)
    model.eval()
    
    x = pd.read_csv(args.input_path, sep=";", decimal=",", index_col=0)
    
    scaler = pickle.load(open(args.scaler_path, 'rb'))
    x[x.columns] = scaler.transform(x[x.columns])

    x = torch.tensor(x.to_numpy()).float()

    with torch.no_grad():
        output = model(x)
        _, predictions = torch.max(output.data, 1)
        predictions = pd.Series(predictions.numpy())
        predictions = predictions.map({0: "ASTROCYTOMA", 1: "GLIOBLASTOMA", 2: "MENINGIOMA"})

    predictions.to_csv(args.output_path, index=False, header=False)
    print(f"saved to: {args.output_path}")
