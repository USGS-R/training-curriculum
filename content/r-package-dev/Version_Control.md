---
author: Lindsay R. Carr
date: 9999-10-31
slug: git
title: Version Control
draft: True
image: img/main/intro-icons-300px/r-logo.png
menu:
  main:
    parent: R Package Development
    weight: 1
---
Version control is a tool that allows you to keep track of changes to a number of files. Using version control for package development means that you can easily revert to previous package versions, collaborate with multiple developers, and record reasons for the changes that are made. For this course, we will only discuss the version control language Git and its web interface, GitHub.

Lesson Objectives
-----------------

1.  Define version control and give examples of how it is useful.
2.  Navigate the GitHub interface.
3.  Summarize a typical GitHub-to-R workflow.

Why version control?
--------------------

Version control systems allow you to have organized code repositories by tracking changes. There are many version control systems, but we will only be covering Git in this course. Git can track every change made to a file, annotate the change, and keep record of the change through time. Git maintains a history of the code base and allows you to revert to previous versions if necessary. Git refers to the version control language and commands are typed into the terminal starting with the word `git`.

A web interface called GitHub allows users to visually see their tracked changes and has additional features, such as issues, milestones, review requests, and commenting. With GitHub, changes to code can be associated with bugs and feature requests. GitHub also enables open science practices by sharing what goes on "behind-the-scenes" in the code. In addition, GitHub is a great tool for collaborative work because issues, comments, and peer reviews can be associated with a specific GitHub user account. Each user can edit the code at the same time and handle conflicts appropriately.

In this course, we will be using Git and GitHub in conjunction with RStudio to complete version control workflows.

Setting up Git to work with RStudio
-----------------------------------

?? Git Bash? Should this go in the initial setup page under Getting Started? SSH

Git/GitHub Definitions
----------------------

Here are some terms to be familiar with as we go through our recommended version control workflow.

<table class="gmisc_table" style="border-collapse: collapse; margin-top: 1em; margin-bottom: 1em;">
<thead>
<tr>
<td colspan="2" style="text-align: left;">
Table 1. Common Git and GitHub definitions
</td>
</tr>
<tr>
<th style="border-bottom: 1px solid grey; border-top: 2px solid grey; text-align: center;">
Term
</th>
<th style="border-bottom: 1px solid grey; border-top: 2px solid grey; text-align: center;">
Definition
</th>
</tr>
</thead>
<tbody>
<tr>
<td style="padding-bottom: 0.5em; padding-right: 0.5em; padding-top: 0.5em; text-align: left;">
repository
</td>
<td style="padding-bottom: 0.5em; padding-right: 0.5em; padding-top: 0.5em; text-align: left;">
a collection of files, aka repo
</td>
</tr>
<tr style="background-color: #f7f7f7;">
<td style="padding-bottom: 0.5em; padding-right: 0.5em; padding-top: 0.5em; background-color: #f7f7f7; text-align: left;">
fork
</td>
<td style="padding-bottom: 0.5em; padding-right: 0.5em; padding-top: 0.5em; background-color: #f7f7f7; text-align: left;">
a user's version of the original repository
</td>
</tr>
<tr>
<td style="padding-bottom: 0.5em; padding-right: 0.5em; padding-top: 0.5em; text-align: left;">
commit
</td>
<td style="padding-bottom: 0.5em; padding-right: 0.5em; padding-top: 0.5em; text-align: left;">
saved change(s) to code
</td>
</tr>
<tr style="background-color: #f7f7f7;">
<td style="padding-bottom: 0.5em; padding-right: 0.5em; padding-top: 0.5em; background-color: #f7f7f7; text-align: left;">
pull request
</td>
<td style="padding-bottom: 0.5em; padding-right: 0.5em; padding-top: 0.5em; background-color: #f7f7f7; text-align: left;">
a request to merge changes from one repository to another, aka PR
</td>
</tr>
<tr>
<td style="padding-bottom: 0.5em; padding-right: 0.5em; padding-top: 0.5em; text-align: left;">
branch
</td>
<td style="padding-bottom: 0.5em; padding-right: 0.5em; padding-top: 0.5em; text-align: left;">
specific instance of your fork; there can be more than one branch on any fork (all will have 'master' which is the main branch)
</td>
</tr>
<tr style="background-color: #f7f7f7;">
<td style="padding-bottom: 0.5em; padding-right: 0.5em; padding-top: 0.5em; background-color: #f7f7f7; text-align: left;">
upstream
</td>
<td style="padding-bottom: 0.5em; padding-right: 0.5em; padding-top: 0.5em; background-color: #f7f7f7; text-align: left;">
used to refer to the original repository
</td>
</tr>
<tr>
<td style="padding-bottom: 0.5em; padding-right: 0.5em; padding-top: 0.5em; border-bottom: 2px solid grey; text-align: left;">
master
</td>
<td style="padding-bottom: 0.5em; padding-right: 0.5em; padding-top: 0.5em; border-bottom: 2px solid grey; text-align: left;">
used to refer to your forked repository
</td>
</tr>
</tbody>
</table>

