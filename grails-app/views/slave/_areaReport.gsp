<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Strict//EN"
 "http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd">
<%@ page contentType="text/html;charset=UTF-8" %>
<html>

<head>
    <title>Area Report</title>

    <style type="text/css">
    ${
    raw(css)
    }
    </style>
</head>

<body>
<div class='footer'>
    <div style="float:left;margin-left:20px">${grailsApplication.config.skin.homeUrl}</div>

    <div style="float:right;margin-right:10px">Page <span id="pagenumber"></span> of <span id="pagecount"></span></div>
</div>

<g:each var="page" in="${pages}">
    ${raw(page)}
</g:each>

</body>
</html>