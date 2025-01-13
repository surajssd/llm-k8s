# Setup Single Node GPU VM on Azure

Here we will create a machine with GPUs and then deploy single node Kubernetes on it using nvkind.

## Step 1: Create a GPU machine on Azure

Make necesary changes to the `.env` file as you see fit and then run the following command:

```bash
source .env
./scripts/deploy-gpu-machine.sh all
```

You can also SSH into the machine using the following command in a new terminal tab:

```bash
source .env
./scripts/deploy-gpu-machine.sh ssh
```

> [!NOTE]
> The GPU driver installation usually takes a while. You can check the status of the installation by SSHing into the machine and running the following command:
> `./scripts/setup-node-for-single-node-k8s.sh check_driver_installation`

> [!TIP]
> If the driver installation fails, then you can enter into the machine and delete the file by running the command: `sudo rm /var/log/azure/nvidia-vmext-status`. And then restart the driver installation by running the command: `./scripts/deploy-gpu-machine.sh install_gpu_driver` on the host.

## Step 2: Setup Kubernetes on the GPU machine

Once inside the machine, first clone this repository again:

```bash
git clone https://github.com/surajssd/llama-k8s/
cd llama-k8s
```

Now let's ensure this machine is ready to start a single node Kubernetes cluster, so run the following commands:

```bash
./scripts/setup-node-for-single-node-k8s.sh all
```

## Step 3: Deploy Kubernetes on the GPU machine

Run the following command to deploy single node Kubernetes on the machine:

```bash
./scripts/deploy-single-node-k8s.sh
```
