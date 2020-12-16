module github.com/cloudposse/terraform-aws-multi-az-subnets

go 1.14

replace github.com/gruntwork-io/terratest cae5343e79f8c6667f92ab591d6a71c09eb6e5be => github.com/ajayk/terratest v0.19.1-0.20190919171739-cae5343e79f8

require (
	github.com/ajayk/terratest v0.19.1-0.20190919171739-cae5343e79f8
	github.com/davecgh/go-spew v1.1.1
	github.com/pmezard/go-difflib v1.0.0
	github.com/stretchr/testify v1.4.0
	golang.org/x/crypto v0.0.0-20191010185427-af544f31c8ac
	golang.org/x/net v0.0.0-20191009170851-d66e71096ffb
	golang.org/x/sys v0.0.0-20191010194322-b09406accb47
	gopkg.in/yaml.v2 v2.2.4
)
