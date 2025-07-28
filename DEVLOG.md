Process

##28.07.25

    Создал виртуальную машину Debian
    Провел все первоначальные конфигурацииустановил: vim, net-tools, git
    
    изменил ~/.bashrc - раскоментил ll

    users:	
        root : admin
	    troits : aquarium

    Машину назвал machine-1 (думаю надо было virtual-1)

    ПРОБЛЕМА: 192.168.64.5		machine-1 в /etc/hosts (не работает)
    РЕШЕНИЕ: /etc/hosts нужно редактировать на машине-клиенте

    Покрасил user root в красный, добавив в ./bashrc: export PS1='\[\e[1;41;37m\]\u@\h:\w#\[\e[0m\] ' 

    GIT TOKEN: 
        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

    Клонировал репозиторий в ~/git:git clone git@github.com:troitsart/SOP.git
