---
paths:
  - "**/*.tf"
  - "**/*.hcl"
  - "**/*.tfvars"
---

# Infrastructure

OpenTofu, not Terraform — the binary is `tofu`. Terragrunt wraps it, with a root config at the infrastructure root, reusable stacks under `modules/` and per-environment config under `envs/`. Target cloud is GCP.

Resource addresses passed to `-replace` and `-target` need the Terragrunt module prefix. Getting this wrong produces a silent no-op that looks like success. Copy the address out of `tofu state list` rather than composing it by hand.

Never echo credentials. `gcloud auth print-access-token`, `Authorization:` headers and anything read out of a secret-bearing `.tfvars` do not belong in output that lands in the transcript.

`apply` and `destroy` are mine to run. Produce the plan and hand it over.

For module structure, state layout, testing and CI practice, invoke the `terraform` skill.
