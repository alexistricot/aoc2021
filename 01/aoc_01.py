import sys
from pathlib import Path

import numpy as np


def count_increase(meas_str: str):
    measurements = np.array([int(m) for m in meas_str.split("\n") if m], dtype=int)
    return np.sum(np.diff(measurements) > 0)


def count_mean_increase(meas_str: str, k: int):
    measurements = np.array([int(m) for m in meas_str.split("\n") if m], dtype=int)
    kernel = np.ones(k)
    means = np.convolve(measurements, kernel, "valid")
    print("Shape measurements:", measurements.shape)
    print("Shape means:", means.shape)
    return np.sum(np.diff(means) > 0)


if __name__ == "__main__":
    if len(sys.argv) != 2:
        raise ValueError("You must provide a path to a text file with measurements.")
    file = Path(sys.argv[1])
    if not file.is_file():
        raise FileExistsError("No such file.")
    with open(file, "r") as f:
        txt = str(f.read())
        print("Increasing measurements: ", count_increase(txt))
        print("Increasing means of measurements: ", count_mean_increase(txt, 3))
