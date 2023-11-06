module "minjun-a100-s" {
  source = "./modules/instance"
  hostname             = "minjun-a100-s"
  boot_disk_size_gb    = 100
  machine_type         = "n1-standard-8"
  image_name           = "pytorch-latest-gpu-v20230925-debian-11-py310"
  user                 = "minjun"
}

module "joe-a100-s" {
  source = "./modules/instance"
  hostname             = "joe-a100-s"
  boot_disk_size_gb    = 100
  machine_type         = "n1-standard-8"
  image_name           = "pytorch-latest-gpu-v20230925-debian-11-py310"
  user                 = "joe"
}
