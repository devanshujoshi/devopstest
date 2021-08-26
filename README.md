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

![CIImage](Scenario1/Images/CITrigger.PNG)


**2)) There will be test projects which will create and maintained in the solution along the Web and API.**
**The trigger should build all the 3 projects - Web, API and test.**
 **The build should not be successful if any test fails.**
I have created a sample C# solution containing 3 projects:
1) ASP.NET Web API project
2) ASP.NET MVC Web Application
3) Unit Test Project

The unit test project contains test cases to test the methods defined in Web Api controller class. The test project creates a simple list of product and validate the result generated from methods defined for getting all products and getting a single product by ID.

Link to controller class : [ProductController](Scenario1\Source\StoreApp\Controllers\ProductController.cs)
Link to test class : [UnitTest1](Scenario1\Source\StoreApp.Tests\UnitTest1.cs)
