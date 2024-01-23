<!DOCTYPE HTML>
<html>
<head>
<title>AppDynamics agent interceptor</title>
    <link rel="stylesheet" type="text/css" href="/WmRoot/webMethods.css">
    <link rel="stylesheet" type="text/css" href="/WmRoot/top.css">
    <link rel="stylesheet" type="text/css" href="styles.css">
    <link rel="stylesheet" type="text/css" href="delite.min.css">
    <link rel="stylesheet" href="https://use.fontawesome.com/releases/v5.8.1/css/all.css" integrity="sha384-50oBUHEmvpQ+1lW4y57PTFmhCaXp0ML5d60M1M7uH2+nqUivzIebhndOJK28anvf" crossorigin="anonymous">

<script>
  function expandshrink(content) {
          
    if (content.style.maxHeight){    
      content.style.maxHeight = null;
    } else {          
      content.style.maxHeight = content.scrollHeight + "px";
    }   
  }
</script>
</head>
<body style="overflow-y: scroll; padding: 0px" topmargin="0" leftmargin="0" marginwidth="0" marginheight="0">
<header class="no-margin no-padding main-head">
  <a class="brand" href="/">
    <div style="display: inline-flex;">
      <img src="images/sag-primary-logo-dark-rgb.png" height="32px" style="margin-top: 10px"/>
    </div>
  </a>
  <div class="wrapper" style="margin-left:auto; margin-right:12px;">
    <h1 class="dlt-links" style="margin-right: 40px; margin-top: 10px">AppDynamics Agent</legend>
  </div>
