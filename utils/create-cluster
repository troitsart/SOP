#debian!
#Первичные приготовления на всех нодах!!

#устанавливаем пакеты
sudo apt-get update -y
sudo apt-get install -y apt-transport-https ca-certificates curl gpg sudo vim git

#добавляем troits в sudo
sudo adduser troits sudo

#отключаем swap
sudo swapoff -a	
sudo sed -i '/ swap / s/^\(.*\)$/#\1/g' /etc/fstab

sudo mkdir -p /etc/apt/keyrings
curl -fsSL https://pkgs.k8s.io/core:/stable:/v1.30/deb/Release.key | sudo gpg --dearmor -o /etc/apt/keyrings/kubernetes-apt-keyring.gpg
echo 'deb [signed-by=/etc/apt/keyrings/kubernetes-apt-keyring.gpg] https://pkgs.k8s.io/core:/stable:/v1.30/deb/ /' | sudo tee /etc/apt/sources.list.d/kubernetes.list

#устанавливаем kuber*
sudo apt-get update -y
sudo apt-get install -y kubelet kubeadm kubectl containerd
sudo apt-mark hold kubelet kubeadm kubectl


#заходим под рута, активируем модули
modprobe br_netfilter
modprobe overlay


#перенеаправление пакетов
echo "net.ipv4.ip_forward=1" >> /etc/sysctl.conf
echo "net.bridge.bridge-nf-call-iptables=1" >> /etc/sysctl.conf
sysctl -p /etc/sysctl.conf


#возвращаемся под пользователя

#действия для новых версий debian:
sudo mkdir /etc/containerd/
sudo vim /etc/containerd/config.toml

version = 2
[plugins]
  [plugins."io.containerd.grpc.v1.cri"]
   [plugins."io.containerd.grpc.v1.cri".containerd]
      [plugins."io.containerd.grpc.v1.cri".containerd.runtimes]
        [plugins."io.containerd.grpc.v1.cri".containerd.runtimes.runc]
          runtime_type = "io.containerd.runc.v2"
          [plugins."io.containerd.grpc.v1.cri".containerd.runtimes.runc.options]
            SystemdCgroup = true

sudo systemctl restart containerd            


#НА МАСТЕР НОДЕ:

#берем ip
ip a


#запускаем
sudo kubeadm init \
  --apiserver-advertise-address=10.128.0.28 \
  --pod-network-cidr 10.244.0.0/16


#дефолт конфиги (с оф доки)
mkdir -p $HOME/.kube
sudo cp -i /etc/kubernetes/admin.conf $HOME/.kube/config
sudo chown $(id -u):$(id -g) $HOME/.kube/config


#устанавливаем CLI
kubectl apply -f https://github.com/flannel-io/flannel/releases/latest/download/kube-flannel.yml


#на workere:

#добавляем в кластер
sudo kubeadm join 192.168.64.29:6443 --token 8aruyq.nsjghs4fftpglwb7 \
        --discovery-token-ca-cert-hash sha256:abae5fbdac134044f4841db408eca6246e05eb9fe980382f5576d6a77feff762

#на mastere:
#для dashboard
sudo wget https://raw.githubusercontent.com/kubernetes/dashboard/v2.7.0/aio/deploy/recommended.yaml

vim recommended.yaml
spec.type = NodePort
spec.ports.nodePort = 30555

#закидываем в манифест
kubectl apply –f recommended.yaml

#Теперь необходимо подготовить yaml с RoleBind для админской учетной записи, строго соблюдая все пробелы

vim admin-user.yaml

apiVersion: v1 
kind: ServiceAccount 
metadata: 
  name: admin-user 
  namespace: kubernetes-dashboard 
---
apiVersion: rbac.authorization.k8s.io/v1
kind: ClusterRoleBinding 
metadata: 
  name: admin-user 
roleRef: 
  apiGroup: rbac.authorization.k8s.io
  kind: ClusterRole 
  name: cluster-admin 
