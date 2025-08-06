# Documentação do Desafio Kubernetes

Este README_1.md detalha o processo completo para construir a imagem Docker da aplicação, configurar e implantar os recursos do Kubernetes em um cluster local (Minikube), e gerenciar o ciclo de vida da aplicação.

## 1. Construção das Imagens Docker

A aplicação Node.js está localizada no diretório `app/` e o `Dockerfile` na raiz do projeto.

1.  **Navegue até o diretório raiz do projeto:**
    ```bash
    cd /home/deniscs/desafios-devops/kubernetes
    ```

2.  **Construa a imagem Docker com a tag `v1`:**
    ```bash
    docker build -t desafio-kubernetes:v1 .
    ```
    Esta imagem será a versão inicial da sua aplicação.

3.  **Como boa prática construa a imagem Docker com a tag `latest`:**
    ```bash
    docker build -t desafio-kubernetes:latest .
    ```

## 2. Importando Imagens Docker para o Minikube

Para que o Minikube possa usar as imagens Docker que você construiu localmente, você precisa importá-las para o daemon Docker do Minikube.

1.  **Inicie o Minikube (se ainda não estiver rodando):**
    ```bash
    minikube start
    ```

2.  **Configure o ambiente Docker para usar o daemon do Minikube:**
    ```bash
    eval $(minikube docker-env)
    ```
    Este comando direciona seu cliente Docker para usar o daemon Docker dentro da VM do Minikube.

3.  **Verifique se as imagens estão disponíveis no Minikube:**
    ```bash
    docker images
    ```
    Você deverá ver `desafio-kubernetes:v1` e `desafio-kubernetes:latest` listadas.

    **Importante:** Se você construir as imagens *após* ter executado `eval $(minikube docker-env)`, as imagens já serão construídas diretamente no ambiente do Minikube e não será necessário um passo de "importação" separado. O passo 2 (`eval $(minikube docker-env)`) é crucial para que o `docker build` subsequente já crie a imagem dentro do Minikube.

## 3. Objetos Kubernetes

Os manifestos do Kubernetes estão localizados no diretório `k8s/`.

*   **`k8s/configmap.yaml`**:
    Define um `ConfigMap` chamado `app-config` no namespace `desafio-devops`. Ele armazena a variável de ambiente `NAME` com o valor "Denis", que será injetada nos pods da aplicação.

    ```yaml
    apiVersion: v1
    kind: ConfigMap
    metadata:
      name: app-config
      namespace: desafio-devops
    data:
      NAME: "Denis"
    ```

*   **`k8s/deployment.yaml`**:
    Define um `Deployment` chamado `app-deployment` no namespace `desafio-devops`. Ele garante que uma réplica do pod da aplicação esteja rodando. O pod usa a imagem `desafio-kubernetes:v1`, expõe a porta 3000 e injeta as variáveis do `ConfigMap`.
    
    Para garantir que a aplicação utilize os `recursos` de forma controlada, foram adicionados `limites de CPU e memória`. O pod solicitará 32Mi de memória e 125m de CPU e terá um limite máximo de 64Mi de memória e 250m de CPU.

    ```yaml
    apiVersion: apps/v1
    kind: Deployment
    metadata:
      name: app-deployment
      namespace: desafio-devops
    spec:
      replicas: 1
      selector:
        matchLabels:
          app: desafio-app
      template:
        metadata:
          labels:
            app: desafio-app
        spec:
          containers:
          - name: app-container
            image: desafio-kubernetes:latest
            imagePullPolicy: IfNotPresent
            ports:
            - containerPort: 3000
            envFrom:
            - configMapRef:
                name: app-config
            resources:
              requests:
                memory: "32Mi"
                cpu: "125m"
              limits:
                memory: "64Mi"
                cpu: "250m"
            livenessProbe:
              httpGet:
                path: /healthz
                port: 3000
              initialDelaySeconds: 5
              periodSeconds: 10
            readinessProbe:
              httpGet:
                path: /healthz
                port: 3000
              initialDelaySeconds: 5
              periodSeconds: 10            
    ```

*   **`k8s/service.yaml`**:
    Define um `Service` chamado `app-service` no namespace `desafio-devops`. Ele expõe o `Deployment` internamente no cluster, roteando o tráfego da porta 80 do serviço para a porta 3000 dos pods.

    ```yaml
    apiVersion: v1
    kind: Service
    metadata:
      name: app-service
      namespace: desafio-devops
    spec:
      selector:
        app: desafio-app
      ports:
        - protocol: TCP
          port: 80
          targetPort: 3000
    ```

