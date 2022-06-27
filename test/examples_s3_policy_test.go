package test

import (
	"encoding/json"
	"strings"
	"testing"

	"github.com/gruntwork-io/terratest/modules/terraform"
	"github.com/stretchr/testify/assert"
)

type PolicyDocument struct {
	Version    string      `json:"Version"`
	ID         string      `json:"ID,omitempty"`
	Statements []Statement `json:"Statement"`
}

// Statement represents the body of an AWS IAM policy document
type Statement struct {
	StatementID  string                 `json:"Sid,omitempty"`          // Statement ID, service specific
	Effect       string                 `json:"Effect"`                 // Allow or Deny
	Principal    map[string][]string    `json:"Principal,omitempty"`    // principal that is allowed or denied
	NotPrincipal map[string][]string    `json:"NotPrincipal,omitempty"` // exception to a list of principals
	Action       []string               `json:"Action"`                 // allowed or denied action
	NotAction    []string               `json:"NotAction,omitempty"`    // matches everything except
	Resource     []string               `json:"Resource,omitempty"`     // object or objects that the statement covers
	NotResource  []string               `json:"NotResource,omitempty"`  // matches everything except
	Condition    map[string]interface{} `json:"Condition,omitempty"`    // conditions for when a policy is in effect
}

func TestExampleS3Policy(t *testing.T) {
	t.Parallel()

	terraformOptions := terraform.WithDefaultRetryableErrors(t, &terraform.Options{
		TerraformDir: "../examples/s3policy",
		NoColor:      true,
	})

	defer terraform.Destroy(t, terraformOptions)
	terraform.InitAndApply(t, terraformOptions)

	bucket := terraform.Output(t, terraformOptions, "bucket")
	policy := terraform.OutputMap(t, terraformOptions, "policy_json")

	assert.Equal(t, true, strings.Contains(bucket, "tf-test-mods-aws-s3-s3policy"))

	str, ok := policy["policy"]
	assert.Equal(t, true, ok)

	var policy_doc PolicyDocument
	json.Unmarshal([]byte(str), &policy_doc)

	for _, stmt := range policy_doc.Statements {
		if stmt.StatementID == "S3ListBucket" {
			cond := stmt.Condition
			assert.Equal(t, true, len(cond) > 0)
		}
	}

}