subjects:
 - kind: ServiceAccount 
   name: admin-user 
   namespace: kubernetes-dashboard 

#создаем токен для захода в dashboard:
kubectl -n kubernetes-dashboard create token admin-user



#ISTIOOOOOOOOO

#Поставка
curl -L https://istio.io/downloadIstio | sh -

cd istio-1.27.0

export PATH=$PWD/bin:$PATH

istioctl x precheck

istioctl install -f samples/bookinfo/demo-profile-no-gateways.yaml -y

#Установка
kubectl get crd gateways.gateway.networking.k8s.io &> /dev/null || { kubectl kustomize "github.com/kubernetes-sigs/gateway-api/config/crd?ref=v1.1.0" | kubectl apply -f -; }


#ТЕСТОВОЕ ПРИЛОЖЕНИЕ:
kubectl label namespace default istio-injection=enabled
kubectl apply -f https://raw.githubusercontent.com/istio/istio/release-1.23/samples/bookinfo/platform/kube/bookinfo.yaml

#устанавливаем gateway
kubectl apply -f samples/bookinfo/gateway-api/bookinfo-gateway.yaml
#обновляем gateway
kubectl annotate gateway bookinfo-gateway networking.istio.io/service-type=ClusterIP --namespace=default
#проверка
kubectl get gateway

#пробрасываем порты:
kubectl port-forward --address 0.0.0.0 svc/bookinfo-gateway-istio 8080:80 &

#устанавливаем helm
curl https://baltocdn.com/helm/signing.asc | gpg --dearmor | sudo tee /usr/share/keyrings/helm.gpg > /dev/null
sudo apt-get install apt-transport-https --yes
echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/helm.gpg] https://baltocdn.com/helm/stable/debian/ all main" | sudo tee /etc/apt/sources.list.d/helm-stable-debian.list
sudo apt-get update
sudo apt-get install helm

#устанавливаем ingress контроллер:
helm upgrade --install ingress-nginx ingress-nginx \
--repo https://kubernetes.github.io/ingress-nginx \
--namespace ingress-nginx --create-namespace

#устанавливаем metallb. MetalLB эмулирует работу LoadBalancer в bare-metal/локальных кластерах.
kubectl apply -f https://raw.githubusercontent.com/metallb/metallb/v0.13.12/config/manifests/metallb-native.yaml

#добавляем ip pool:
cat <<EOF | kubectl apply -f -
apiVersion: metallb.io/v1beta1
kind: IPAddressPool
metadata:
  name: default-pool
  namespace: metallb-system
spec:
  addresses:
  - 192.168.1.240-192.168.1.250  # Укажите свободный диапазон из вашей сети
EOF

#добавляем в манифест сервис ingress:
apiVersion: networking.k8s.io/v1
kind: Ingress
metadata:
  name: test-ingress
  annotations:
    nginx.ingress.kubernetes.io/rewrite-target: /
spec:
  ingressClassName: nginx
  rules:
  - http:
      paths:
      - path: /
        pathType: Prefix
        backend:
          service:
            name: bookinfo-gateway-istio
            port:
              number: 80


kiali:
troits@master-1:~$ istioctl version
client version: 1.27.0
control plane version: 1.27.0
data plane version: 1.27.0 (7 proxies)
troits@master-1:~$ kubectl apply -f https://raw.githubusercontent.com/istio/istio/release-1.27/samples/addons/kiali.yaml

#устанвливаем доп пакеты:
kubectl apply -f https://raw.githubusercontent.com/istio/istio/release-1.18/samples/addons/prometheus.yaml
kubectl apply -f https://raw.githubusercontent.com/istio/istio/release-1.18/samples/addons/grafana.yaml
kubectl apply -f https://raw.githubusercontent.com/istio/istio/release-1.18/samples/addons/jaeger.yaml

#фейк запросы
for i in $(seq 1 100); do curl -s -o /dev/null "http://$GATEWAY_URL/productpage"; done
