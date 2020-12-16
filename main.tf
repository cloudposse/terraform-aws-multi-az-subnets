locals {
  public_enabled  = module.this.enabled && var.type == "public"
  private_enabled = module.this.enabled && var.type == "private"
}
