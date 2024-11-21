###  进行匹配的两个标签文件

import numpy as np
from scipy.optimize import linear_sum_assignment
from sklearn.metrics import confusion_matrix, adjusted_rand_score, adjusted_mutual_info_score
import time
import os

# Define paths for labels
# SKGB得到的标签  ######## CHANGE EVERY TIME ##########
labels1_path = r"L:\SKGB_Export_Marveen\ClusteringResults\S3 30 sqrt 150 15 _S 1090440744\labels.txt"
# Read binary label file generated originally
# labels2_path = r'L:\SKGB_Export_Marveen\generatedData\1e8 256 17 95.3GB Noisy 5%\anisotropic_gaussian_labels.bin'
# 原标签  ######## CHANGE EVERY TIME ##########
labels2_path = r"L:\experiment\实验信息\Acc on S3\s3_labels.txt"


# Load labels
labels1 = np.loadtxt(labels1_path)
# labels2 = np.fromfile(labels2_path, dtype='uint8')
labels2 = np.loadtxt(labels2_path)

# Start timing for accuracy computation
start_accuracy = time.time()

# 构建混淆矩阵
cm = confusion_matrix(labels1, labels2)

# 使用匈牙利算法找到最优匹配
row_ind, col_ind = linear_sum_assignment(cm, maximize=True)

# 计算准确度
accuracy = cm[row_ind, col_ind].sum() / np.sum(cm)
print("ACC: {:.4f}".format(accuracy))

# End timing for accuracy computation
elapsed_accuracy = time.time() - start_accuracy
print(f"Time taken for accuracy computation: {elapsed_accuracy:.2f} seconds")

# Start timing for ARI computation
start_ari = time.time()

# 计算ARI
ari = adjusted_rand_score(labels1, labels2)
print("ARI: {:.4f}".format(ari))

# End timing for ARI computation
elapsed_ari = time.time() - start_ari
print(f"Time taken for ARI computation: {elapsed_ari:.2f} seconds")

# Start timing for AMI computation
start_ami = time.time()

# 计算ARI
ami = adjusted_mutual_info_score(labels1, labels2)
print("AMI: {:.4f}".format(ami))

# End timing for AMI computation
elapsed_ami = time.time() - start_ami
print(f"Time taken for AMI computation: {elapsed_ami:.2f} seconds")

# Get directory of labels1 file for saving the log
log_dir = os.path.dirname(labels1_path)
log_file_path = os.path.join(log_dir, "log.txt")

# Write results to log file
with open(log_file_path, 'a') as log_file:
    log_file.write(f"ACC: {accuracy:.4f}\n")
    log_file.write(f"ARI: {ari:.4f}\n")
    log_file.write(f"AMI: {ami:.4f}\n")

print("Results saved to log.txt")

# Delete all variables
_ = [globals().pop(name, None) for name in list(globals())]