</header>
  <form method="post" id="form" action=".">
    <div style="margin:20px; margin-top: 64px;">
      <div style="padding: 20px">
        %ifvar actionType -notempty%
          <div style="margin-bottom: 20px; padding: 10px; background-color: pink; min-height: 50px; border-left: 1px solid red">
            %ifvar actionType equals('restore')%
              %invoke wx.appdynamics.agent.config:restore%
                %ifvar success equals('true')%
                Successfully restored configuration, %ifvar serverType equals('IS')%Please restart the server to disable the interceptor.%else%stop the server and restart%endif%
                <button type="submit" class="dlt-button dlt-button-primary" style="float: right; background-color: red; font-size: 14px" onClick="setAction('reboot')">%ifvar serverType equals('IS')%restart%else%shutdown%endif%</button>
                %else%
                Ouch, no backup file found!
                %endif%
              %endinvoke%
            %endif%
            %ifvar actionType equals('merge')%
              %invoke wx.appdynamics.agent.config:merge%
                %ifvar success equals('true')%
                  %value configFileName% has been updated, %ifvar serverType equals('IS')%Please restart the server to enable the interceptor.%else%stop the server and restart%endif%
                  <button type="submit" class="dlt-button dlt-button-primary" style="float: right; background-color: red; font-size: 14px" onClick="setAction('reboot')">%ifvar serverType equals('IS')%restart%else%shutdown%endif%</button>
                %endif%
              %endinvoke%
            %endif%
            %ifvar actionType equals('reboot')%
              %invoke wx.appdynamics.agent.config:reboot%
                %value message%
              %endinvoke%
            %endif%
          </div>
        %endif%
        %invoke wx.appdynamics.agent.config:isConnected%
          <div class="banner">Status: 
            %ifvar isConnected equals('true')%
              <b>Online</b> <i style="color: blue" class="fas fa-link"></i>
            %else%
              <b>offline</b> <i style="color: red" class="fas fa-exclamation-circle"></i>
            %endif%
            <a style="float:right; color: white" href="/invoke/wx.appdynamics.agent.config:download">download <i class="fas fa-file-download"></i></a>
          </div>
          <div class="contentx">
            Started at:<b>%value lastConnectionStatus%</b>
            <textarea id="status" name="status" style="margin-top: 10px; margin-bottom: 10px; width: 100%; height: 150px" readonly>%value logFile%</textarea>
            <p style="margin-top: -10px; font-size: x-small">%value matchedFile%</p>
            <a href="." class="dlt-button dlt-button-primary" style="float: right; background-color: blue; color: white">refresh</a>
          </div>
        %endinvoke%
      </div>
      <div style="padding: 20px">
        <div class="banner">Configuration: 
          %invoke wx.appdynamics.agent.config:isConfigured%
            %ifvar isConfigured equals('true')%
              <b>done</b> <i class="fas fa-check"></i>
            %else%
              <b>to do</b> <i style="color: red" class="fas fa-check"></i>
            %endif% 
          %endinvoke%
        </div>
        <div class="contentx">
          <div style="min-height: 50px">
              %invoke wx.appdynamics.agent.config:get%
              <input type="hidden" name="serverType" value="%value serverType%">
              <input type="hidden" name="actionType">

              <b>%value configFileName% (%ifvar isConfigured equals('true')%current configuration%else%to be updated%endif%)</b>
              <textarea id="config" name="configFile" style="margin-top: 10px; margin-bottom: 10px; width: 100%; height: 400px">%value configFile%</textarea>
              %ifvar isConfigured equals('true')%
                <button type="submit" class="pill-button" style="float: right; background-color: blue; color: white; font-size: 14px" onClick="setAction('restore')">restore</button>
               Clicking on the restore button will reset the configuration to a backup made before the last update.
              %else%
                <b style="pading-top: 20px">e2e additions to be appended to the above file</b>
                <textarea name="configFileAddition" style="margin-top: 10px; margin-bottom: 10px; width: 100%; height: 80px">%value configFileAddition%</textarea>
                <button type="submit" class="dlt-button dlt-button-primary" style="float: right; background-color: red; font-size: 14px" onClick="setAction('merge')">merge</button>
                Clicking on the merge button will update the runtime configuration to include the lines for the AppDynamics interceptor startup. Please verify that there are no discrepancies <br>i.e. that the sequence numbers 601 & 602 are not already used and that you have not already added these lines to the file above.
              %endif%
              %endinvoke%
          </div>
        </div>
      </div>
    </div>
    <div style="padding: 20px; margin-left: 150px; margin-right: 150px; background-color: #eee">
      Please remember to configure your AppDynamics configuration via the file <br><br>
      <i>[SAG_HOME]/IntegrationServer/instances/default/packages/WxAppDynamicsAgent/resources/conf/controller-info.xml</i>
      <div style="width: 100%; margin-top: 20px">
        At a minimum you need to set the following controller properties, <b>controller-host</b>, <b>account-name</b> and <b>account-access-key</b>. Alternatively they can be overridden using environment variables APPDYNAMICS_CONTROLLER_HOST_NAME, APPDYNAMICS_AGENT_ACCOUNT_NAME and APPDYNAMICS_AGENT_ACCOUNT_ACCESS_KEY.
      </div>
      <div style="width: 100%; margin-top: 20px">
        Set the following environment variables to identify this server in your AppDynamics environment; APPDYNAMICS_AGENT_APPLICATION_NAME, APPDYNAMICS_AGENT_TIER_NAME and APPDYNAMICS_AGENT_NODE_NAME. Attention, the node name must be unique, by default it is set to ${host.name}.wm.
      </div>
      <div style="margin-top: 20px">
        This package is using the AppDynamics agent iSDK version 23.12.0.35361, documentation is at <a href="https://docs.appdynamics.com/22.12/en/application-monitoring/install-app-server-agents/java-agent/use-the-java-agent-api-and-instrumentation-sdk/isdk-overview">https://docs.appdynamics.com/22.12/en/application-monitoring/install-app-server-agents/java-agent/use-the-java-agent-api-and-instrumentation-sdk/isdk-overview</a>
      </div>
      <div style="margin-top: 20px">
        Sign up for AppDynamics free trial at <a href="https://www.appdynamics.com/free-trial/">https://www.appdynamics.com/free-trial/</a>
      </div>
    </div>
  </div>
  <script>
  
    var textarea1 = document.getElementById('status');
    textarea1.scrollTop = textarea1.scrollHeight;
  
    var textarea2 = document.getElementById('config');
    textarea2.scrollTop = textarea2.scrollHeight;

    function setAction(action) {
      
      var frm = document.getElementById('form');
      frm.actionType.value = action;
    }
</script>
</body>
</html>