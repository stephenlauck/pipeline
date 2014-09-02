pipeline cookbook
=================
Creates a continuous delivery pipeline using jenkins for Chef artifacts

### Platform

* Ubuntu 12.04
* CentOS 6.5


### Set the chef-repo attribute to pipeline to a chef org/server
`default['pipeline']['chef-repo']['url'] = "https://github.com/stephenlauck/pipeline-example-chef-repo.git"`

### list kitchen instances
`kitchen list`

### locally converge pipeline for CentOS
`kitchen converge cent`

### check Jenkins on localhost:8080
`http://localhost:8080`



Authors
-----------------
- Author: Stephen Lauck (<lauck@getchef.com>)
- Author: Mauricio Silva (<mauricio.silva@gmail.com>)
- Contributor: Kennon Kwok <kennon@getchef.com>
- Contributor: Kirt Fitzpatrick <kfitzpatrick@getchef.com>
