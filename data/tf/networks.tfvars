network1 = {
  name = "network610"
  cidr = "10.6.10.0/24"
  bridge = "virbr610"
  type = "nat"
}

network2 = {
  name = "network611"
  cidr = "10.6.11.0/24"
  bridge = "virbr611"
  type = "none"
}

network3 = {
  name = "network612"
  cidr = "10.6.12.0/24"
  bridge = "virbr612"
  type = "none"
}

network4 = {
  name = "network613"
  cidr = "10.6.13.0/24"
  bridge = "virbr613"
  type = "none"
}

network-ext = {
  name = "tf-network-ext"
  type = "bridge"
  bridge = "br0"
}
