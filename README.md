# project-packer-nginx


## Creating Ubuntu AMI with Nginx Preinstalled and Firewall Rules Applied

This guide outlines the steps to create a custom Ubuntu AMI with Nginx preinstalled and firewall rules applied using Packer.

### Prerequisites

1. **Packer**: Ensure Packer is installed on your system. You can download it from the [official website](https://www.packer.io/downloads) or use a package manager if available for your operating system.

2. **AWS IAM Credentials**: Configure AWS IAM credentials with appropriate permissions to create EC2 instances and AMIs.

### Steps

1. **Set Up Configuration File**: Create a Packer configuration file, use the provided Packer file as a reference.

2. **Define Source Block**: Inside the Packer configuration file, define the source block specifying the base Ubuntu AMI to use as a starting point. Ensure that the AMI is accessible in your selected region.

    ```hcl
    source "amazon-ebs" "ubuntu-nginx" {
      ami_name      = "ubuntu-nginx"
      instance_type = "t2.micro"
      region        = "us-east-1"
      source_ami    = "ami-0c7217cdde317cfec"  # Ubuntu latest AMI
      ssh_username  = "ubuntu"
    }
    ```

3. **Define Build Block**: Specify the build block, giving a name to your build and referencing the source block defined earlier.

    ```hcl
    build {
      name    = "ubuntu-nginx-ami"
      sources = ["source.amazon-ebs.ubuntu-nginx"]
    }
    ```

4. **Define Provisioner Block**: Use a shell provisioner to execute commands on the instance after it's launched. Inside the provisioner block, include commands to update package repositories, install Nginx, start and enable Nginx service, and configure firewall rules using UFW.

    ```hcl
    provisioner "shell" {
      inline = [
        "sudo apt update -y",
        "sudo apt install nginx -y",
        "sudo systemctl enable nginx",
        "sudo systemctl start nginx",
        "sudo ufw allow proto tcp from any to any port 22,80,443",
        "echo 'y' | sudo ufw enable",
      ]
    }
    ```

5. **Run Packer Build**: Execute the Packer build command in the directory containing your Packer configuration file.

    ```bash
    packer build nginx_ami.pkr.hcl
    ```

6. **Test the AMI**: Once the build process completes successfully, verify that the new AMI is created in your AWS account. Launch an EC2 instance using this AMI to ensure that Nginx is installed and running correctly, and firewall rules are applied as expected.

7. **Customize Further (Optional)**: Depending on your requirements, customize the Packer configuration file or provisioning scripts further. This could include additional software installations, configuration tweaks, or security hardening measures.

8. **Update and Maintain**: Keep your Packer configuration and provisioning scripts up to date with any changes in your infrastructure or software requirements. Regularly review and update the AMIs to incorporate security patches and updates.

### Conclusion

Following these steps, you can create a custom Ubuntu AMI with Nginx preinstalled and firewall rules applied using Packer.
