apt-get install gcc-5 g++-5
ln -s /usr/bin/gcc-5 /usr/local/cuda/bin/gcc
ln -s /usr/bin/g++-5 /usr/local/cuda/bin/g++

TF_INC=$(python -c 'import tensorflow as tf; print(tf.sysconfig.get_include())')
TF_LIB=$(python -c 'import tensorflow as tf; print(tf.sysconfig.get_lib())')

cd /home/SOE-Net/tf_ops/sampling/

/usr/local/cuda-8.0/bin/nvcc tf_sampling_g.cu -o tf_sampling_g.cu.o -c -O2 -DGOOGLE_CUDA=1 -x cu -Xcompiler -fPIC

export TF_PREFIX="/root/miniconda3/envs/soe/lib/python3.6/site-packages/tensorflow"
export TF_PREFIX="/root/.pyenv/versions/3.6.5/lib/python3.6/site-packages/tensorflow"
export CUDA8_PREFIX="/usr/local/cuda-8.0"
export CUDA9_PREFIX="/usr/local/cuda-8.0"

# g++ -std=c++11 tf_sampling.cpp tf_sampling_g.cu.o -o tf_sampling_so.so -shared -fPIC \
#     -I $TF_PREFIX"/include" -I CUDA8_PREFIX"/include" -I $TF_PREFIX"/include/external/nsync/public" \
#     -lcudart -L $CUDA8_PREFIX"/lib64/" -L -L $TF_PREFIX \
#     -L${TF_LIB} -ltensorflow_framework -O2 -D_GLIBCXX_USE_CXX11_ABI=0

g++ -w -std=c++11 tf_sampling.cpp tf_sampling_g.cu.o -o tf_sampling_so.so -shared -fPIC \
    -I $TF_PREFIX"/include" -I $CUDA8_PREFIX"/include" -I $TF_PREFIX"/include/external/nsync/public" \
    -lcudart -L $CUDA8_PREFIX"/lib64/" -L $TF_PREFIX \
    -O2 -D_GLIBCXX_USE_CXX11_ABI=0 -I$TF_INC/external/nsync/public -L$TF_LIB -ltensorflow_framework

cd /home/SOE-Net/tf_ops/3d_interpolation/

g++ -w -std=c++11 tf_interpolate.cpp -o tf_interpolate_so.so -shared -fPIC \
    -I $TF_PREFIX"/include" -I $CUDA8_PREFIX"/include" -I $TF_PREFIX"/include/external/nsync/public" \
    -lcudart -L $CUDA8_PREFIX"/lib64/" -L $TF_PREFIX \
    -ltensorflow_framework -O2 -D_GLIBCXX_USE_CXX11_ABI=0 -I$TF_INC/external/nsync/public -L$TF_LIB -ltensorflow_framework

cd /home/SOE-Net/tf_ops/grouping/

/usr/local/cuda-8.0/bin/nvcc  tf_grouping_g.cu -o tf_grouping_g.cu.o -c -O2 -DGOOGLE_CUDA=1 -x cu -Xcompiler -fPIC -Wno-deprecated-gpu-targets

g++ -w -std=c++11 tf_grouping.cpp tf_grouping_g.cu.o -o tf_grouping_so.so -shared -fPIC \
    -I $TF_PREFIX"/include" -I $CUDA8_PREFIX"/include" -I $TF_PREFIX"/include/external/nsync/public" \
    -lcudart -L $CUDA8_PREFIX"/lib64/" -L $TF_PREFIX \
    -ltensorflow_framework -O2 -D_GLIBCXX_USE_CXX11_ABI=0 -I$TF_INC/external/nsync/public -L$TF_LIB -ltensorflow_framework

cd /home/SOE-Net/tf_ops/pointSIFT_op

/usr/local/cuda-8.0/bin/nvcc pointSIFT.cu -o pointSIFT_g.cu.o -c -O2 -DGOOGLE_CUDA=1 -x cu -Xcompiler -fPIC

g++ -std=c++11 main.cpp pointSIFT_g.cu.o -o tf_pointSIFT_so.so -shared -fPIC \
    -I ${TF_INC} -I $CUDA9_PREFIX"/include" -I ${TF_INC}/external/nsync/public \
    -lcudart -L $CUDA9_PREFIX"/lib64/" -L${TF_LIB} -ltensorflow_framework \
    -O2 -D_GLIBCXX_USE_CXX11_ABI=0






