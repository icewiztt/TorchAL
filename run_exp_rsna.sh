#!/bin/bash -l

# Setup
export NCCL_DEBUG=INFO
export PYTHONFAULTHANDLER=1

# Go to the folder you want to run your programs in
cd ~/TorchAL

# # # # # # #Possible sampling functions
# # # # # # ## random, uncertainty, uncertainty_uniform_discretize, dbal \
# # # # # # ## cog, coreset, vaal, vaal_minus_disc, bald, uncertainty_mix
# # # # # # ## ensemble_var_R, core_gcn
lSet_partition=$1
num_GPU=$2
gpu_device=$3
al_iterations=$4
budget_size=$5
config_dir=$6

# script params
port=5035
base_seed=1
# al_iterations=4 #7 #4
num_aml_trials=5 #50
# budget_size=2668 #500

dataset=RSNA
init_partition=10
step_partition=10
clf_epochs=5 #150
num_classes=2
swa_lr=5e-4
swa_freq=50
swa_epochs=5 #50

log_iter=40

#Data arguments
train_dir=~/TorchAL/data/$dataset/train-$dataset/
test_dir=~/TorchAL/data/$dataset/train-$dataset/
lSetPath=~/TorchAL/data_indexes/$dataset/partition_$lSet_partition/lSet_$dataset.npy
uSetPath=~/TorchAL/data_indexes/$dataset/partition_$lSet_partition/uSet_$dataset.npy
valSetPath=~/TorchAL/data_indexes/$dataset/partition_$lSet_partition/valSet_$dataset.npy

#for lSet 1
out_dir=~/TorchAL/temp_results 

# for other lSet Exps
# out_dir=~/TorchAL/results_lSetPartitions

#model_types: (i) wide_resnet_50 (ii) wide_resnet_28_10 (iii) wide_resnet_28_2

model_style=vgg_style
model_type=vgg #resnet_shake_shake
model_depth=16 #26

# model_style=resnet_style #vgg_style
# model_type=resnet_2 #vgg #resnet_shake_shake
# model_depth=18 #16 #26

# For resnet
# model_cfg_file=/raid/shadab/prateek/cvpr_code/configs/$dataset/$model_style/$model_type/R-18_4gpu.yaml


printf 'Number of GPU: %s\n' "$num_GPU"
printf 'Running on GPU:%s\n' "$gpu_device"

date # So we know when we started

sampling_fn=random

CUDA_VISIBLE_DEVICES=$gpu_device python3 tools/main_aml.py --n_GPU $num_GPU \
--port $port --sampling_fn $sampling_fn --lSet_partition $lSet_partition \
--seed_id $base_seed \
--init_partition $init_partition --step_partition $step_partition \
--dataset $dataset --budget_size $budget_size \
--out_dir $out_dir \
--num_aml_trials $num_aml_trials --num_classes $num_classes \
--al_max_iter $al_iterations \
--model_type $model_type --model_depth $model_depth \
--clf_epochs $clf_epochs \
--eval_period 1 --checkpoint_period 1 \
--lSetPath $lSetPath --uSetPath $uSetPath --valSetPath $valSetPath \
--train_dir $train_dir --test_dir $test_dir \
--dropout_iterations 25 \
--cfg configs/$dataset/$model_style/$config_dir/R-18_"$num_GPU"gpu.yaml \
--rand_aug --swa_mode --swa_freq $swa_freq --swa_lr $swa_lr --swa_epochs $swa_epochs --swa_iter 0 \
# --vaal_z_dim 32 --vaal_vae_bs 64 --vaal_epochs 15 \
# --vaal_vae_lr 5e-4 --vaal_disc_lr 5e-4 --vaal_beta 1.0 --vaal_adv_param 1.0 \

date # and when we finished

sampling_fn=coreset

