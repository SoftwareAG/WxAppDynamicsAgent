# WxAppDynamicsAgent

webMethods package for integrating webMethods Integration Server with AppDynamics

This package configures the AppDynamics java agent in conjunction with the [iSDK](https://docs.appdynamics.com/22.4/en/application-monitoring/install-app-server-agents/java-agent/use-the-java-agent-api-and-instrumentation-sdk/isdk-overview) to ensure that services and APIs can be traced as business transaction directly within AppDynamics. Also ensures that asynchronous calls including http and messaging (both native and JMS) are capable of propagating the transaction context; ensuring that you can diagnose any issues end to end without discontinuity.

# Setup
Import the package into your Integration Server packages directory
e.g.

```
$ cd /${SAG_HOME}/IntegrationServer/packages
```
or 
```
$ cd /${SAG_HOME}/IntegrationServer/instances/${INSTANCE}/packages
```

If your packages directory is already under version control

```
$ git submodule add https://github.com/johnpcarter/WxAppDynamicsAgent.git WxAppDynamics
```

or if you are not, then simply clone the repository

```
$ git clone https://github.com/johnpcarter/WxAppDynamicsAgent.git
```

Then restart your runtime server. Open the admin portal and click on Packages -> Management. Then click on the home button of this package.
The screen shows if the connection is already established and the last few lines of the agent log file.
Below that it shows the current configuration of your webMethods runtime and also indicates if the server is not yet configured.

In your case the server will show as not yet configured so click on the merge button to add the AppDynamics java agent setup to the webMethods configuration file, but first check for any discrepancies and that any sequence numbers are not already in use. Once you have clicked on the merge button the page will ask you to restart the server or in the case of a webMethods edge (Microservices Runtime) to stop and then restart the server.

Don't restart your server yet as you still need to configure the connection to your AppDynamics server. Refer to the section below.

*NOTE:* A copy of the configuration file is made before the update, you can find it in the same directory as the config file with the same name and the extension .bak 

After restarting the page should show an "Online" status once the server has restarted and after you have configured your AppDynamics settings as described below.

The configuration section will now instead propose a "restore" button that will allow you to remove the AppDynamics java agent if required.

# Configure the connection with you AppDynamics Server.

You can either edit the agent config file directly via 
```
[SAG_HOME]/IntegrationServer/instances/default/packages/WxAppDynamicsAgent/resources/conf/controller-info.xml
```

or if you are running this in a container, then instead configure the connectivity via environment variables;

- APPDYNAMICS_CONTROLLER_HOST_NAME
- APPDYNAMICS_AGENT_ACCOUNT_NAME
- APPDYNAMICS_AGENT_ACCOUNT_ACCESS_KEY

You will also need to identify your webMethods server correctly, again this is configured in the above file or dynamically via the environment variables

- APPDYNAMICS_AGENT_APPLICATION_NAME
- APPDYNAMICS_AGENT_TIER_NAME
- APPDYNAMICS_AGENT_NODE_NAME

NOTE: The node name must be unique, by default it is set to 'IS'. Therefore make sure that you have the set environment variable APPDYNAMICS_AGENT_NODE_NAME before startup if running more than one wm node!

Environment variables can be passed into a container via the -e switch.

For a full description of configuring the AppDynamics agent click [here](https://docs.appdynamics.com/22.4/en/application-monitoring/install-app-server-agents/java-agent/administer-the-java-agent)

Where it refers to \<agent-home\> this will be \<SAG_HOME\>/IntegrationServer/instances/default/packages/WxAppDynamicsAgent/resources

or \<SAG_HOME\>/IntegrationServer/packages/WxAppDynamicsAgent/resources for our MSR variant.

You can sign up for a free AppDynamics account here

[AppDynamics free trial signup page](https://www.appdynamics.com/free-trial/)

# Internal changes

The file WxAppDynamicsAgent/resources/ver24.5.0.36037/conf/app-agent-config.xml has been update to include all of the built SDK wm interceptors

```
<custom-exclude filter-type="STARTSWITH" filter-value="com/wm/"/> 
```

The file  WxAppDynamicsAgent/resources/ver24.5.0.36037/conf/logging/log4j2.xml has the following custom loggers added to allow this plugin to be logged
```
<AsyncLogger name="com.singularity.instrumentation.sdk.ServiceInterceptor" level="trace" additivity="true">
	<AppenderRef ref="DefaultAppender"/>
</AsyncLogger>
<AsyncLogger name="com.singularity.instrumentation.sdk.ServiceDataExtractor" level="debug" additivity="false">
	<AppenderRef ref="DefaultAppender"/>
</AsyncLogger>
<AsyncLogger name="com.singularity.instrumentation.sdk.HTTPRevInvokeDispatchInterceptor" level="debug" additivity="false">
	<AppenderRef ref="DefaultAppender"/>
</AsyncLogger>
<AsyncLogger name="com.singularity.instrumentation.sdk.HTTPRevInvokeDispatchOutInterceptor" level="debug" additivity="false">
	<AppenderRef ref="DefaultAppender"/>
</AsyncLogger>
<AsyncLogger name="com.singularity.instrumentation.sdk.HTTPRevInvokeDispatchExtractor" level="debug" additivity="false">
	<AppenderRef ref="DefaultAppender"/>
</AsyncLogger>
<AsyncLogger name="com.singularity.instrumentation.sdk.ISServerManagerInterceptor" level="debug" additivity="false">
	<AppenderRef ref="DefaultAppender"/>
</AsyncLogger>
<AsyncLogger name="com.singularity.instrumentation.sdk.HttpContextInterceptor" level="debug" additivity="false">
	<AppenderRef ref="DefaultAppender"/>
</AsyncLogger>
<AsyncLogger name="com.singularity.instrumentation.sdk.WmInterceptor" level="debug" additivity="false">
	<AppenderRef ref="DefaultAppender"/>
</AsyncLogger>
```

# ADVANCED USE

Use the following environment variables as follows

APPDYNAMICS_REPORT_CHILD_ERRORS - set this to true to force tracing of all exceptions even if they are caught and managed by top level services
APPDYNAMICS_USE_SET_TRANSACTION_NAME - set this to true to trace transactions from http level and set transaction name via setTransactionName() method.

______________________
These tools are provided as-is and without warranty or support. They do not constitute part of the Software AG product suite. Users are free to use, fork and modify them, subject to the license agreement. While Software AG welcomes contributions, we cannot guarantee to include every contribution in the master project.
