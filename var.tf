/*variable "node_name" {
  type = map(any)
  description = "mul pip"
  default = {
    "0" = {
        pip_name="mypip"
        pip_location="East US"
        nic_name="azurerm_network_interface.ani.0.id"
        


    },
    "1" = {
        pip_name="mypip"
        pip_location="East US"
        nic_name="azurerm_network_interface.ani.1.id"
        


    },
  }
} 

variable "pip" {
  type = map(any)
  description = "mul pip"
  default = {
    pip-1 = {
        pip_name="mypip"
        pip_location="East US"
        


    },
    pip-2 = {
        pip_name="mypip"
        pip_location="East US"
        


    },
  }
  
}

variable "nic" {
  type = map(any)
  description = "mul nic"
  default = {
    zip-1 = {
      pip_name1="azurerm_public_ip.terraform_public_ip.pip-1-mypip.id"
      nic_name="mynic"
      nic_location="East US"
        
    },
    zip-2 = {
      pip_name1="azurerm_public_ip.terraform_public_ip.pip-2-mypip.id"
      nic_name="mynic"
      nic_location="East US"
        
    
        
        


    

    },
  }
  
}



variable "pip_ip" {
  type = map(any)
  description = "mul pip"
  default = {
    "azurerm_public_ip.terraform_public_ip" = {
      pip1_name1="pip-1-mypip"
        
    },
    "azurerm_public_ip.terraform_public_ip" = {
      pip1_name1="pip-2-mypip"
    },
  }
  
}

variable "pro" {
  type = map(any)
  description = ""
  default = {
    0 = {
        
    },
    
  }
}

variable "pro1" {
  type = map(any)
  description = ""
  default = {
    1 = {
        
    },
    
  }
}
*/

variable "vm_details"{

     description = "This contains all of the virtual machine details"
      default={
          vm_names="appvm"
      }
}

 

variable "arg-name" {
  type        = string
  description = "rg name"
}

variable "arg-location" {
  type        = string
  description = "rg location"
}

variable "avn-name" {
  type        = string
  description = "avn name"
}

variable "as-name" {
  type        = string
  description = "as name"
}

variable "ani-name" {
  type        = string
  description = "ani name"
}

variable "ip-conf-name" {
  type        = string
  description = "ani name"
}

variable "ip-conf-pub-ip-type" {
  type        = string
  description = "ip-conf-public-ip-type"
}

variable "lvm-name" {
  type        = string
  description = "vm name"
}

/* variable "count1-no" {
  type        = number
  description = "num of vm"
} */

variable "lvm-size" {
  type        = string
  description = "vm size"
}

variable "osp-cn" {
  type        = string
  description = "computer name"
}

variable "osp-au" {
  type        = string
  description = "user name"
}

variable "osp-ap" {
  type        = string
  description = "ap password"
}

variable "os-cache" {
  type        = string
  description = "os chache"
}

variable "os-sat" {
  type        = string
  description = "storage type"
}

variable "sir-pub" {
  type        = string
  description = "image publisher"
}

variable "sir-imagename-off" {
  type        = string
  description = "image name"
}

variable "sir-version-sku" {
  type        = string
  description = "image version"
}

variable "sir-version-type" {
  type        = string
  description = "image version type"
}