*   **`k8s/ingress.yaml`**:
    Define um `Ingress` chamado `app-ingress` no namespace `desafio-devops`. Ele configura o roteamento externo para a aplicação, permitindo que ela seja acessada através do host `desafio.local` na porta 80, direcionando o tráfego para o `app-service`.

    ```yaml
    apiVersion: networking.k8s.io/v1
    kind: Ingress
    metadata:
      name: app-ingress
      namespace: desafio-devops
    spec:
      rules:
      - host: "desafio.local"
        http:
          paths:
          - path: /
            pathType: Prefix
            backend:
              service:
                name: app-service
                port:
                  number: 80
    ```    
## 4. Scripts de Gerenciamento

Dois scripts shell são fornecidos para facilitar o deploy e a exclusão dos recursos do Kubernetes.

*   **`deploy-app.sh`**:
    Este script aplica todos os manifestos do Kubernetes na ordem correta.

    ```bash
    #!/bin/bash

    echo "deployando objetos..."
    kubectl apply -f k8s/configmap.yaml
    kubectl apply -f k8s/deployment.yaml
    kubectl apply -f k8s/service.yaml
    kubectl apply -f k8s/ingress.yaml
    echo "Aplicado com sucesso."
    ```

*   **`delete-app.sh`**:
    Este script remove todos os recursos do Kubernetes criados pelo `deploy-app.sh` na ordem inversa.

    ```bash
    #!/bin/bash
    echo "Deletando objetos..."
    kubectl delete -f k8s/ingress.yaml
    kubectl delete -f k8s/service.yaml
    kubectl delete -f k8s/deployment.yaml
    kubectl delete -f k8s/configmap.yaml
    echo "Objetos deletados."
    ```

## 5. Processo de Deploy Completo no Minikube

Siga estes passos para implantar a aplicação no seu cluster Minikube:

1.  **Inicie o Minikube e configure o ambiente Docker:**
    ```bash
    minikube start
    eval $(minikube docker-env)
    ```

2.  **Construa as imagens Docker (se ainda não o fez, ou se as construiu antes de `eval $(minikube docker-env)`):**
    ```bash
    docker build -t desafio-kubernetes:v1 .
    docker build -t desafio-kubernetes:latest .
    ```

3.  **Habilite o addon Ingress no Minikube:**
    O Ingress é necessário para que o `Ingress` object funcione.
    ```bash
    minikube addons enable ingress
    ```

4. **Crie a namespace**
    ```bash
    kubectl create namespace desafio-devops
    ```
    
5.  **Execute o script de deploy:**
    ```bash
    chmod +x deploy-app.sh
    ./deploy-app.sh
    ```

6.  **Verifique o status dos pods e serviços:**
    ```bash
    kubectl get pods -n desafio-devops
    kubectl get svc -n desafio-devops
    kubectl get ingress -n desafio-devops
    ```
    Certifique-se de que os pods estão no estado `Running`.

7.  **Obtenha o IP do Minikube e adicione a entrada no seu arquivo hosts:**
    Para acessar a aplicação via `desafio.local`, você precisa mapear este hostname para o IP do Minikube no seu arquivo `/etc/hosts` (Linux).

    Obtenha o IP do Minikube:
    ```bash
    minikube ip
    ```
    Exemplo de saída: `192.168.49.2`

    Adicione a seguinte linha ao seu arquivo hosts (substitua `192.168.49.2` pelo IP real do seu Minikube):
    ```
    192.168.49.2 desafio.local
    ```

8.  **Acesse a aplicação:**
    Abra seu navegador e acesse: `http://desafio.local`
    Você deverá ver a mensagem "Olá Denis!".

## 6. Limpeza (Excluindo Recursos)

Para remover todos os recursos do Kubernetes e limpar o ambiente:

1.  **Execute o script de exclusão:**
    ```bash
    chmod +x delete-app.sh
    ./delete-app.sh
    ```

2.  **Pare o Minikube (opcional):**
    ```bash
    minikube stop
    ```

3.  **Exclua o cluster Minikube (opcional, para uma limpeza completa):**
    ```bash
    minikube delete
    ```
## 7. Implementação do health check

1.  **Implementado em app/app.js uma rota para o /healthz que retorna HTTP 200 OK e um JSON { status: 'ok' }**
   
   // Endpoint para health check
   ```yaml
   app.get('/healthz', (req, res) => {
     res.status(200).json({ status: 'ok' });
   });
   ```

2.  **Adicionado as Probes Liveness e Readness no arquivo de deployment da app.**
    
  ```yaml  
  livenessProbe:
    httpGet:
      path: /healthz
      port: 3000
    initialDelaySeconds: 5
    periodSeconds: 10
  readinessProbe:
    httpGet:
      path: /healthz
      port: 3000
    initialDelaySeconds: 5
    periodSeconds: 10 
  ```
