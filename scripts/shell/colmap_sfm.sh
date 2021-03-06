DATASET_PATH=$1
OUTPUT_PATH=$2
VOC_TREE_PATH=$3
MOST_SIMILAR_IMAGES_NUM=$4

begin_time=$(date "+%s")

/home/chenyu/Projects/DAGSfM/build/src/exe/colmap feature_extractor \
--database_path=$DATASET_PATH/database.db \
--image_path=$DATASET_PATH/images \
--SiftExtraction.num_threads=8 \
--SiftExtraction.use_gpu=1 \
--SiftExtraction.gpu_index=0

end_time=$(date "+%s")
feature_extraction_time=$(($end_time - $begin_time))
echo "feature extraction time: $feature_extraction_time s" > $DATASET_PATH/feature_time.txt

begin_time=$(date "+%s")

/home/chenyu/Projects/DAGSfM/build/src/exe/colmap vocab_tree_matcher \
--database_path=$DATASET_PATH/database.db \
--SiftMatching.num_threads=8 \
--SiftMatching.use_gpu=1 \
--SiftMatching.gpu_index=0 \
--VocabTreeMatching.num_images=$MOST_SIMILAR_IMAGES_NUM \
--VocabTreeMatching.num_nearest_neighbors=5 \
--VocabTreeMatching.vocab_tree_path=$VOC_TREE_PATH

end_time=$(date "+%s")
matching_time=$(($end_time - $begin_time))
echo "feature matching time: $matching_time s" > $DATASET_PATH/matching_time.txt

/home/chenyu/Projects/DAGSfM/build/src/exe/colmap mapper \
$OUTPUT_PATH \
--database_path=$DATASET_PATH/database.db \
--image_path=$DATASET_PATH/images \
--output_path=$OUTPUT_PATH \
--Mapper.num_threads=8

mv $DATASET_PATH/feature_time.txt $OUTPUT_PATH
mv $DATASET_PATH/matching_time.txt $OUTPUT_PATH