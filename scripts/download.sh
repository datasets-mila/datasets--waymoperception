#!/bin/bash

source scripts/utils.sh echo -n

# Saner programming env: these switches turn some bugs into errors
set -o errexit -o pipefail

# This script is meant to be used with the command 'datalad run'

export PATH="${PATH}:bin"

! python3 -m pip install --no-cache-dir -U crcmod

for split in training validation testing
do
	mkdir -p "${split}"/
	gsutil -m -o "GSUtil:parallel_process_count=1" -o "GSUtil:parallel_thread_count=4" \
		cp -R "gs://waymo_open_dataset_v_1_2_0/${split}/${split}_*.tar" ${split}/
	git-annex add "${split}"/
done

md5sum training/* validation/* testing/* > md5sums
