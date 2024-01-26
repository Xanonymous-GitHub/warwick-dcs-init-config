# warwick-dcs-init-config
Initial config for warwick dcs machine

## What is this?

These instructions are used to execute certain initialization commands, but avoid causing the initial shell to return a non-zero value.
Let's take an example from one of these tasks.
In this task, we attempt to switch the initial shell to a non-standard installation (self-compiled) of the fish shell.
The reason for not using the recommended way to install the fish shell is because user permissions in the target environment are restricted, neither root nor sudoer.
Therefore, using a self-compiled fish shell is likely to result in various errors.
In such a case, the simplest way to switch the shell to fish is to add a command to launch the fish shell in `.bashrc` (assuming the default shell of the target environment is bash). However, if an error occurs in this launch step, it will cause bash to fail to start (as running `.bashrc` is also part of the bash startup process), leading to a terminal crash. This situation could directly cause remote operations (such as ssh) to fail, as the initial command (here bash) returns a non-zero value.

In summary, the project uses a more rigorous method to load fish, to avoid bash crashes caused by a fish crash.
First, we place the setting of whether to load fish on the remote, and by default, it is set to false on the local machine. Therefore, the local machine will only start the process of loading fish when the remote setting is set to true.
In these instructions, we first assume that the local machine already has a git repository of the remote setting and is set to track the upstream remote. Therefore, we will first check if the local repository is a repository and then perform a git pull to get the latest remote settings.
The remote setting is actually another script file, so the process of loading the remote setting is to execute that script.
Based on this situation, to avoid unsafe scripts, we will verify whether the digital signature of the latest commit is trusted. (Is this method really useful?)
After confirming it's correct, we execute the remote setting. In this step, we assume that all the remote setting commands can be executed normally and completed. This is because if there is an error, we can still correct it by modifying this file.
The remote setting will set an environment variable to specify whether to use the fish shell. So next, we safely start the fish shell by judging the final value of that environment variable. During the startup process, we first use the `command -v` instruction to simulate the execution. If the simulation is successful, we officially execute the fish command to open the fish shell; otherwise, we stop all operations.
