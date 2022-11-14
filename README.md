# 2022 NIA 사업 관련 AI 환경 구축 가이드


## 실행환경

<details>
    <summary>NVIDIA DOCKER 설치</summary>

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



