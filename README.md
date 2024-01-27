# Installing Prometheus &amp; Grafana Monitoring

This Bash script automates the installation of Prometheus and Grafana monitoring on an Ubuntu/Debian VPS.



## It performs the following tasks:


### Step 1: VPS IP Address Required
  * The script will require your VPS IP address to perform and configure the necessary files for accurate monitoring of your system.

    ![Screenshot 2024-01-26 at 19 04 22](https://github.com/Phoenix-999/Installing-Grafana-Monitoring/assets/127796122/bba3acdd-4495-4a8a-96c2-87b208f4911e)


### Step 2: Update and Upgrade Your System
  * Ensure that your system is up-to-date with the necessary updates and upgrades.

### Step 3: Download, install, and configure Prometheus
  * Ensure Prometheus is Downloaded, Installed, and Automatically Configured from the Main Source on Your System

### Step 4: Download, install, and configure Node Exporter
  * Ensure Node Exporter is Downloaded, Installed, and Automatically Configured from the Main Source on Your System

### Step 5: Download, install, and configure Grafana
  * Ensure Grafana is Downloaded, Installed, and Automatically Configured from the Main Source on Your System

## Prerequisites:

Ubuntu & Debian
  * Linux `AMD64` Processor Architecture
  * Linux `ARM64` Processor Architecture
  * Ensure that the sudo and wget packages are installed on your system:

```bash
sudo apt update && sudo apt install -y sudo wget
```
Tested on: Ubuntu 20+, Debian 11+

Root access is required. If the user is not root, first run:

```bash
sudo -i
```

Then:

```bash
wget "https://raw.githubusercontent.com/Phoenix-999/Installing-Grafana-Monitoring/main/Installing-Grafana-Monitoring.sh" -O Installing-Grafana-Monitoring.sh && chmod +x Installing-Grafana-Monitoring.sh && bash Installing-Grafana-Monitoring.sh
```

After the script successfully completes, you should see a message similar to the one below. Please take note of it and reboot the server

![Screenshot 2024-01-26 at 18 56 14](https://github.com/Phoenix-999/Installing-Grafana-Monitoring/assets/127796122/776ff8a6-7c0b-4a20-aa5c-b6cd287dbee0)


Reboot your system using the following command:

```bash
sudo reboot now
```

_______________________________________________________________________________________________________________________________________________________________________

## Step 5: Finish Setting Up the Grafana Web Panel

Now, using any web browser (Chrome, Firefox, Safari, etc.), access the Grafana web interface and control panel by
navigating to `http://your-server-ip-address:3000/`.
Note: Replace 'Your-Server-IP-Address' with the actual IP address of your server.




Please follow the image instructions below to set up your panel for correct monitoring of your server
To log in, use the default username and password, which are both `admin` Afterward, you can choose a new, strong password.

![da43ff0d-b70e-4525-bc78-e3fd49f85f80-1](https://github.com/Phoenix-999/Installing-Grafana-Monitoring/assets/127796122/e89d3367-1cc7-4b25-ba9a-d496f3af1795)


Next, go to the Home hamburger menu on the top left, open the dropdown menu, and choose `Connections`.

![f92f6076-ab10-44df-9d61-3e173df555dc-1](https://github.com/Phoenix-999/Installing-Grafana-Monitoring/assets/127796122/cc53ff27-3773-45c1-99bb-b8cb1f69b999)

Then to add a new connection, search for 'Prometheus,' select it, and double-click to add.

![3c3a3cc6-d8d5-4dcd-9de5-ce608a105b71](https://github.com/Phoenix-999/Installing-Grafana-Monitoring/assets/127796122/2246aa9e-f74b-4baf-9754-f2d053275c9d)

Next, click the blue button on the top right corner, `Add New Data Source.`'In the connection field, change `localhost:9090` to `Your-Server-IP-Address:9090` as illustrated in the image below.

![8957c4e7-0096-4d9b-886a-acdd88bc64b0](https://github.com/Phoenix-999/Installing-Grafana-Monitoring/assets/127796122/0a5ee7ba-fd3e-4bf2-8f9a-feeb511855f1)

Then, scroll down to the bottom of the page and click on the `Save and Test` button. You should see the message `Successfully queried the Prometheus API`

![1c44ec4c-9ca4-4d26-a49f-3d5a48f7f924](https://github.com/Phoenix-999/Installing-Grafana-Monitoring/assets/127796122/baabb507-844d-4b4f-a6d4-5eef6b5889c4)

Next, go back to the home menu, select `Dashboard` click on the 'New' button on the top right, and choose `Import`
You will be directed to the import dashboard section, as illustrated in the image below

![561612d1-d475-4e6d-a253-49cedc323c25](https://github.com/Phoenix-999/Installing-Grafana-Monitoring/assets/127796122/6407f60e-364f-4cb5-8b9e-0ccb5339614e)
![e4f2d913-1600-487a-9cde-401569c94fd7](https://github.com/Phoenix-999/Installing-Grafana-Monitoring/assets/127796122/e7af209d-d66b-4b17-9c48-49b5e9a3947a)

In this section, go to the `Find and import dashboard` field, enter the number `1860` and press the `Load` button on the right

![7868515f-6286-4e6d-af8e-08dc73f6bff2](https://github.com/Phoenix-999/Installing-Grafana-Monitoring/assets/127796122/0034ef7a-97c1-4d8a-9e9c-7ae4b3b22cb7)
![ad390413-e03b-4e5d-a8b1-2e85dc994846](https://github.com/Phoenix-999/Installing-Grafana-Monitoring/assets/127796122/8fcee5fc-7c62-47d4-a412-4db8e7821924)

After loading the 1860 application, in the `Panel` section, find the `Prometheus` dropdown field at the bottom and choose `Prometheus` from the list. Then, import it.

![e9b78b6b-9f35-46c8-aaa9-ae0d9af6678b](https://github.com/Phoenix-999/Installing-Grafana-Monitoring/assets/127796122/179befa7-8221-4af6-903e-984ecb4e656b)

As shown in the image below, the monitor controller will be uploaded. Please click on the `settings` icon on the top bar on the right and select the `link` from the settings menu on the left.
![a476576e-3129-4831-9e9d-6b77c7d9ea3c](https://github.com/Phoenix-999/Installing-Grafana-Monitoring/assets/127796122/7d0bb73e-7c7a-49c0-a6da-8267048e5e11)
![0375cd70-3903-4d8a-96fc-c0f805f6d23c](https://github.com/Phoenix-999/Installing-Grafana-Monitoring/assets/127796122/1737bf02-e745-454b-bace-13473414c856)

In the `link` section, click on the `X` to delete the default links from GitHub and Grafana, as illustrated in the image.
Finally, click on the `Save Dashboard` button on the top right, and you are almost done setting up your panel.

![6ccafdf1-5aca-467a-a263-b8efc90b5f9a](https://github.com/Phoenix-999/Installing-Grafana-Monitoring/assets/127796122/cd8353a1-b6dc-43fd-8341-3a2aca67f9ac)

Now, in the final step, go back to the Home hamburger menu on the top left, open the dropdown menu, and choose `Dashboard` You will see `Node Exporter Full` and by clicking on that, you should have full access to your Grafana monitor controller.

![91da1b4c-404a-4ba5-9621-79338f9f9be7](https://github.com/Phoenix-999/Installing-Grafana-Monitoring/assets/127796122/b614f3c1-06d7-49b6-afcb-62d6fcc19f5c)
![530a691d-92fa-4235-81db-bb20810a72fd](https://github.com/Phoenix-999/Installing-Grafana-Monitoring/assets/127796122/3d11f721-70ba-4d3c-94bc-2d67f183d570)

Now, the choice is yours. Explore the list and select what you'd like to monitor.

![f44ad88c-90fe-4ebc-9e42-3f35f4fd186c](https://github.com/Phoenix-999/Installing-Grafana-Monitoring/assets/127796122/eb8cc316-438c-4b1a-b776-f8ab2a4466e9)

Enjoy!

__________________________________________________________________________________________



Disclaimer:

This script is offered without any warranty or guarantee, and it is provided as is. Use it at your own discretion and risk.
