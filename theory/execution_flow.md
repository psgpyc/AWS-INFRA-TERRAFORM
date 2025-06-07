**terraform init**

- Scans the configuration files for any provider references (eg. aws, azure, gcp or kubernetes)
- Downloads the mathcing provider plugins (binary executables) from the Terraform Registry into a `.terraform/` plugins directory.

**terraform plan**
- Parses the HCL code into an in-memory resource graph.
- Asks each provider plugin to "refresh" resource attributes (what actually exists rempotely vs. what is declared in the code)
- Computes diff/execution plan showing exactly what API calls will be made (create, update, delete) to bring real infrastructure in line with your desired state.

**terraform apply**
- Applies the plan, making API calls to CRUD resources.
- After each API call, the provider reports back the new state, letting Terraform update its local .tfstate file accordingly. 

Throughout plan and apply steps, Terraform core never directly calls AWS's python SDK or other platforms REST endpoints.   Instead, terraform core communicates with provider plugin through well-defined RPC interface.   

The provider plugin is responsible for mapping HCL resource fields into strongly types API calls for the given platform.  

Whereas, Terraform core only knows how to parse HCL, build a dependency graph, evaluate expressions, and orchestrate the apply lifecycle. It doesnot know how to talk with AWS, Azure, GCP or any other systems.   

-----

By decoupling Core from the platform, Terraform remains extensible. 

Each provider has a built-in "schema" (a list of allowed resource types and the fields they accept). Terraform checks your HCL against that schema, so you get errors immediately if you miss a required fields ir use the wrong data type.  