CUDA_VISIBLE_DEVICES=$gpu_device python3 tools/main_aml.py --n_GPU $num_GPU \
--port $port --sampling_fn $sampling_fn --lSet_partition $lSet_partition \
--seed_id $base_seed \
--init_partition $init_partition --step_partition $step_partition \
--dataset $dataset --budget_size $budget_size \
--out_dir $out_dir \
--num_aml_trials $num_aml_trials --num_classes $num_classes \
--al_max_iter $al_iterations \
--model_type $model_type --model_depth $model_depth \
--clf_epochs $clf_epochs \
--eval_period 1 --checkpoint_period 1 \
--lSetPath $lSetPath --uSetPath $uSetPath --valSetPath $valSetPath \
--train_dir $train_dir --test_dir $test_dir \
--dropout_iterations 25 \
--cfg configs/$dataset/$model_style/$config_dir/R-18_"$num_GPU"gpu.yaml \
--rand_aug --swa_mode --swa_freq $swa_freq --swa_lr $swa_lr --swa_epochs $swa_epochs --swa_iter 0 \
# --vaal_z_dim 32 --vaal_vae_bs 64 --vaal_epochs 15 \
# --vaal_vae_lr 5e-4 --vaal_disc_lr 5e-4 --vaal_beta 1.0 --vaal_adv_param 1.0 \

date # and when we finished

sampling_fn=dbal

CUDA_VISIBLE_DEVICES=$gpu_device python3 tools/main_aml.py --n_GPU $num_GPU \
--port $port --sampling_fn $sampling_fn --lSet_partition $lSet_partition \
--seed_id $base_seed \
--init_partition $init_partition --step_partition $step_partition \
--dataset $dataset --budget_size $budget_size \
--out_dir $out_dir \
--num_aml_trials $num_aml_trials --num_classes $num_classes \
--al_max_iter $al_iterations \
--model_type $model_type --model_depth $model_depth \
--clf_epochs $clf_epochs \
--eval_period 1 --checkpoint_period 1 \
--lSetPath $lSetPath --uSetPath $uSetPath --valSetPath $valSetPath \
--train_dir $train_dir --test_dir $test_dir \
--dropout_iterations 25 \
--cfg configs/$dataset/$model_style/$config_dir/R-18_"$num_GPU"gpu.yaml \
--rand_aug --swa_mode --swa_freq $swa_freq --swa_lr $swa_lr --swa_epochs $swa_epochs --swa_iter 0 \
# --vaal_z_dim 32 --vaal_vae_bs 64 --vaal_epochs 15 \
# --vaal_vae_lr 5e-4 --vaal_disc_lr 5e-4 --vaal_beta 1.0 --vaal_adv_param 1.0 \

date # and when we finished

sampling_fn=bemps

CUDA_VISIBLE_DEVICES=$gpu_device python3 tools/main_aml.py --n_GPU $num_GPU \
--port $port --sampling_fn $sampling_fn --lSet_partition $lSet_partition \
--seed_id $base_seed \
--init_partition $init_partition --step_partition $step_partition \
--dataset $dataset --budget_size $budget_size \
--out_dir $out_dir \
--num_aml_trials $num_aml_trials --num_classes $num_classes \
--al_max_iter $al_iterations \
--model_type $model_type --model_depth $model_depth \
--clf_epochs $clf_epochs \
--eval_period 1 --checkpoint_period 1 \
--lSetPath $lSetPath --uSetPath $uSetPath --valSetPath $valSetPath \
--train_dir $train_dir --test_dir $test_dir \
--dropout_iterations 25 \
--cfg configs/$dataset/$model_style/$config_dir/R-18_"$num_GPU"gpu.yaml \
--rand_aug --swa_mode --swa_freq $swa_freq --swa_lr $swa_lr --swa_epochs $swa_epochs --swa_iter 0 \
# --vaal_z_dim 32 --vaal_vae_bs 64 --vaal_epochs 15 \
# --vaal_vae_lr 5e-4 --vaal_disc_lr 5e-4 --vaal_beta 1.0 --vaal_adv_param 1.0 \

date # and when we finished