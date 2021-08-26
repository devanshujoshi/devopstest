# devopstest
The below solution is for scenario 1 : 
A car rental company called FastCarz has a .net Web Application and Web API which are recently 
migrated from on-premise system to Azure cloud using Azure Web App Service
and Web API Service.
The on-premises system had 3 environments Dev, QA and Prod.
The code repository was maintained in TFS and moved to Azure GIT now. The TFS has daily builds which 
triggers every night which build the solution and copy the build package to drop folder.
deployments were done to the respective environment manually. The customer is planning to setup 
Azure DevOps Pipeline service for below requirements:

**1)The build should trigger as soon as anyone in the dev team checks in code to master branch.**
Continuous integration (CI) triggers cause a pipeline to run whenever user push an update to the specified branches.
YAML pipelines are configured by default with a CI trigger on all branches.Users can control which branches get CI triggers with a simple syntax:
```
trigger:
- master
- releases/*
```

![CIImage](Images/CITrigger.PNG)


**2) There will be test projects which will create and maintained in the solution along the Web and API.**
**The trigger should build all the 3 projects - Web, API and test.**
 **The build should not be successful if any test fails.**
I have created a sample C# solution containing 3 projects:
1) ASP.NET Web API project
2) ASP.NET MVC Web Application
3) Unit Test Project

The unit test project contains test cases to test the methods defined in Web Api controller class. The test project creates a simple list of product and validate the results generated from methods defined for getting all products and getting a single product by ID.

1. Link to controller class : [ProductController.cs](Source/StoreApp/Controllers/ProductController.cs)
2. Link to test class : [UnitTest1.cs](Source/StoreApp.Tests/UnitTest1.cs)

Azure Pipelines provide Visual Studio Build Task to build solution using MSBuild. Users can also build project (.*proj) files , default value for this task is **\*.sln which means solution file in any folder in the repo. The solution build task will build all projects under a solution.

```
- task: VSBuild@1
  inputs:
    solution: '$(solution)'
    msbuildArgs: '/p:DeployOnBuild=true /p:WebPublishMethod=Package /p:PackageAsSingleFile=true /p:SkipInvalidConfigurations=true /p:DesktopBuildPackageLocation="$(build.artifactStagingDirectory)\WebApp.zip" /p:DeployIisAppPath="Default Web Site"'
    platform: '$(buildPlatform)'
    configuration: '$(buildConfiguration)'
```

Azure Pipelines provide Visual Studio Test Task to run unit and functional tests using Visual Studio Test Runner. Any failure during test case execution will result in failure of pipeline and it will not move to next tasks of publishing the build artifacts for release deployment.

```
- task: VSTest@2
  inputs:
    testSelector: 'testAssemblies'
    testAssemblyVer2: |
      **\*test*.dll
      !**\*TestAdapter.dll
      !**\obj\**
    searchFolder: '$(System.DefaultWorkingDirectory)'
```
1: Below screen shot is showing the pipeline execution when the test case execution failed and it aborted the pipeline execution:

![TestCaseFailure](Images/TestCaseFailure.PNG)

2: Below screen shots are showing the pipeline execution when the test case execution was successful and it moved to the next task of publishing the build artifacts:

![TestCaseSuccess](Images/TestCaseSuccess.PNG)
![TestCaseResult](Images/TestCaseResult.PNG)


**3) The deployment of code and artifacts should be automated to Dev environment.**
Azure Devops release pipelines provide Continuous Delivery (CD) to build, test, configure, and deploy from a build to a production environment. Multiple testing or staging environments create a Release Pipeline to automate the creation of infrastructure and deployment of a new build.

Continuous deployment triggers allow users to create a release every time a new build artifact is available.Select the Continuous deployment trigger icon in the Artifacts section to open the trigger panel. Make sure this is enabled so that a new release is created after every new successful build is completed.

![CDTrigger](Images/CDTrigger.PNG)

**4) Upon successful deployment to the Dev environment, deployment should be easily promoted to QA**
**and Prod through automated process.**
**5) The deployments to QA and Prod should be enabled with Approvals from approvers only.**
Azure Devops release pipeline provide logical separation boundaries to run the tasks.It can be used to mark separation of environments (for example, Build, QA, and production). When users define multiple stages in a pipeline, by default, they run one after the other. You can specify the conditions for when a stage runs.Each stage in a release pipeline can be configured with pre-deployment and post-deployment conditions that can include waiting for users to manually approve or reject deployments, and checking with other automated systems that specific conditions are met.

Select the Pre-deployment conditions icon in the Dev Stage section to open the conditions panel. Make sure that the trigger for deployment to this stage is set to After release. This means that a deployment will be initiated automatically when a new release is created from this release pipeline.
![CDTriggerDev](Images/CDTriggerDev.PNG)

Select the Pre-deployment conditions icon in the QA and Prod Stage section to open the conditions panel.Use the "Stage" option to deploy after deployments to selected stages are successful.
![CDTriggerQA](Images/CDTriggerQA.PNG)

It is recommended to always verify if app is working properly in Dev or test stage before deploying to production or other environments. Adding Pre-deployment approvals will ensure users can approve or reject deployments to stages.Select the users who can approve or reject deployments to this stage. By default, all users must approve the deployment. If a group is added, one user in the group must approve the deployment
![CDApproval](Images/CDApproval.PNG)