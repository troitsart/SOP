Process

##28.07.25

    Создал виртуальную машину Debian
    Провел все первоначальные конфигурацииустановил: vim, net-tools, git, sudo, curl, ufw

    добавил troits в sudo (bash: sudo useradd troits sudo)
    
    изменил ~/.bashrc - раскоментил ll

    users:	
        root : admin
	    troits : aquarium

    Машину назвал machine-1 (думаю, надо было virtual-1)

    ПРОБЛЕМА: 192.168.64.5		machine-1 в /etc/hosts (не работает)
    РЕШЕНИЕ: /etc/hosts нужно редактировать на машине-клиенте

    Покрасил user root в красный, добавив в ./bashrc: export PS1='\[\e[1;41;37m\]\u@\h:\w#\[\e[0m\] ' 

    GIT TOKEN: 
        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

    Клонировал репозиторий в ~/git:git clone git@github.com:troitsart/SOP.git


    устанавливаем docker
    sudo apt install -y docker.io

    устанавливаем кубер
    curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/arm64/kubectl"
    sudo install -o root -g root -m 0755 kubectl /usr/local/bin/kubectl

    устанавливаем minikube
    curl -Lo minikube https://storage.googleapis.com/minikube/releases/latest/minikube-linux-amd64 \
    && chmod +x minikube
    sudo mkdir -p /usr/local/bin/
    sudo install minikube /usr/local/bin/



##29.07.25

    Добавил манифесты для развертки apache

    применил манифесты:
    kubectl apply -f apache-deployment.yaml -f apache-service.yaml -f apache-configmap.yaml

    troits@machine-1:~/git/SOP/devops$ k get pods
    NAME                                 READY   STATUS    RESTARTS   AGE
    apache-deployment-57cfb846c4-97ltw   1/1     Running   0          27s
    apache-deployment-57cfb846c4-kxlbr   1/1     Running   0          27s


    пробрасываю порты:
    останавливаю ufw во избежания конфликта:
    sudo systemctl stop ufw
    sudo systemctl disable ufw

    sudo iptables -t nat -A PREROUTING -p tcp --dport 8080 -j DNAT --to-destination <MINIKUBE_IP>:<NODE_PORT>
    sudo iptables -t nat -A POSTROUTING -j MASQUERADE

    разрешаю трафик: sudo iptables -A FORWARD -p tcp --dport 30608 -j ACCEPT

    сохраняю правила: sudo apt install iptables-persistent -y
                        sudo netfilter-persistent save
    
    apache доступен по: http://machine-1:8080

    ПРИ РЕБУТ НУЖНО:
        заново запустить minikube start --driver=docker

    Нужно проработать, где будут хранится файлы приложения
    mkdir /usr/local/sop

    добавил ссылку на front файлы:
    ln -sT /home/troits/git/SOP/front front #TODO НАДО УДАЛИТЬ

    Сейчас изменяю манифест apache, добавляю репозиторий в под

    добавил репозиторий на сервак апача
    перезапуск пода: kubectl rollout restart deployment/apache-deploymen


##30.07.25

    меняю подход
    изучаю docker, делаю собственный образ для apache-server
    создал Dockerfile для apache-server
    залил image на dockerhub : troitsart/apache-server

    Развернул текущий образ на prod тачке (machine-1)
    сервер доступен по адресу:  <minikube_ip>:<service_port>
    
    нужно перекинуть порты, сделать доступ извне

    kubectl port-forward --address 0.0.0.0 svc/my-app-service 8080:80
