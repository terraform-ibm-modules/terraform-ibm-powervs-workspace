// Tests in this file are run in the PR pipeline and the continuous testing pipeline
package test

import (
	"os"
	"testing"

	"github.com/stretchr/testify/assert"
	"github.com/terraform-ibm-modules/ibmcloud-terratest-wrapper/cloudinfo"
	"github.com/terraform-ibm-modules/ibmcloud-terratest-wrapper/testhelper"
)

// Use existing resource group
const resourceGroup = "geretain-test-resources"
const completeExampleDir = "examples/basic"

var sharedInfoSvc *cloudinfo.CloudInfoService

func TestMain(m *testing.M) {
	sharedInfoSvc, _ = cloudinfo.NewCloudInfoServiceFromEnv("TF_VAR_ibmcloud_api_key", cloudinfo.CloudInfoServiceOptions{})
	os.Exit(m.Run())
}

func setupOptions(t *testing.T, prefix string, dir string) *testhelper.TestOptions {
	options := testhelper.TestOptionsDefaultWithVars(&testhelper.TestOptions{
		Testing:            t,
		TerraformDir:       dir,
		Prefix:             prefix,
		ResourceGroup:      resourceGroup,
		Region:             "us-south", // specify default region to skip best choice query
		DefaultRegion:      "us-south",
		BestRegionYAMLPath: "../common-dev-assets/common-go-assets/cloudinfo-region-power-prefs.yaml", // specific to powervs zones
	})
	options.Region, _ = testhelper.GetBestPowerSystemsRegionO(options.RequiredEnvironmentVars["TF_VAR_ibmcloud_api_key"], options.BestRegionYAMLPath, options.DefaultRegion,
		testhelper.TesthelperTerraformOptions{CloudInfoService: sharedInfoSvc})
	// if for any reason the region is empty at this point, such as error, use default
	if len(options.Region) == 0 {
		options.Region = options.DefaultRegion
	}

	options.TerraformVars = map[string]interface{}{
		"prefix":                      options.Prefix,
		"powervs_resource_group_name": options.ResourceGroup,
		// locking into syd05 due to other data center issues
		//"powervs_zone": "lon06",
		"powervs_zone": options.Region,
	}
	return options
}

func TestRunBranchExample(t *testing.T) {
	t.Parallel()

	options := setupOptions(t, "pvs-wsb", completeExampleDir)

	output, err := options.RunTestConsistency()
	assert.Nil(t, err, "This should not have errored")
	assert.NotNil(t, output, "Expected some output")
}

func TestRunMainExample(t *testing.T) {
	t.Parallel()

	//t.Skip("Skipping upgrade test until initial code is in master branch")
	options := setupOptions(t, "pvs-wsm", completeExampleDir)

	output, err := options.RunTestUpgrade()
	if !options.UpgradeTestSkipped {
		assert.Nil(t, err, "This should not have errored")
		assert.NotNil(t, output, "Expected some output")
	}
}
