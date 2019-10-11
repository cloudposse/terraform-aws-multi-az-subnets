package test

import (
	"testing"

	"github.com/gruntwork-io/terratest/modules/terraform"
	"github.com/stretchr/testify/assert"
)

func getKeys(m map[string]string) []string {
  keys := make([]string, 0, len(m))
  for k := range m {
    keys = append(keys, k)
  }
  return sort.Strings(keys)
}

// Test the Terraform module in examples/complete using Terratest.
func TestExamplesComplete(t *testing.T) {
	t.Parallel()

	terraformOptions := &terraform.Options{
		// The path to where our Terraform code is located
		TerraformDir: "../../examples/complete",
		Upgrade:      true,
		// Variables to pass to our Terraform code using -var-file options
		VarFiles: []string{"fixtures.us-west-1.tfvars"},
	}

	// At the end of the test, run `terraform destroy` to clean up any resources that were created
	defer terraform.Destroy(t, terraformOptions)

	// This will run `terraform init` and `terraform apply` and fail the test if there are any errors
	terraform.InitAndApply(t, terraformOptions)

	// Run `terraform output` to get the value of an output variable
	privateSubnetIds := terraform.OutputMap(t, terraformOptions, "private_az_subnet_ids")
	// Run `terraform output` to get the value of an output variable
	privateRouteTableIds := terraform.OutputMap(t, terraformOptions, "private_az_route_table_ids")
	// Run `terraform output` to get the value of an output variable
	publicNATGateWayIds := terraform.OutputMap(t, terraformOptions, "public_az_ngw_ids")
	// Run `terraform output` to get the value of an output variable
	publicRouteTableIds := terraform.OutputMap(t, terraformOptions, "public_az_route_table_ids")
	// Run `terraform output` to get the value of an output variable
	publicSubnetIds := terraform.OutputMap(t, terraformOptions, "public_az_subnet_ids")

  expectedAZs := []string {"us-west-2a", "us-west-2b", "us-west-2c"}
	// Verify we're getting back the outputs we expect
  assert.Equal(t, expectedAZs, getKeys(privateSubnetIds))
  assert.Equal(t, expectedAZs, getKeys(privateRouteTableIds))
  assert.Equal(t, expectedAZs, getKeys(publicNATGateWayIds))
  assert.Equal(t, expectedAZs, getKeys(publicRouteTableIds))
  assert.Equal(t, expectedAZs, getKeys(publicSubnetIds))
}
