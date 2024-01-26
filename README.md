# Installing Prometheus &amp; Grafana Monitoring

This Bash script automates the installation of Prometheus and Grafana monitoring on an Ubuntu/Debian VPS.



## It performs the following tasks:


### Step 1: VPS IP Address Required
  * The script will require your VPS IP address to perform and configure the necessary files for accurate monitoring of your system.

### Step 2: Update and Upgrade Your System
  * Ensure that your system is up-to-date with the necessary updates and upgrades.

### Step 3: Download, install, and configure Prometheus
  * Ensure Prometheus is Downloaded, Installed, and Automatically Configured from the Main Source on Your System

### Step 4: Download, install, and configure Node Exporter
  * Ensure Node Exporter is Downloaded, Installed, and Automatically Configured from the Main Source on Your System

### Step 5: Download, install, and configure Grafana
  * Ensure Grafana is Downloaded, Installed, and Automatically Configured from the Main Source on Your System

## Prerequisites:
  * Ensure that the sudo and wget packages are installed on your system:

Ubuntu & Debian:

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

After the script successfully completes, reboot your system using the following command:

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

![Screenshot 2024-01-12 at 16 02 12](https://github.com/Phoenix-999/Prometheus-and-Grafana-Monitoring/assets/127796122/da43ff0d-b70e-4525-bc78-e3fd49f85f80)

Next, go to the Home hamburger menu on the top left, open the dropdown menu, and choose `Connections`.

![288377133-cba9ac37-4af3-4e3b-937b-feac85e69824](https://github.com/Phoenix-999/Prometheus-and-Grafana-Monitoring/assets/127796122/f92f6076-ab10-44df-9d61-3e173df555dc)

Then to add a new connection, search for 'Prometheus,' select it, and double-click to add.

![288378018-4ebbc872-397c-40a5-a0a5-c6b96ec43e44](https://github.com/Phoenix-999/Prometheus-and-Grafana-Monitoring/assets/127796122/3c3a3cc6-d8d5-4dcd-9de5-ce608a105b71)


Next, click the blue button on the top right corner, `Add New Data Source.`'In the connection field, change `localhost:9090` to `Your-Server-IP-Address:9090` as illustrated in the image below.

![288379125-74fbf74e-77bc-4eaf-8b37-e74b2d48ab68](https://github.com/Phoenix-999/Prometheus-and-Grafana-Monitoring/assets/127796122/8957c4e7-0096-4d9b-886a-acdd88bc64b0)


Then, scroll down to the bottom of the page and click on the `Save and Test` button. You should see the message `Successfully queried the Prometheus API`

![288379971-6a84714c-903b-4d8e-b9f6-cc9df8e1ca50](https://github.com/Phoenix-999/Prometheus-and-Grafana-Monitoring/assets/127796122/1c44ec4c-9ca4-4d26-a49f-3d5a48f7f924)

Next, go back to the home menu, select `Dashboard` click on the 'New' button on the top right, and choose `Import`
You will be directed to the import dashboard section, as illustrated in the image below

![288381800-f6a3b3b3-656f-4265-88e4-5e5b95132ad7](https://github.com/Phoenix-999/Prometheus-and-Grafana-Monitoring/assets/127796122/561612d1-d475-4e6d-a253-49cedc323c25)
![288382101-b325971e-d13b-449a-834e-bec9fa4d4697](https://github.com/Phoenix-999/Prometheus-and-Grafana-Monitoring/assets/127796122/e4f2d913-1600-487a-9cde-401569c94fd7)


In this section, go to the `Find and import dashboard` field, enter the number `1860` and press the `Load` button on the right

![288383172-6a5c5e1e-b250-4417-98b5-2f2189fcba29](https://github.com/Phoenix-999/Prometheus-and-Grafana-Monitoring/assets/127796122/7868515f-6286-4e6d-af8e-08dc73f6bff2)

![288382965-8cc0860b-8664-455e-93b2-4fe693c372d1](https://github.com/Phoenix-999/Prometheus-and-Grafana-Monitoring/assets/127796122/ad390413-e03b-4e5d-a8b1-2e85dc994846)


After loading the 1860 application, in the `Panel` section, find the `Prometheus` dropdown field at the bottom and choose `Prometheus` from the list. Then, import it.

![288391513-2632fb79-858d-45cf-8cac-fc6332ce81d1](https://github.com/Phoenix-999/Prometheus-and-Grafana-Monitoring/assets/127796122/e9b78b6b-9f35-46c8-aaa9-ae0d9af6678b)

As shown in the image below, the monitor controller will be uploaded. Please click on the `settings` icon on the top bar on the right and select the `link` from the settings menu on the left.

![288397530-abaf7cea-70d4-48d7-8fc4-4ec008251ab7](https://github.com/Phoenix-999/Prometheus-and-Grafana-Monitoring/assets/127796122/a476576e-3129-4831-9e9d-6b77c7d9ea3c)
![288393139-3eaca084-1f6b-40a5-bc0a-a38169af0023](https://github.com/Phoenix-999/Prometheus-and-Grafana-Monitoring/assets/127796122/0375cd70-3903-4d8a-96fc-c0f805f6d23c)


In the `link` section, click on the `X` to delete the default links from GitHub and Grafana, as illustrated in the image.
Finally, click on the `Save Dashboard` button on the top right, and you are almost done setting up your panel.

![288394120-d87dd04c-5b8e-4e4e-9567-b37caaeef5e4](https://github.com/Phoenix-999/Prometheus-and-Grafana-Monitoring/assets/127796122/6ccafdf1-5aca-467a-a263-b8efc90b5f9a)

Now, in the final step, go back to the Home hamburger menu on the top left, open the dropdown menu, and choose `Dashboard` You will see `Node Exporter Full` and by clicking on that, you should have full access to your Grafana monitor controller.

![288395941-1cfeeb93-0861-4610-a112-f3676695f701](https://github.com/Phoenix-999/Prometheus-and-Grafana-Monitoring/assets/127796122/91da1b4c-404a-4ba5-9621-79338f9f9be7)
![288395959-e0d85cbd-8b05-4c13-8280-228753cccde9](https://github.com/Phoenix-999/Prometheus-and-Grafana-Monitoring/assets/127796122/530a691d-92fa-4235-81db-bb20810a72fd)


Now, the choice is yours. Explore the list and select what you'd like to monitor.

![288397107-1a2ec654-b2f0-415f-a76c-bde1513e2fcb](https://github.com/Phoenix-999/Prometheus-and-Grafana-Monitoring/assets/127796122/f44ad88c-90fe-4ebc-9e42-3f35f4fd186c)
__________________________________________________________________________________________



Disclaimer:

This script is offered without any warranty or guarantee, and it is provided as is. Use it at your own discretion and risk.
