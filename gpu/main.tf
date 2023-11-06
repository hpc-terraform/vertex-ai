module "minjun-a100-s" {
  source = "./modules/instance"
  hostname             = "minjun-a100-s"
  boot_disk_size_gb    = 100
  machine_type         = "n1-standard-8"
  image_name           = "tf2-latest-gpu-v20211202"
  user                 = "minjun"
}

