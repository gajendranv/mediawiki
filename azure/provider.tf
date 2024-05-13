terraform {
  required_providers {
    azurerm = {
      source = "hashicorp/azurerm"
      version = "~>2.0"
    }
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = ">= 2.0.0"
    }
    kubectl ={
      source  = "gavinbunney/kubectl"
      version = ">= 1.7.0"
    }
    random = {
      source  = "hashicorp/random"
      version = "~>3.0"
    }
  
  }

}
provider "azurerm" {
  features {}
}
