# Basic example

<!--
The basic example should call the module(s) stored in this repository with a basic configuration.
-->

An end-to-end basic example that will provision the following:
- A new resource group if one is not passed in.
- A new transit gateway.
- A new PowerVS workspace.
- A new PowerVS public SSH key.
- 2 new PowerVS private subnets.
- A new PowerVS public subnet.
- 2 new Cloud connections in Non PER DC.
- Attaches the PowerVS private subnets to CCs in Non PER DC.
- Attaches the PowerVS workspace to Transit gateway in PER DC.
- Imports catalog images into PowerVS workspace.
