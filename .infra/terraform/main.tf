# ==================================================================================
# Hetzner Cloud provider
# ==================================================================================
provider "hcloud" {
  token = var.hc_token
}

# Create HC VPS
resource "hcloud_server" "vps" {
  name = "avg-final-tst"
  image = "ubuntu-18.04"
  server_type = "cx21"
  location = "hel1"
  ssh_keys = [ var.rb_key_name, var.avg_key_name ]
  labels     = {
    "module" = var.module_name
    "email"  = var.email_address
    "task"   = "jenkins"
  }
}

# ==================================================================================
# Ansible
# ==================================================================================

# Define template for ansible inventory file
data "template_file" "inventory" {
  template = file("./templates/inventory.tpl")
  depends_on = [
     hcloud_server.vps,
  ]
  vars = {
    hostnames = join("", ["october-", replace(hcloud_server.vps.ipv4_address, ".", "-"), ".nip.io"])
  }
}

# Get rendered ansible inventory file
resource "local_file" "inventory" {
  content  = data.template_file.inventory.rendered
  filename = "../ansible/inventory/dev-inv"
  file_permission = "0664"
}

# Play ansible script
resource "null_resource" "env_setup" {
  depends_on = [
    local_file.inventory
  ]
  provisioner "local-exec" {
    command = "ANSIBLE_HOST_KEY_CHECKING=False ansible-playbook -i ../ansible/inventory/dev-inv ../ansible/common.yml --vault-password-file ../ansible/etc-data/.vault_psw.txt"
  }
}
