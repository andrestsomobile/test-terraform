package test

import (
	"testing"

	"github.com/gruntwork-io/terratest/modules/aws"
	"github.com/gruntwork-io/terratest/modules/terraform"
	test_structure "github.com/gruntwork-io/terratest/modules/test-structure"
	"github.com/stretchr/testify/assert"
)

// An example of how to test the Terraform module in examples/terraform-aws-example using Terratest.
func TestTerraformAwsExample(t *testing.T) {
	t.Parallel()

	// Make a copy of the terraform module to a temporary directory. This allows running multiple tests in parallel
	// against the same terraform module.
	exampleFolder := test_structure.CopyTerraformFolderToTemp(t, "../", "./")

	// Pick a random AWS region to test in. This helps ensure your code works in all regions.
	awsRegion := aws.GetRandomStableRegion(t, nil, nil)

	// website::tag::1::Configure Terraform setting path to Terraform code, EC2 instance name, and AWS Region. We also
	// configure the options with default retryable errors to handle the most common retryable errors encountered in
	// terraform testing.
	terraformOptions := terraform.WithDefaultRetryableErrors(t, &terraform.Options{
		// The path to where our Terraform code is located
		TerraformDir: exampleFolder,

		// Variables to pass to our Terraform code using -var options
		Vars: map[string]interface{}{
			"stack_id": "dev",
			"layer": "test",
			"type": "infra",
			"vpc": "10.65.28.0/25",
			"subnet_private1": "10.65.28.0/26",
			"subnet_private2": "10.65.28.64/27",
			"subnet_public1": "10.65.28.96/28",
			"subnet_public2": "10.65.28.112/28",
			"rds_instance_identifier": "rdsinstance",
			"database_name": "terraform_db",
			"database_user": "root",
			"database_password": "mysql2022",
		},

		// Environment variables to set when running Terraform
		EnvVars: map[string]string{
			"AWS_DEFAULT_REGION": awsRegion,
		},
	})

	// website::tag::4::At the end of the test, run `terraform destroy` to clean up any resources that were created
	defer terraform.Destroy(t, terraformOptions)

	// website::tag::2::Run `terraform init` and `terraform apply` and fail the test if there are any errors
	terraform.InitAndApply(t, terraformOptions)

	// Run `terraform output` to get the value of an output variable
	endpoint := terraform.Output(t, terraformOptions, "db_instance_endpoint")

	assert.NotNil(t, endpoint)
}