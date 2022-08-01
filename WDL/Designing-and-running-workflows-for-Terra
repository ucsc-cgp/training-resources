# Designing and Running Workflows For Terra: Tips & Tricks

Those of you familiar with writing WDL workflows will feel right at home on Terra, as Terra uses the same program, Cromwell, as you likely use for your local WDL scripts. That being said there are a few differences once things move to the cloud. We've compiled a list of general advice to those who are new to writing workflows for Terra's compute envirnonment and to aid with troubleshooting. This assumes some familarity with WDL itself, so those new to the world of WDL may benefit more from the spec or other resources in this BYOT document.

- [Helpful Resources](#helpful-resources)
- [Tips and Tricks: Data Access](#tips-and-tricks-data-access)
  * [General DRS tips](#general-drs-tips)
  * [Use gs:// inputs](#use-gs-inputs)
  * [Make sure your credentials are current](#make-sure-your-credentials-are-current)
- [Tips and Tricks: Runtime Attributes](#tips-and-tricks-runtime-attributes)
  * [Cromwell can handle preemptible VM interruptions for you](#Cromwell-can-handle-preemptible-VM-interruptions-for-you)
  * [Disks attribute must use integers](#disks-attribute-must-use-integers)
  * [Avoid using sub() to coerce floats into ints](#avoid-using-sub-to-coerce-floats-into-ints)
- [Tips and Tricks: Efficiency](#tips-and-tricks-efficiency)
  * [Saving money with preemptibles: Risks and benefits](#saving-money-with-preemptibles-risks-and-benefits)
- [Tips and Tricks: Miscellanous](#tips-and-tricks-miscellanous)
  * [Be careful with comments](#be-careful-with-comments)
  * [Use the command line to view the WDL for any given Terra run](#use-the-command-line-to-view-the-wdl-for-any-given-terra-run)


## Helpful Resources
* [Terra's WDL documentation resources](https://support.terra.bio/hc/en-us/sections/360007274612-WDL-Documentation)
* [Cloud-based runtime attributes](https://cromwell.readthedocs.io/en/stable/RuntimeAttributes/)
* [Understanding and controlling cloud costs](https://support.terra.bio/hc/en-us/articles/360029748111-Understanding-and-controlling-cloud-costs-)

## Tips and Tricks: Data Access

### General DRS tips

DRS is a standardized, cloud-agnostic method that is used to access data hosted by the Gen3 platform. When data is imported to Terra from Gen3, you will see that genomic files are accessed via "drs://" (rather than "gs://"). 

Cromwell will automatically resolve DRS URIs for you (assuming your credentials are up-to-date, see below) but depending on how your inputs are set up, some changes might be necessary, such as if you're using symlinks. When working with DRS URIs, sometimes you will want to have your inputs be considered strings rather than file paths.

[This diff on GitHub](https://github.com/DataBiosphere/topmed-workflow-variant-calling/pull/4/files) shows the changes that were needed to make an already existing WDL work with DRS URIs on Terra. Although it is a somewhat complicated example, it may be a helpful template for your own changes.

### Use gs:// inputs
Terra does not support https://storage.google.com inputs, therefore, if one of your input files is in a public Google Cloud bucket, use gs:// notation instead.

|✅| "gs://topmed_workflow_testing/topmed_aligner/reference_files/hg38/hs38DH.fa" | 
|----------------------|----------------|
|❌| "https://storage.google.com/topmed_workflow_testing/topmed_aligner/reference_files/hg38/hs38DH.fa"  |

### Make sure your credentials are current
If you are having issues accessing controlled-access data on Terra, try refreshing your credentials. See Terra support on [linking Terra to external services](https://support.terra.bio/hc/en-us/articles/360038086332).

## Tips and Tricks: Runtime Attributes
Running WDL locally will ignore a WDL's values for runtime attributes that only apply to the cloud, such as `disks` or `memory`. That means if you had issues with those values, such as using incorrect syntax (see below), those issues will not raise an error on local runs, but will become problems when running on Terra. See the official spec for [pointers on the memory attribute](https://github.com/openwdl/wdl/blob/main/versions/1.0/SPEC.md#memory).

### Cromwell can handle preemptible VM interruptions for you

If you include the runtime attribute `preemptible` in your WDL, you can specify the maximum number of times Terra will request a preemptible machine for a task before defaulting back to a non-preemptible machine. For instance, if your set `preemptible: 2`, your workflow will attempt a preembtible at first, and if that machine gets preempted, it will try again with a preemptible again, and if that second try is preempted, then it will use a non-preemptible. For advice on weighing the costs and benefits of preemptibles, see [Saving money with preemptibles: Risks and benefits](#saving-money-with-preemptibles-risks-and-benefits).

### Disks attribute must use integers
A runtime attribute commonly used on Terra is `disks`, used for designating a certain amount of storage. This variable has a string format. Due to the way Google Cloud works, within these strings, you must use integers, not floats.

|✅| local-disk 10 HDD| 
|----------------------|----------------|
|❌| local-disk 10.010500148870051 HDD |

Because `size()` returns a float, if you are basing your disk size on the size of your inputs, you will want to use `floor()` or `ceil()`, which will round a float to the previous or next integer, respectively.

### Avoid using sub() to coerce floats into ints
If your WDL does not specify `version 1.0` at the top, where `disk_size` was calculated elsewhere and is a float, the following is a valid disk string:
`disks: "local-disk " + sub(disk_size, "\\..*", "") + " HDD"`

However, if your workflow is written with WDL 1.0, this specification will not pass a test with woomtool. Further, if you attempt to use `disks: disk_size`, this will pass a test with womtool, but will throw an error in Terra.

As indicated above, disk strings must be in the format of either `local-disk SIZE TYPE` or `/mount/point SIZE TYPE`, where SIZE is an integer.

|✅|`disks: "local-disk " + disk_size + " HDD"`| 
|----------------------|----------------|
|❌ if WDL 1.0, ✅ otherwise| `disks: "local-disk " + sub(disk_size, "\\..*", "") + " HDD"` |
|❌ | `disks: disk_size` |

The same logic applies for memory, which is also usually given in string format and requires an integer.
|✅|`memory: memory + "GB"`| 
|----------------------|----------------|
|❌ if WDL 1.0, ✅ otherwise| `memory: sub(memory, "\\..*", "") + " GB"` |
|❌ | `memory: memory` |

### Calculate size with strings
If you have a task that is used to calculate disk size, you can simply pass it a string of the file name instead of the actual file. This will allow Terra to query the size of the file without actually downloading it to the VM.

## Tips and Tricks: Efficiency
### Saving money with preemptibles: Risks and benefits
Preemptible VM instances are an easy way to save money when computing on Google Cloud, including Terra. We will provide an introduction to how they work, but you can see [Google's information about them here](https://cloud.google.com/compute/docs/instances/preemptible). Noteably, Google's documentation does not provide a suggestion as to when it is worth using a preempitble for bioinformatic workflows, hence why we want to give our own explanation and recommendation.

When running a workflow on Terra, each individual task on a workflow is executed on a virtual machine (VM) that exists on Google Cloud. A preemptible VM instance is a fraction of the cost of a non-preemptible VM instance, so they are an attractive prospect for those who want to reduce costs. (Exactly what "a fraction" means varies, but generally is in the realm of 10%-50% the cost of a non-preemptible.) However, the inherent risk of using a preemptible VM is that it can be shut down at any time ("be preempted"). This risk appears to increase over time, and Google will shut down any preemptible that has been running for more than 24 hours. When a preemptible is shut down, a task must restart from the beginning, even if it had nearly completed. It is important to note that preemptibles are defined for individual tasks, not the overall workflow -- that way, if your first task succeeds, but your second one is preempted, you will not have to re-run your first task. To restate: Preemptibles might result in you having to re-run a task, but should not result in having to re-run an entire workflow.

As a general rule of thumb, we suggest that you only use preemptibles for tasks that will run for 6 hours or less. 

Cost should play a role in your consideration too: The cost of running a task once on a preempted preemptible and once on a non-preemptible will of course be more expensive then running once on a non-preemptible. However, the savings of using preemptibles are so great that the cost of running a task twice on preemptibles (such as if you set `preemptible: 2` and it is interrupted the first time but not the second) will usually be less than running it once on a non-preemptible.

When writing WDL workflows, it is recommended to allow the user to enable or disable preemptibles for each task. This will allow the user to save money on test runs on smaller datasets that are take less time to compute and therefore are less likely to be preempted, while still having the option to avoid preemtibles if they need a task to complete as soon as possible and don't want to wait for it to possibly have to retry.

## Tips and Tricks: Miscellanous
### Be careful with comments
Because command sections of a WDL can interpret BASH commands, and BASH commands make use of the # symbol, Cromwell can misinterpret comments as syntax. This usually only happens if there are special characters in the comment; alphanumerics should work fine.

✅ This will work:
`command <<<`
`    echo foo`
`    #this is a valid comment`
`>>>`

❌ This will fail womtool:
`command <<<`
`    echo foo`
`    #using <<<this syntax>>> for your command section is ~{very cool}!`
`>>>`

### Use the command line to view the WDL for any given Terra run
If you are developing a workflow and need to run multiple tests on Terra, you'll probably be updating your workflow a lot. When you go to run a workflow, you will be able to select the version -- release number or branches if imported from Dockstore, or snapshot if imported from the Broads Methods Repository. But once you run the workflow, Terra's UI shows neither the WDL nor the version number on your workflow page. So, if you are running multiple versions of the same workflow, you might lose track of which run correlates to which WDL. Thankfully, you can extract the WDL once a workflow has finished using the command line.

When you click the "view" button to bring up the job manager, take note of the ID in the top, not to be confused with the workspace-id or submission-id.  

![Screenshot showing the ID of a workflow under the first heading in the Job Manager page](https://raw.githubusercontent.com/aofarrel/verbose-fiesta/master/Terra/Images/BDC_workflowTips.png)

You can use this ID on your local machine's command line to display the WDL on stdout.

`curl -X GET "https://api.firecloud.org/api/workflows/v1/PUT-WORKFLOW-ID-HERE/metadata" -H "accept: application/json" -H "Authorization: Bearer $(gcloud auth print-access-token)" | jq -r '.submittedFiles.workflow'`

Note that you will need to [install gcloud and login with the same Google account that your workspace uses](https://cloud.google.com/sdk/docs/quickstarts), and you will need jq to parse the result. jq can be easily installed on Mac with `brew install jq`

With this quick setup, you'll be able to check the WDL of previously run workflows in a flash. To make this process more efficient, put a comment in the WDL itself explaining its changes.
