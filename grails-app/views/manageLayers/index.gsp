<%@ page contentType="text/html;charset=UTF-8" %>
<html>
<head>
    <title></title>
    <meta name="layout" content="main"/>
</head>

<body>
<ul class="breadcrumb">
    <li><g:link controller="main" action="index">Home</g:link></li>
    <br/>
    <li><g:link controller="manageLayers" action="layers">Layers</g:link></li>
    <li><g:link controller="manageLayers" action="uploads">Uploads</g:link></li>
    <li><g:link controller="tasks" action="index">Tasks</g:link></li>
    <li><g:link controller="tasks" action="remote">Copy Layer</g:link></li>
</ul>

<g:if test="${error != null}">
    <b class="error">${error}</b>
    <br/>
    <br/>
</g:if>

</div>
</body>
</html>