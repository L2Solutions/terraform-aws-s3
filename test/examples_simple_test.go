package test

import (
	"strings"
	"testing"

	"github.com/gruntwork-io/terratest/modules/terraform"
	"github.com/stretchr/testify/assert"
)

func TestExampleSimple(t *testing.T) {
	t.Parallel()

	terraformOptions := terraform.WithDefaultRetryableErrors(t, &terraform.Options{
		TerraformDir: "../examples/simple",
		NoColor:      true,
	})

	defer terraform.Destroy(t, terraformOptions)
	terraform.InitAndApply(t, terraformOptions)

	bucket, err := terraform.OutputE(t, terraformOptions, "bucket")
	assert.True(t, err == nil)
	assert.Equal(t, true, strings.Contains(bucket, "tf-test-mods-aws-s3-simple"))
}
