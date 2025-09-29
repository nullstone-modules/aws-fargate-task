# 0.3.1 (Sep 29, 2025)
* Configure log retention via cluster configuration.

# 0.3.0 (Sep 22, 2025)
* Upgraded terraform providers.

# 0.2.9 (Aug 28, 2025)
* Fixed `var.memory` description.

# 0.2.8 (Aug 18, 2025)
* Added support for `linuxParameters` in capabilities.

# 0.2.7 (Jul 21, 2025)
* Upgraded all terraform providers to latest.

# 0.2.6 (Jul 09, 2025)
* Added `nullstone.io/version` tag to task definition.

# 0.2.5 (Mar 10, 2025)
* Emitting `subnet_ids` in `app_metadata` as comma-delimited string.

# 0.2.4 (Mar 10, 2025)
* Added `subnet_ids` and `execution_role_name` to capabilities variables `app_metadata`.

# 0.2.3 (Jan 22, 2025)
* When an app secret is removed, it is immediately deleted from AWS secrets manager.

# 0.2.2 (Feb 20, 2024)
* Added support for variable and secret interpolation.

# 0.2.1 (Feb 10, 2024)
* Added permissions to list image tags in image repository.

# 0.2.0 (Aug 08, 2023)
* Added compliance scanning.
* Updated `README.md` with application management info.
* Fixed compliance issues.

# 0.1.4 (Jul 25, 2023)
* Switched to using the cluster from the namespace to ensure proper isolation.

# 0.1.2 (Jun 23, 2023)
* Added optional `var.command` to override image `CMD`.

# 0.1.1 (Jun 21, 2023)
* Fixed "known after apply" for event capabilities.

# 0.1.0 (Jun 21, 2023)
* Initial release
