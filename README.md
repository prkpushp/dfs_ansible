# dfs_ansible

DFS plays a pivotal role as a fundamental element within the framework. This document endeavors to provide insight into the process of establishing a pristine DFS setup. While our focus here centers on configuring a DFS cluster comprising merely three nodes, it is worth noting that the adaptability of the script allows for scalability, whether it be an expansion or contraction of the cluster's size. This repo does contain a sample Powershell script to do the Job.

Prerequisites:

Ensure your ansible node can reach out to target nodes at 5985 and 5986
Your AD Credential to Configure DFS Cluster
DB local admin credential in reference to respective environments(Optional)


Step 1: Set up your vault and store AD credentials 
Step 2: Define your variables under inventory_dfs.yml and play_vars.yml
Step 3: run the playbook: ansible-playbook -i inventory_dfs.yml main.yml --ask-vault-pass
