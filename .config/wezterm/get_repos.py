import sys
import os

repos = []

# Flith
def get_repos(path: str):
    for path, dirs, files in os.walk(path):
        for dir in dirs:
            if dir == ".git":
                print(path)
 
if __name__ == "__main__":
    path = sys.argv[1]
    get_repos(path)
