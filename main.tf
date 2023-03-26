terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "3.39.1"
    }
  }
}

provider "azurerm" {
  # Configuration options
  features {}

}

resource "azurerm_resource_group" "arg" {
  name     = var.arg-name
  location = var.arg-location
}


resource "azurerm_virtual_network" "avn" {
  name                = var.avn-name
  address_space       = ["10.0.0.0/16"]
  location            = azurerm_resource_group.arg.location
  resource_group_name = azurerm_resource_group.arg.name
}

resource "azurerm_subnet" "as" {
  name                 = var.as-name
  resource_group_name  = azurerm_resource_group.arg.name
  virtual_network_name = azurerm_virtual_network.avn.name
  address_prefixes     = ["10.0.2.0/24"]
}

resource "azurerm_public_ip" "terraform_public_ip" {
  count = 2
  name = format("app-pub%s",(count.index)+1)
  #location = "${each.value.rg_location}"
  location            = azurerm_resource_group.arg.location
  resource_group_name = azurerm_resource_group.arg.name
  allocation_method   = "Dynamic"
}

resource "azurerm_network_interface" "ani" {
  count = 2
  name                = format("app-interface%s",(count.index)+1)
  location            = azurerm_resource_group.arg.location
  resource_group_name = azurerm_resource_group.arg.name

  ip_configuration {
    name                          = "internal"
    subnet_id                     = azurerm_subnet.as.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.terraform_public_ip[count.index].id
  }
  depends_on = [
    azurerm_virtual_network.avn,
    azurerm_subnet.as,
    azurerm_public_ip.terraform_public_ip

  ]
}


resource "azurerm_network_security_group" "my_terraform_nsg" {
  name                = "myNetworkSecurityGroup"
  location            = azurerm_resource_group.arg.location
  resource_group_name = azurerm_resource_group.arg.name

  security_rule {
    name                       = "SSH"
    priority                   = 1001
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "22"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }
}


resource "azurerm_network_interface_security_group_association" "example" {
  count = 2  
  network_interface_id      = azurerm_network_interface.ani[count.index].id
  network_security_group_id = azurerm_network_security_group.my_terraform_nsg.id
 } 

resource "azurerm_linux_virtual_machine" "lvm" {
  count = 2
  name                = format("%s%s",var.vm_details.vm_names,(count.index)+1)
  resource_group_name = azurerm_resource_group.arg.name
  location            = azurerm_resource_group.arg.location
  size                = var.lvm-size
  network_interface_ids = [
    azurerm_network_interface.ani[count.index].id,
  ]
  
  os_disk {
    name = "os-${count.index}"
    caching              = var.os-cache
    storage_account_type = var.os-sat
  }

  source_image_reference {
    publisher = var.sir-pub
    offer     = var.sir-imagename-off
    sku       = var.sir-version-sku
    version   = var.sir-version-type
  }
    
  computer_name                   = "node-${count.index}"
  admin_username                  = var.osp-au
  admin_password                  = var.osp-ap
  disable_password_authentication = false
  
  depends_on = [
    azurerm_network_interface.ani
    
  ]
}

/*resource "time_sleep" "wait_120_seconds" {
  depends_on = [azurerm_linux_virtual_machine.lvm]

  create_duration = "200s"
}

resource "null_resource" "example" {
  depends_on = [time_sleep.wait_120_seconds]


  provisioner "file" {   
     connection {
      for_each = var.pro
      type = "ssh"
      user = var.osp-au
      password = var.osp-ap
      host = azurerm_public_ip.terraform_public_ip[each.key].id
      port = 22
    } 
      source = "C:\\Users\\Yogi\\Desktop\\Terraform\\VM\\2Nodes\\scriptansiblemaster.sh"
      destination = "/tmp/scriptansiblemaster.sh"
      
  }
	
  provisioner "remote-exec" {
     connection {
      for_each = var.pro1
      type = "ssh"
      user = var.osp-au
      password = var.osp-ap        
      host = azurerm_public_ip.terraform_public_ip[each.key].id
      port = 22
    } 

      inline = [
        "sudo /tmp/scriptansiblemaster.sh /home/YS/scriptansibleslave.sh", 
        "sudo sh /home/YS/scriptansibleslave.sh",
        "sudo mkdir /home/YS/yogiform",
        ]
  }

  provisioner "local-exec" {
    
      for_each = var.pro1
      command = "echo ${azurerm_public_ip.terraform_public_ip}${each.key}${id} >>  C:\\Users\\Yogi\\Desktop\\Terraform\\VM\\2Nodes\\details.txt && echo ${var.osp-ap} >> C:\\Users\\Yogi\\Desktop\\Terraform\\VM\\2Nodes\\details.txt && echo ${var.osp-au} >> C:\\Users\\Yogi\\Desktop\\Terraform\\VM\\2Nodes\\details.txt"
  }
} 
*/