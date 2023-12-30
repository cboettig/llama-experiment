FROM nvidia/cuda:12.3.1-devel-ubuntu22.04


# install some extra Ubuntu packages
ARG DEBIAN_FRONTEND=noninteractive
RUN apt-get update -qq && apt-get -qq install curl unzip libopenblas-dev nano git-lfs jq build-essential python3 python3-pip git pipx -y
RUN pip install --upgrade pip setuptools wheel
ENV PATH=/root/.local/bin:$PATH
RUN pipx install llm
RUN llm install llm-llama-cpp
RUN CMAKE_ARGS="-DLLAMA_CUBLAS=on" pip install llama-cpp-python
RUN CMAKE_ARGS="-DLLAMA_CUBLAS=on" FORCE_CMAKE=1 llm install llama-cpp-python
RUN curl -LO https://huggingface.co/TheBloke/Mixtral-8x7B-Instruct-v0.1-GGUF/resolve/main/mixtral-8x7b-instruct-v0.1.Q6_K.gguf
RUN curl -L https://github.com/Mozilla-Ocho/llamafile/releases/download/0.4.1/llamafile-server-0.4.1 >llamafile
RUN chmod +x llamafile

# Satisfy docker build but don't make this LD_LIBRARY_PATH persist
RUN ln -s /usr/local/cuda/lib64/stubs/libcuda.so /usr/local/cuda/lib64/stubs/libcuda.so.1
RUN LD_LIBRARY_PATH=/usr/local/cuda/lib64/stubs/:$LD_LIBRARY_PATH llm llama-cpp add-model mixtral-8x7b-instruct-v0.1.Q6_K.gguf --alias mix --llama2-chat
# CMD llm -m mix 'say hello in French'
ENTRYPOINT ["/root/.local/bin/llm", "-m", "mix"] 
CMD 'say hello in French'

#EXPOSE 8080
#CMD ./llamafile -m mixtral-8x7b-instruct-v0.1.Q6_K.gguf



#ENTRYPOINT ["llm -m mixtral -o path mixtral-8x7b-instruct-v0.1.Q6_K.gguf"] 


# clone llama.cpp repo
#RUN mkdir /workspace && cd /workspace &&  git clone https://github.com/ggerganov/llama.cpp.git

# setup & build llama.cpp
#RUN cd /workspace/llama.cpp && \
#  pip install -r requirements.txt && \
#  pip install --upgrade pip && \
#  make LLAMA_CUBLAS=1 -j


