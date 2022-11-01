package test

import (
	"testing"

	"github.com/gruntwork-io/terratest/modules/aws"
	"github.com/gruntwork-io/terratest/modules/terraform"
	"github.com/stretchr/testify/assert"
)

// An example of how to test the Terraform module in examples/terraform-aws-example using Terratest.
func TestTerraformAwsExample(t *testing.T) {
	t.Parallel()
	// Give this EC2 Instance a unique ID for a name tag so we can distinguish it from any other EC2 Instance running
	// in your AWS account
	expectedName := "My first EC2 using Terraform"

	// Pick a random AWS region to test in. This helps ensure your code works in all regions.
	awsRegion := aws.GetRandomStableRegion(t, nil, nil)
	
	// terraform testing.
	//planFilePath := filepath.Join(exampleFolder, "plan.out")
	terraformOptions := terraform.WithDefaultRetryableErrors(t, &terraform.Options{
		// The path to where our Terraform code is located
		TerraformDir: "../",

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

		// Configure a plan file path so we can introspect the plan and make assertions about it.
		PlanFilePath: "../plan.out",
	})

	plan := terraform.InitAndPlanAndShowWithStruct(t, terraformOptions)

	//Get instance name
	terraform.RequirePlannedValuesMapKeyExists(t, plan, "aws_instance.example")
	ec2Resource := plan.ResourcePlannedValuesMap["aws_instance.example"]
	ec2Tags := ec2Resource.AttributeValues["tags"].(map[string]interface{})
	assert.Equal(t, map[string]interface{}{"Name": expectedName}, ec2Tags)
}