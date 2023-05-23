# v1.0.2

### Enhancement

#### what changed:

`k8s_service_account_name` output added

# v1.0.1

### Fix

#### what changed:

`service_account_name` variable default set to `null` to fix error when `create_service_account` = false

#### reason for change:

before this `service_account_name` value was required even if `create_service_account` = false

# v1.0.0

### Major

Initial release.
