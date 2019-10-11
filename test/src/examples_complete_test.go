package test

import (
	"github.com/gruntwork-io/terratest/modules/terraform"
	"github.com/stretchr/testify/assert"
	"sort"
	"testing"
)

func getKeys(m map[string]string) []string {
	keys := make([]string, 0, len(m))
	for k := range m {
		keys = append(keys, k)
	}
	sort.Strings(keys)
	return keys
}

func assertValueStartsWith(t *testing.T, m map[string]string, rx interface{}) {
	for _, v := range m {
		assert.Regexp(t, rx, v)
	}
}

// Test the Terraform module in examples/complete using Terratest.
func TestExamplesComplete(t *testing.T) {
	t.Parallel()

	terraformOptions := &terraform.Options{
		// The path to where our Terraform code is located
		TerraformDir: "../../examples/complete",
		Upgrade:      true,
		// Variables to pass to our Terraform code using -var-file options
		VarFiles: []string{"fixtures.us-east-2.tfvars"},
	}

	// At the end of the test, run `terraform destroy` to clean up any resources that were created
	defer terraform.Destroy(t, terraformOptions)

	// This will run `terraform init` and `terraform apply` and fail the test if there are any errors
	terraform.InitAndApply(t, terraformOptions)

/*
   Outputs:

   private_az_route_table_ids = {
     "us-east-2a" = "rtb-0489137a5c668e49b"
     "us-east-2b" = "rtb-083c0e942abb4b8a1"
     "us-east-2c" = "rtb-0c36484693db5e774"
   }
   private_az_subnet_ids = {
     "us-east-2a" = "subnet-0f56deccfe81c0ea0"
     "us-east-2b" = "subnet-05861d30d45e7b675"
     "us-east-2c" = "subnet-036d747a2b46857ae"
   }
   public_az_ngw_ids = {
     "us-east-2a" = "nat-0f5057f09b8cd8ddc"
     "us-east-2b" = "nat-0971b2505ea6d03f1"
     "us-east-2c" = "nat-0dc1cdf91010be057"
   }
   public_az_route_table_ids = {
     "us-east-2a" = "rtb-0642afb4401f1eef1"
     "us-east-2b" = "rtb-04f511a28a2d5a6a2"
     "us-east-2c" = "rtb-05f0ee4e831b05697"
   }
   public_az_subnet_ids = {
     "us-east-2a" = "subnet-0dcb9e32f1f02a367"
     "us-east-2b" = "subnet-0b432a6748ca40638"
     "us-east-2c" = "subnet-00a9a6636ca722474"
   }
 */

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

	expectedAZs := []string{"us-east-2a", "us-east-2b", "us-east-2c"}
	// Verify we're getting back the outputs we expect
	assert.Equal(t, expectedAZs, getKeys(privateSubnetIds))
	assertValueStartsWith(t, privateSubnetIds, "^subnet-.*")
	assert.Equal(t, expectedAZs, getKeys(privateRouteTableIds))
	assertValueStartsWith(t, privateRouteTableIds, "^rtb-.*")
	assert.Equal(t, expectedAZs, getKeys(publicNATGateWayIds))
	assertValueStartsWith(t, publicNATGateWayIds, "^nat-.*")
	assert.Equal(t, expectedAZs, getKeys(publicRouteTableIds))
	assertValueStartsWith(t, publicRouteTableIds, "^rtb-.*")
	assert.Equal(t, expectedAZs, getKeys(publicSubnetIds))
	assertValueStartsWith(t, publicSubnetIds, "^subnet-.*")
}
