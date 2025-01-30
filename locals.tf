locals {
  tags = merge(
    var.tags,
    {
      ModuleName    = "terraform-azure-container-registry",
      ModuleVersion = "v1.0.0",
    }
  )
}
