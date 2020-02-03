#!/bin/sh

INPUT_FOLDER=original
OUTPUT_FOLDER=patched
TEMP_FOLDER=ligaturized

for file in $INPUT_FOLDER/*.otf
do
  docker run --rm \
    -v $(pwd)/$file:/input \
    -v $(pwd)/$TEMP_FOLDER:/output \
    --user $(id -u) \
    rfvgyhn/ligaturizer
done

mkdir -p -- "$TEMP_FOLDER"

docker run --rm \
--volume $(pwd)/$TEMP_FOLDER:/nerd-fonts/in:ro \
--volume $(pwd)/$OUTPUT_FOLDER:/nerd-fonts/out \
--user $(id -u):$(id -g) \
cdalvaro/nerd-fonts-patcher:2.1.0 \
--quiet --no-progressbars \
--powerline --powerlineextra \
--mono --adjust-line-height --careful

rm -rf -- "$TEMP_FOLDER"