Our recommended workflow
------------------------

There are many ways to use Git, GitHub, and RStudio in your version control workflow. We will discuss the method USGS-R has predominately used. It is most similar to the "fork-and-branch" workflow (see the [additional resources](#additional-resources) section below). There are three locations of the repository: 1) master on GitHub, 2) forked repository on GitHub, and 3) the user's local repository.

### Initial version control setup for a project

The initial setup requires a master repository on GitHub. To create a new master repo on GitHub, follow [these instructions](https://help.github.com/articles/creating-a-new-repository/). Once there is a master repository, the user looking to contribute to this code base would Fork the repository to their own account.

![What button to press for forking a repo](../static/img/fork_repo.png#inline-img "fork repo")

Next, the user would create the local version of the forked repo in an RStudio project. When creating a new RStudio project, select Version Control,

![The version control button for creating a new project](../static/img/new_proj_version_control.png#inline-img "new project version ctrl")

then select Git,

![Choose Git as the version control tool](../static/img/new_proj_git.png#inline-img "git version control")

and then paste the SSH key to the forked repository. It should automatically populate the Project directory name from the key.

![Window for entering the GitHub repo URL & Create Project button](../static/img/new_proj_create.png#inline-img "Create project GitHub repo url")

To find the SSH key, click "Clone or download" on the GitHub repo.

![Choose the SSH key, not HTTPS](../static/img/ssh_key.png#inline-img "SSH key")

Then you can select "Create Project" and it will open a new RStudio project. You should see a new tab in the environment pane that you have not seen before called "Git".

![New tab available called Git](../static/img/git_tab.png#inline-img "git tab available")

Next, you need to setup your local repository to recognize the main repository as the "upstream" version. To do this, click the "More" drop down in your RStudio Git tab, then select "Shell...".

![How to open the git shell window](../static/img/git_shell.png#inline-img "git shell")

In the command prompt, type `git remote -v` and hit enter. This will show you which remote repositories (available on online) are connected to your local repository. You should initially only see your forked repository and it is labeled "origin". To add the main repo as an "upstream" repository, type `git remote add upstream <SSH key>` with the correct SSH key and hit enter. E.g. `git remote add upstream git@github.com:USGS-R/dataRetrieval.git`. Now when you run `git remote -v` in the shell, you should see both origin and upstream listed. This means you are set up to get new changes from the main repo and add your local changes to your remote repo. We will see how to do that next.

### Workflow for every change you want to submit

Now that you have the three repositories set up, you can start making changes to the code and commit them. First, you would make a change to a file or files in RStudio. When you save the file(s), you should see them appear in the Git tab. A blue "M" icon next to them means they were existing files that you modified, a green "A" means they are new files you added, and a red "D" means they were files that you deleted.

#### **Getting upstream changes**

To get changes available on the remote master fork to your local repository, you will need to "pull" those changes down. To do this, go to the Git shell through RStudio (Git tab &gt;&gt; More &gt;&gt; Shell) and use the command `git pull` with the name of the remote master fork followed by the name of your local repo, e.g. `git pull upstream master`. It is generally a good idea to do this before you start making changes to avoid [conflicts](#handling-merge-conflicts).

#### **Committing changes**

Click the check box next to the file(s) you would like to commit. To view the changes, select "Diff".

![Use Diff button to look at code changes](../static/img/commit_change.png#inline-img "view code changes")

You can select the different files and it will show what was added (highlighted green) and what was deleted (highlighted red). Then, type your comment about the commit and click "Commit".

![Window to write a commit message and submit](../static/img/commit_msg.png#inline-img "commit msg")

#### **Pushing local changes to a remote fork**

It's best to keep commits as concise and specific as possible. So, commit often and with useful comments. When you are ready to add these changes to the main repository, you need to create a pull request. First, push your changes to your remote fork (aka master). Either use the "push" button in RStudio (this only works when you are on your master branch) OR type the git command into the shell.

![Use Push button to send your local commits to your remote repository](../static/img/git_push.png#inline-img "push to remote repo")

To get to the shell, go to the "Git" tab, then click "More", and then "Shell...". Now type your git command specifying which repository is being pushed, and where it is going: `git push origin master` will push commits from the local repo ("origin") to your remote repo on GitHub ("master").

<name="submitting-pr"></a>

#### **Submitting a pull request**

To submit a pull request, you need to be on your remote fork's GitHub page. The URL would say `github.com/YOUR_USERNAME/REPO_NAME`, e.g. `github.com/lindsaycarr/dataRetrieval`. It also shows where your repo was forked from:

![Example of name on remote fork URL](../static/img/remote_fork_ex.png#inline-img "user fork name")

From this page, click "New pull request". Now, you should have a screen that is comparing your changes. Double check that the left repo name (1 in the figure) is the master repository that you intend to merge your changes into. Then double check that the fork you are planning to merge is your remote fork (3 in the figure). For now, branches should both be "master" (2 and 4 in the figure). See [the section on branching to learn more](#branching).

![Setting up correct forks for pull request](../static/img/pr_change_comp.png#inline-img "compare forks for PR")

Once you have verified that you are merging the correct forks and branches, you can select "Create Pull Request". Be sure to describe your changes sufficiently (see [this wiki](https://github.com/erlang/otp/wiki/Writing-good-commit-messages) for more tips):

-   add a title and comments
-   include information for whoever reviews this, e.g. what should it do in order for them to approve it?
-   link to any existing issues or related pull requests by typing `#` and the number of the issue or PR

Now, you wait while someone else reviews and merges your PR. To learn how to merge a pull request, see the [section on reviewing code changes](#code-review). You should avoid merging your own pull requests, and instead should always have a peer review of your code.

#### **Commit workflow overview**

![Suggested commit workflow overview diagram](../static/img/github_workflow.png#inline-img "commit process")

Handling merge conflicts
------------------------

Even though Git and GitHub make simultaneous code development easier, it is not entirely fool-proof. If a code line you are working on was edited by someone else since the last time you synced with the master branch, you might run into "merge conflicts". When you encounter conflicts during a pull from the upstream repo, you will see all changed files since the previous sync in your Git tab. Files with checkmarks are just fine. Any file with a filled in checkbox means that only part of the changes are being committed - this is where you have merge conflicts.

When you open the file(s) with merge conflicts, look for the section that looks like this:

``` r
<<<<<<< HEAD
some code 
some code 
some code
=======
your code 
your code 
your code
>>>>>>> master
```

The chunk of code wrapped in `<<<<<<< HEAD` and `=======` (the first chunk) is the code that exists in the master repository. The chunk of code wrapped in `=======` and then `>>>>>>> master` (the second chunk) is the code that you changed in your local repo. To reconcile these differences, you need to pick which code you are keeping and which you aren't. Once you correctly edit the code, make sure to delete the conflict markers (`<<<<<<< HEAD`, `=======`, and `>>>>>>> master`). Then, save the file.

Now that you've addressed the merge conflict in the file, it's time to commit those changes. All the non-conflicted files should still have a checkmark next to them in the Git tab. Check the box next to your reconciled file and select commit. Comment these changes as "merged conflicts" or something similar. Then commit. Now, you should be back on track to continue your edits.

Here's an example. When you try to merge upstream with your local code, the shell will say something similar to `CONFLICT ... Merge conflict in [filename]`.

![Shell script shows where conflicts are during merge](../static/img/merge_conflict_shell.PNG#inline-img "shell shows conflicts")

The actual code will indicate the conflicting lines. Something similar to:

![Actual code that is conflicting](../static/img/merge_conflict_code.PNG#inline-img "code shows conflicts")

The Git tab will also indicate what files have conflicts by a colored-in check box.

![Git tab shows conflicting files](../static/img/merge_conflict_git_tab.PNG#inline-img "git tab shows conflicts")

Once you edit and save the file, just check the box and commit along with everything else that is in the Git tab. Usually, the commit message can just say "Merging conflics".

<name="branching"></a>

Branching
---------

Branches are an optional feature of Git version control. It allows you to have a non-linear commit history where multiple features/bug fixes could be developed and merged independently. You have been working on the "master" branch for the previous sections. We could add another branch off of this called "bug-fix", and another from the master called "new-feature". You could change the code on either of those branches independed of one another, and merge when one is done without the need to have the other completed at the same time. Be careful though, you can create branches from a non-master branch which is often not the behavior you want. Just be aware of your current branch when you are creating a new one.

When the time comes to merge the branch, you can either merge it with the master branch locally or create a pull request to the main repository specifying changes from your new branch. Follow [this blog](https://nicercode.github.io/git/branches.html) to learn how to do the former method.

If you'd prefer the latter method, follow the blog until the "Merging branches back together" section. Instead when you're ready to merge your branch with the main repository through a PR, follow these instructions.

1.  Open the Git shell window and push your local branch to your remote fork via the command `git push origin/new-branch-name`.
2.  On GitHub, go to your remote fork page and click "New pull request".
3.  As noted in the [section on submitting a pull request](#submitting-pr), double check that your repositories and branches are correct on the "Comparing changes" page. The only difference is that you want to change the farthest right drop-down to your branch.
4.  Now follow the rest of steps for completing your PR submission as described in the [how-to-submit-a-PR section](#submitting-pr).

![Dropdown menu to change branches for PR](../static/img/pr_change_branch.png#inline-img "branch PR")

gitignore file
--------------

It is sometimes useful to have a text file name `.gitignore`. This file let's Git know which files it should not worry about tracking. For RStudio projects, it's a good idea to have the `.Rproj` and `.Rhistory` files specified in a gitignore. You can use `*` before a file extension to say any file with that extension should be ignored. Here's an example of what the `.gitignore` content might look like:

``` r
.Rproj.user
.Rhistory
.RData
*.Rproj
```

Mac users might want to consider adding `.DS_Store` to their `.gitignore` file. `.DS_Store` is a file automatically created containing information about icons and their positions. There is no need to include this in your repo.

Stashing
--------

If you have uncommitted changes on your local repository and try to pull down updates from the master repository, you'll notice that you get an error message:

![Error message when merging upstream with uncommitted changes](../static/img/uncommitted_changes.png#inline-img "error merging with changes")

If you're ready, you can go ahead and commit those changes. Then try pulling from upstream again. If you're not ready to commit these changes, you can "stash" them, pull from upstream, and then bring them back as uncommitted changes.

To stash all uncommitted changes, run `git stash` in your Git shell (Git tab &gt;&gt; More &gt;&gt; Shell). To see what you stashed, run `git stash list`. It will automatically put you in the VIM text editor mode, so type "q" and hit enter before try to do anything else. To get your stashed changes back, run `git stash apply`.

That is the basic use of stashing, but there are more complicated ways to stash uncommited changes. Please visit the [git documentation page on stashing](https://git-scm.com/docs/git-stash) for more information.

<name="code-review"></a>

Reviewing code changes
----------------------

If you are the reviewer for an open pull request, you will likely need to pull down the suggested changes and test them out locally before approving the PR. It's pretty simple to do this because you can copy and paste git commands for making a new branch of the PR. Next to the "Merge pull request" button, select "command line instructions".

![See what commands to use to review PR changes as local branch](../static/img/cmd_line_instr.png#inline-img "get PR as branch")

Copy the two git commands from Step 1, *From your project repository, check out a new branch and test the changes.* Paste these lines into your Git shell (Git tab &gt;&gt; More &gt;&gt; Shell).

``` r
git checkout -b otherusername-master master
git pull https://github.com/otherusername/dataRetrieval.git master
```

You might not be able to right click and paste, or use the CTRL + V method. Instead, right click the top bar of the shell window, hover over "Edit", then click "Paste". Once the code is in the shell, hit enter.

![Right click on top of window to paste in git shell](../static/img/paste_in_shell.png#inline-img "paste in shell")

RStudio should now have a different branch name in the top right. Before you can test the changes available in this branch, you need to build and reload the package.

Once you have thoroughly tested this branch and approve of it, go back to the PR on GitHub. Write a few comments about what you tested and why you are accepting these changes, then click "Merge pull request" and then "Confirm". You can now delete the branch you were using to test these changes. Continuing the example for checking out a branch called `otherusername-master` above,

``` r
git branch -d otherusername-master
```

Don't forget to pull down these new changes to your local repository master branch!

Common Git commands
-------------------

<table class="gmisc_table" style="border-collapse: collapse; margin-top: 1em; margin-bottom: 1em;">
<thead>
<tr>
<td colspan="2" style="text-align: left;">
Table 2. Summary of common git commands
</td>
</tr>
<tr>
<th style="border-bottom: 1px solid grey; border-top: 2px solid grey; text-align: center;">
Command
</th>
<th style="border-bottom: 1px solid grey; border-top: 2px solid grey; text-align: center;">
Description
</th>
</tr>
</thead>
<tbody>
<tr>
<td style="padding-bottom: 0.5em; padding-right: 0.5em; padding-top: 0.5em; text-align: left;">
git remote -v
</td>
<td style="padding-bottom: 0.5em; padding-right: 0.5em; padding-top: 0.5em; text-align: left;">
view the remote repos linked to this local repository
</td>
</tr>
<tr style="background-color: #f7f7f7;">
<td style="padding-bottom: 0.5em; padding-right: 0.5em; padding-top: 0.5em; background-color: #f7f7f7; text-align: left;">
git remote add upstream <url>
</td>
<td style="padding-bottom: 0.5em; padding-right: 0.5em; padding-top: 0.5em; background-color: #f7f7f7; text-align: left;">
add a remote repo at the specified url named 'upstream'
</td>
</tr>
<tr>
<td style="padding-bottom: 0.5em; padding-right: 0.5em; padding-top: 0.5em; text-align: left;">
git push origin/master
</td>
<td style="padding-bottom: 0.5em; padding-right: 0.5em; padding-top: 0.5em; text-align: left;">
move changes from the local repo (origin) to your remote fork
</td>
</tr>
<tr style="background-color: #f7f7f7;">
<td style="padding-bottom: 0.5em; padding-right: 0.5em; padding-top: 0.5em; background-color: #f7f7f7; text-align: left;">
git pull upstream master
</td>
<td style="padding-bottom: 0.5em; padding-right: 0.5em; padding-top: 0.5em; background-color: #f7f7f7; text-align: left;">
get changes from the remote main repository (upstream) and merge with your local repo (master)
</td>
</tr>
<tr>
<td style="padding-bottom: 0.5em; padding-right: 0.5em; padding-top: 0.5em; text-align: left;">
git checkout -b <new-branch-name>
</td>
<td style="padding-bottom: 0.5em; padding-right: 0.5em; padding-top: 0.5em; text-align: left;">
create a new branch from the current branch and switch to it
</td>
</tr>
<tr style="background-color: #f7f7f7;">
<td style="padding-bottom: 0.5em; padding-right: 0.5em; padding-top: 0.5em; background-color: #f7f7f7; text-align: left;">
git branch -d <branch-name>
</td>
<td style="padding-bottom: 0.5em; padding-right: 0.5em; padding-top: 0.5em; background-color: #f7f7f7; text-align: left;">
delete the specified branch
</td>
</tr>
<tr>
<td style="padding-bottom: 0.5em; padding-right: 0.5em; padding-top: 0.5em; text-align: left;">
git status
</td>
<td style="padding-bottom: 0.5em; padding-right: 0.5em; padding-top: 0.5em; text-align: left;">
look at what is committed (pushed or not) and not committed
</td>
</tr>
<tr style="background-color: #f7f7f7;">
<td style="padding-bottom: 0.5em; padding-right: 0.5em; padding-top: 0.5em; background-color: #f7f7f7; text-align: left;">
git stash
</td>
<td style="padding-bottom: 0.5em; padding-right: 0.5em; padding-top: 0.5em; background-color: #f7f7f7; text-align: left;">
stash all uncommitted changes
</td>
</tr>
<tr>
<td style="padding-bottom: 0.5em; padding-right: 0.5em; padding-top: 0.5em; text-align: left;">
git stash list
</td>
<td style="padding-bottom: 0.5em; padding-right: 0.5em; padding-top: 0.5em; text-align: left;">
look at what is currently stashed
</td>
</tr>
<tr style="background-color: #f7f7f7;">
<td style="padding-bottom: 0.5em; padding-right: 0.5em; padding-top: 0.5em; background-color: #f7f7f7; border-bottom: 2px solid grey; text-align: left;">
git stash apply
</td>
<td style="padding-bottom: 0.5em; padding-right: 0.5em; padding-top: 0.5em; background-color: #f7f7f7; border-bottom: 2px solid grey; text-align: left;">
restore all stashed changes to the repo
</td>
</tr>
</tbody>
</table>

<name="additional-resources"></a>

Other useful resources
----------------------

Here are links to additional resources about how to use Git, GitHub, and the RStudio interface for Git. We learned a specific Git workflow, "Fork-and-branch", but these resources might use a different workflow. Just keep that in mind as you explore them.

-   [Happy Git and GitHub for the useR by Jenny Bryan](http://happygitwithr.com/)
-   [Using the Fork-and-Branch Git Workflow by Scott Lowe](http://blog.scottlowe.org/2015/01/27/using-fork-branch-git-workflow/)
-   [R packages: Git and GitHub by Hadley Wickham](http://r-pkgs.had.co.nz/git.html#git-rstudio)
