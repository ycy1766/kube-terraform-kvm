kvm_provider_url = "qemu+ssh://root@127.0.0.1/system"

cloud_image_dir = "../images"
cloud_image_file = "CentOS-7-x86_64-GenericCloud-1907.qcow2"
vm_vol_pool_dir = "/data01/kvm-vol-pool/kube-iot-pool"
vm_vol_pool_name = "kube-iot-pool"

vm_pub_key = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQDVfWqgJ1lYIr+AQrYvcc+wAt44MCVG4xN6qwJpxH8qD2lVelz5JGABZvHH/uvsa0l+CuvZlpFuK19zBmYri+hbudF60hsh4li1GdwW2ug2s5THvEWEFMu2ZJNc5ou2iNWiU0+FZ2YbTUtlsoa6wfhkQks2tUunmU/f7HokJTQtS9Z3b0EmG+Li6zC0HEdTYqGbNByd9EmKrywBahlLE2DuxzZiAyPKTJm/sT8a12rIJmuplHoaD/JddTPDFaDhEEtMkOodFbF2MXMj6b/iNOrcGnbbD1MFNOcwfdCEgyJLiCXn+uJLZb1k4J8rt2m3EnXWZAwtieUKqXaIVWmcmqPl root@cyuu"
vm_user_data = "#cloud-config\npassword: password\nchpasswd: { expire: False }\nssh_pwauth: True"
