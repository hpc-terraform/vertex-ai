module "bob-cpu-16" {
  source = "./modules/instance"
  image_name           = "common-cpu-notebooks-v20230925-debian-11-py310"
  boot_disk_size_gb    = 100
  machine_type         = "n1-standard-16"
  user                 = "bob"
  hostname             = "bob-cpu-16"
}

module "antoine-cpu-16" {
  source = "./modules/instance"
  image_name           = "common-cpu-notebooks-v20230925-debian-11-py310"
  boot_disk_size_gb    = 100
  machine_type         = "n1-standard-16"
  user                 = "antoine"
  hostname             = "antoine-cpu-16"
}

module "minjun-cpu-16" {
  source = "./modules/instance"
  image_name           = "common-cpu-notebooks-v20230925-debian-11-py310"
  boot_disk_size_gb    = 100
  machine_type         = "n1-standard-16"
  user                 = "minjun"
  hostname             = "minjun-cpu-16"
}

