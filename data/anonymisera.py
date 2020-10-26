from pathlib import Path
import shutil
import pickle
import random

# Run this script in a directory of audio files to shuffle them and rename to anonymize
# Writes dictionary mapping anonymous file -> original name

if __name__ == '__main__':

    cwd = Path.cwd()
    new_dir = Path(cwd.joinpath('anonyma'))
    new_dir.mkdir(parents=True,exist_ok=True)
    name_dict = {}

    i = 1

    file_list = [file for file in cwd.iterdir() if file.suffix == '.wav']
    random.shuffle(file_list)
    nbr_files = len(file_list)

    for file in file_list:
        if file.suffix == '.wav':
            if i % 6 == 0: # Skips numbers 6,12,18,24,30 since they should be anchors in the survey
                i+=1
            new_file = new_dir.joinpath('audio' + str(i) + '.wav')
            name_dict[new_file.stem] = file.stem
            shutil.copy(str(file), str(new_file))
            i+=1

    if len(name_dict) > 1:
        with open(new_dir.joinpath('dictionary'),'wb') as f:
            pickle.dump(name_dict,f)
        with open(new_dir.joinpath('dictionary.txt'),'w') as f:
            for key in name_dict.keys():
                str = key + ': ' + name_dict[key] + '\n'
                f.write(str)
    else:
        Path.rmdir(new_dir)
