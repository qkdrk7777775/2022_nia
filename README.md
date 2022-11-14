# 2022 NIA 사업 관련 AI 환경 구축 가이드


## 실행환경 구축
<details>
    <summary>DOCKER 설치</summary>

``` 
# 기존 설치 삭제
sudo apt-get remove \
     docker docker-engine \
     docker.io containerd runc

# 도커 설치 필수 패키지 설치
 sudo apt-get update
 sudo apt-get install \
    ca-certificates \
    curl \
    gnupg \
    lsb-release

# GPG Key 등록
curl -fsSL \
    https://download.docker.com/linux/ubuntu/gpg | \
    sudo gpg --dearmor -o \
    /usr/share/keyrings/docker-archive-keyring.gpg

# 저장소 등록
 echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/ubuntu \
  $(lsb_release -cs) stable" | \
  sudo tee /etc/apt/sources.list.d/docker.list > /dev/null

# 도커 엔진 설치
sudo apt-get update
sudo apt-get install \
    docker-ce docker-ce-cli containerd.io
```
[참고 Docker install](http://ducj3.iptime.org/docker_install/)
</details>

<details>
    <summary>NVIDIA DOCKER 설치</summary>

```
# 저장소 및 GPG 키 설정
distribution=$(. /etc/os-release;echo $ID$VERSION_ID) \
   && curl -s -L https://nvidia.github.io/nvidia-docker/gpgkey | sudo apt-key add - \
   && curl -s -L https://nvidia.github.io/nvidia-docker/$distribution/nvidia-docker.list | sudo tee /etc/apt/sources.list.d/nvidia-docker.list

# NVIDIA DOCKER INSTALL
sudo apt-get update
apt-get install -y nvidia-docker2

# SERVICE RESTART
sudo systemctl restart docker

#CHECK 
docker run --rm --gpus all ubuntu:18.04 nvidia-smi
# error 발생 시 
## 장치 확인
lshw -C display

## 설치 가능 목록 권장 설치
ubuntu-drivers autoinstall
```
[참고 NVIDIA Docker install](http://ducj3.iptime.org/ai_env_dev/)
</details>

<details>
    <summary>도커 이미지 생성</summary>

``` 
# git clone
git clone https://github.com/qkdrk7777775/2022_nia
cd 2022_nia

# dockerfile build
docker build -t my_deepo .

# docker run 
docker run -d -p 8888:8888 \
  -p 8889:8889 --name lab --ipc=host my_deepo jupyter lab \
   --no-browser --ip=0.0.0.0 --allow-root --LapApp.allow_origin='*' --LapApp.root_dir='/root'

# gpu
docker run -d  --gpus all -p 8888:8888 \
  -p 8889:8889 --name lab --ipc=host my_deepo jupyter lab \
   --no-browser --ip=0.0.0.0 --allow-root --LapApp.allow_origin='*' --LapApp.root_dir='/root'

# http://localhost:8888 접속
## token 확인
docker exec -it lab jupyter server list 
#http://3c8dd0a250b4:8888/?token=b6b1d97932978f1519a186614ebde305627069e9b82f1891 :: /
# 입력 -> b6b1d97932978f1519a186614ebde305627069e9b82f1891

# 주피터 패키지 설치
## 주피터 터미널에서 아래 명령어 실행
git clone https://github.com/qkdrk7777775/2022_nia
cd 2022_nia
pip install -r requirements.txt
```

</details>

## 활용 모델 설명

|작업명|눈깜빡임 분류|세그멘테이션| 수평/수직 분류| 진단모델|
|:---|---:|---:|---:|---:|
|Description|CNN Classification|DeepVOG|CNN|LightGBM|
|모델 아키텍쳐|CNN Classification|CNN기반 Segmentation Model|CNN + RNN Classification| LightGBM Classification|
|저장된 모델명|CNN Classification|DeepVOG.h5|cnn_rnn_model_*_fold.h5|lgbm_*_fold.pkl|
|input|(Batch, 240, 320, 3)|(Batch, 240, 320, 3)|(Batch, 240, 320, 3)|(N, 5)|
|output|(Batch, 3)|(Batch, 240, 320, 3)|(Batch, 3, 3)|(N, 1)|
|task|분류|객체탐지|분류|분류|
|training dataset|안구 이미지|안구 이미지|안구이미지|안구이미지+검진자료|
|training loss|categorical_crossentropy|None|categorical_crossentropy|multi_logloss|
|training optim|Adam|None|Adam|None|
|learning_rate|0.005|None|0.05|(0.05, 0.1, 0.2)|
|evaluation metric|AUC|AUC|AUC|AUC|

[세그멘테이션 활용 모델](https://github.com/pydsgz/DeepVOG)

실행 관련은 jupyter 폴더 참고

