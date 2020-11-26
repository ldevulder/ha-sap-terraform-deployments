## README-openQA.md

2 commits have been added against official version 6.0.3 to improve openQA integration.

1st commit
Author: Loic Devulder <ldevulder@suse.com>
Date:   Mon Mar 8 10:43:27 2021 +0100

    Force stonith-enabled for all cluster

    Partial backport for openQA tests from #develop branch.

=> This is just a backport of some fixes from #develop branch. These fixes are already included in
the latest official version.

2nd commit
Author: Loic Devulder <ldevulder@suse.com>
Date:   Thu Nov 26 14:44:45 2020 +0100

    Add outputs for openQA tests

    For QA test, we need the ID of the Azure's VMs to be able to stop/start
    them during our test using the CSP API.

    This commit also add 'openqa_vms' and 'openqa_ips' for all provider to
    simplify openQA code and share output with QAC team.

=> This is a patches to simplify openQA integration. This patch was initialy refused by SHAP team.
A change in openQA code can be done to remove this patch, but it will complicate the test code also
shared byt #qac team.
Files changed:
  - README-openQA.md
  - aws/outputs.tf
  - azure/modules/drbd_node/outputs.tf
  - azure/modules/hana_node/outputs.tf
  - azure/modules/netweaver_node/outputs.tf
  - azure/outputs.tf
  - gcp/outputs.tf
