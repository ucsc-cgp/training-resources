## Launch A VM In Google Cloud
Julian Lucas (juklucas@ucsc.edu)

_Instructions for launching a virtual machine (VM) in Google Cloud Platform using the Cloud Console (web browser)_
------------------
## **Get Added To The Relevant GCP Billing Projects**

_GCP is organized by project, and in order to launch VMs or access resources in a project, you need to be added to the project by the GI’s admin._


1. Email cluster-admin@soe.ucsc.edu
    1. Ask to be added to the relevant project in GCP
        1. Note that you need to be added to a GCP project (not a Terra project). Terra projects also bill to GCP but are specific to Terra.
        2. An example of a GCP billing project is HPP-UCSC

## **Log In To The Console & Select Your Billing Project**

_The cloud console automatically chooses the most recent project that you used. If you have never logged in before, it may choose the wrong project._


1. In a web browser, navigate to [https://console.cloud.google.com/](https://console.cloud.google.com/)
2. Log in with your UCSC email address
3. Select the correct project, if necessary
    1. Click the dropdown to select a project
    
    	![select_project.png](https://github.com/ucsc-cgp/training-resources/blob/main/GCP/launching_a_VM/images/select_project.png?raw=true)
    
    2. A pop up will appear, choose **No organization**
    
    	![choose_organization.png](https://github.com/ucsc-cgp/training-resources/blob/main/GCP/launching_a_VM/images/choose_organization.png?raw=true)
    
    3. Click on the appropriate project


## **Launch a VM**

_We are going to be launching a VM with GCP’s console (web browser interface)_


1. Open the Compute Engine portal by clicking **Go To Compute Engine**

	![select_compute_engine.png](https://github.com/ucsc-cgp/training-resources/blob/main/GCP/launching_a_VM/images/select_compute_engine.png?raw=true)

2. Click **Create Instance** in the top banner
3. Give the instance a unique name that makes it easy to find

	![name_instance.png](https://github.com/ucsc-cgp/training-resources/blob/main/GCP/launching_a_VM/images/name_instance.png?raw=true)

4. Choose the appropriate region and zone to run the instance in (as shown above)
    1. If you do not know what regions you need to operate in, your best bet is select **us-west1**
        1. As a general rule, if you are transferring data to and from another instance or a GCP bucket, it is best to launch your VM in the same region and zone as those resources. 
    2. If you do not know what zone you need to operate in, your best bet is to select **us-west1-b**
        1. It can be the case that some zones offer more instance types than other zones
5. Choose an instance type with enough vCPUs and memory for your needs. Below we are creating a beefy instance with 64 vCPUs and 128GB of memory. Notice that it costs a lot if we keep it running for long periods of time.

	![show_machine_cost.png](https://github.com/ucsc-cgp/training-resources/blob/main/GCP/launching_a_VM/images/show_machine_cost.png?raw=true)

    1. You can select a pre-configured instance type, or you can define a custom type as is shown above
    2. You may have to play around to find a good instance type. Some instances, such as E2 are cheaper, but only have limited resources (E2 instances can only go up to 32 vCPUs at the time of writing in the region/zone we selected)
    3. Notice that on the right hand side you can see an estimate for the cost of the instance
        1. Be sure to click **Details** in order to see the full price (in the example above a monthly sustained use discount is shown, but we would likely not benefit from this discount)
6. Update the boot disk (size) and Image by clicking **Change**

	![update_boot_disk.png](https://github.com/ucsc-cgp/training-resources/blob/main/GCP/launching_a_VM/images/update_boot_disk.png?raw=true)

    1. Update the boot disk. Below we have selected Ubuntu 18.04 with 256GB of storage

    ![update_boot_disk_2.png](https://github.com/ucsc-cgp/training-resources/blob/main/GCP/launching_a_VM/images/update_boot_disk_2.png?raw=true)    

    2. Press **SELECT**
    3. Notice that if you have selected a larger boot disk than the standard 10GB, your Monthly estimate will have been updated. Below you can see that a 256GB storage disk incurs a relatively modest (compared to the instance itself) $25/month cost

    ![show_monthly_estimate.png](https://github.com/ucsc-cgp/training-resources/blob/main/GCP/launching_a_VM/images/show_monthly_estimate.png?raw=true)    

7. Create the instance by clicking **Create**

## **SSH In To The Instance & Upload a File**

_GCP offers a convenient, if not somewhat limited, way to SSH in to instances through the Cloud Console. We are going to use that to connect to the instance we just created and upload a file. You can also SSH in to instances, and transfer files with SCP, if you are so inclined._
1. Click on SSH on the right hand side of the row for the instance you just created
	
	![choose_instance.png](https://github.com/ucsc-cgp/training-resources/blob/main/GCP/launching_a_VM/images/choose_instance.png?raw=true)    
    
    1. This will create a new pop-up window in your web browser
    2. Click **Connect**
    3. After a minute or two you should have a shell command that you can interact with
2. Upload a file to the instance
    1. Click on the settings icon on the top right-hand corner of the SSH screen
		
	![upload_file_to_instance.png](https://github.com/ucsc-cgp/training-resources/blob/main/GCP/launching_a_VM/images/upload_file_to_instance.png?raw=true)
    
    2. Click **Upload file**
        1. Find a file to upload and follow the instructions
        2. Note that you can download a file from the VM to your local in almost the same way!

## **Stop The Instance**

_Instances can be very expensive to keep running, so if they are idle for a prolonged period of time they should be stopped. As long as you stop an instance while not running a job, your files and installed tools will still be available upon restarting the instance._

1. In the VM Instances page, click on the three dots on the right hand side of your instances rows

	![stop_instance.png](https://github.com/ucsc-cgp/training-resources/blob/main/GCP/launching_a_VM/images/stop_instance.png?raw=true)   

    1. Select **Stop**
        1. This will suspend any charges for vCPUs and memory that your instance was incurring. Disk storage costs will still be incurred, however, so if your disk was particularly large you may want to consider terminating the instance.
    2. If you do not need the instance anymore, after stopping the instance you can reselect the three dot icon and select **Delete** and the instance will be deleted.
2. If you would like to restart the instance, click the three dot icon again and select **Start/Resume**

## **Useful Commands**
_Copying or listing files in buckets and VMs utilizes the gsutil and gcloud command line tools. Below we have some examples to help get you started._


1. Authorize gcloud to access the cloud platform with your Google user credentials
    1. This step is necessary in order to be able to execute gsutil commands on VMs (despite the fact that the VMs come with gsutil pre-installed)

	`gcloud auth login`
    2. After executing the command, follow the instructions on the command line (and later in your web browser).
2. List contents of a bucket (or part of a bucket in this case)

    ```
    gsutil -u hpp-ucsc ls \
        gs://fc-4310e737-a388-4a10-8c9e-babe06aaf0cf/working
    ```
    1. Note that we have included -u hpp-ucsc. This is the billing project, and it must be included in this case because the bucket is “requester pays”
    2. gsutil also has cp and rsync commands. These commands behave as you would expect and can transfer to or from your local machine, a VM, and GCP buckets.
3. Upload a file from your local machine with gcloud scp
    1. Install the Google cloud SDK on your local machine
        1. See [https://cloud.google.com/storage/docs/gsutil_install](https://cloud.google.com/storage/docs/gsutil_install) for instructions 
	```
	curl https://sdk.cloud.google.com | bash
	## Restart shell:
	exec -l $SHELL
	## Run gcloud init to initialize the gcloud environment:
	gcloud init
	```
	    1. Execute the SCP command with gcloud

	        ```
	        gcloud compute scp \
	        	--recurse \
	        	--zone us-west2-b \
	        	/Users/julianlucas/example_dir/ \
	        	demo-instance-1:/home/juklucas
	        ```