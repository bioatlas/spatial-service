<%@ page contentType="text/html;charset=UTF-8" %>
<html>
<head>
    <title></title>
    <meta name="layout" content="main"/>
    <link rel="stylesheet" href="/spatial-service/css/leaflet.css"/>
    <script src="/spatial-service/js/jquery.js"></script>
    <script src="/spatial-service/js/leaflet.js"></script>
    <script src="/spatial-service/js/BetterWMS.js"></script>
</head>

<body>
<ul class="breadcrumb">
    <li><g:link controller="main" action="index">Home</g:link></li>
    <li><g:link controller="manageLayers" action="layers">Layers</g:link></li>
    <li><g:link controller="manageLayers" action="layer" id="${raw_id}">Edit Layer</g:link></li>
    <li class="active">${is_field ? "Edit Field" : "Create Field"}</li>
    <br>
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
<g:if test="${message != null}">
    <b class="message">${message}</b>
    <br/>
    <br/>
</g:if>
<style>
input[readonly] {
    background-color: lightgrey;
}

input {
    width: 100%;
}

.error {
    color: red;
    font-size: 14px;
}

.message {
    color: green;
    font-size: 14px;
}
</style>

<div class="container-fluid">
    <div class="col-wide last" style="width:100%">

        <g:if test="${error != null}">
            <b class="error">${error}</b>
            <br/>
            <br/>
        </g:if>

        <g:if test="${layer_creation != null && !has_layer}"><h3 style="color:red">Layer created: <b>${has_layer}</b>
        </h3><br/><b>********* LAYER CREATION IN PROGRESS, WAIT AND REFRESH PAGE *******</b><br/></g:if>

        <div role="tabpanel">
            <ul class="nav nav-tabs" role="tablist">
                <li role="presentation" class="active"><a href="#settings" aria-controls="settings" role="tab"
                                                          data-toggle="tab">Field</a></li>
                <g:if test="${has_layer}"><li role="presentation" class=""><a href="#existingFields"
                                                                              aria-controls="existingFields" role="tab"
                                                                              data-toggle="tab">Other Fields</a>
                </li></g:if>
                <li role="presentation" class=""><a href="#geoserverPreview" aria-controls="geoserverPreview" role="tab"
                                                    data-toggle="tab" onclick="setTimeout(function () {
                            map.invalidateSize()
                        }, 0)">Map</a></li>
                <li role="presentation" class=""><a href="#backgroundProcesses" aria-controls="backgroundProcesses"
                                                    role="tab"
                                                    data-toggle="tab">Background Processes</a></li>
            </ul>

            <div class="tab-content">

                <g:if test="${has_layer}">

                    <div role="tabpanel" class="tab-pane" id="existingFields">

                        <table class="table table-bordered">
                            <tr>
                                <td>Id</td>
                                <td>name</td>
                                <td>description</td>
                                <td>sid</td>
                                <td>sname</td>
                            </tr>
                            <g:each in="${fields}" var="item">
                                <tr>
                                    <td>${item.id}</td>
                                    <td>${item.name}</td>
                                    <td>${item.desc}</td>
                                    <td>${item.sid}</td>
                                    <td>${item.sname}</td>
                                    <td><g:link controller="manageLayers" action="field"
                                                id="${item.id}">edit</g:link></td>
                                    <td><a onclick="return confirmDelete('${item.id}');">delete</a></td>
                                </tr>
                            </g:each>
                            <tr><td colspan="5"><g:link controller="manageLayers" action="field"
                                                        id="${raw_id}">Add new Field</g:link></td></tr>
                        </table>
                    </div>

                </g:if>

                <div role="tabpanel" class="tab-pane" id="geoserverPreview">
                    <style>
                    #map {
                        height: 500px;
                    }
                    </style>
                    Click on map to get values/columns.
                    <div id="map"></div>
                    <script>
                        var map = L.map('map').setView([-22, 122], 4);

                        L.tileLayer('http://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png', {
                            attribution: '&copy; <a href="http://www.openstreetmap.org/copyright">OpenStreetMap</a>'
                        }).addTo(map);

                        var wmsLayer = L.tileLayer.betterWms("${grailsApplication.config.geoserver.url}/wms", {
                            layers: '${name}',
                            format: 'image/png',
                            version: '1.1.0',
                            transparent: true
                        }).addTo(map);

                        setTimeout(function () {
                            map.invalidateSize()
                        }, 0)
                    </script>
                </div>


                <div role="tabpanel" class="tab-pane active" id="settings">

                    <form method="POST">
                        <table class="table table-bordered">
                            <tr><td class="col-md-2">
                                <label for="name"
                                       style="color:red">Name (default is layer display name) [${displayname}]:</label>
                            </td><td class="col-md-1">
                                <input class="form-control" type="text" id="name" name="name" value="${name}"
                                       maxlength="256"/>
                            </td></tr><tr><td>

                            <label for="desc">Description [${description}]:</label></td><td>
                            <input class="form-control" type="text" id="desc" name="desc" maxlength="256"
                                   value="${desc}"/>
                        </td></tr>
                            <tr><td>

                                <label for="requestedId">requestedId (optional):</label></td><td>
                                <input type="text" class="form-control" id="requestedId" name="requestedId"
                                       value="${requestedId}"
                                       maxlength="15"/>
                            </td></tr><tr><td>

                            <label for="type"
                                   style="color:red">[TODO make this work) Type (only for using an Environmental to a Contextual from gridfile when the appropriate textfile is available):</label>
                        </td><td>
                            <select class="form-control" id="type" name="type">
                                <option value="c"
                                        <g:if test="${type == 'c'}">selected</g:if>>Contextual from shapefile
                                </option>
                                <option value="a"
                                        <g:if test="${type == 'a'}">selected</g:if>>Contextual from gridfile (creates types 'a' - classes and
                                'b' - individual shapes)
                                </option>
                                <option value="e"
                                        <g:if test="${type == 'e'}">selected</g:if>>Environmental
                                </option>
                            </select>
                        </td></tr>

                            <g:if test="${type == 'c'}">
                                <tr><td>
                                    <label for="sid"
                                           style="color:red">Source id (contextual only; comma delimited list of shape file column names for aggregation to
                                        create unique objects, e.g. "id") ${sid}</label></td><td>
                                    <!--input type="text" id="sid" name="sid" value="${sid}" maxlength="256"/-->
                                    <select class="form-control" id="sid" name="sid" style="color:red">
                                        <option value=""
                                                <g:if test="${sid == '' || sid == null}">selected</g:if>>(none)
                                        </option>
                                        <g:each in="${columns}" var="column">
                                            <g:if test="${column != 'the_geom'}">
                                                <option value="${column}"
                                                        <g:if test="${sid == column}">selected</g:if>>${column}</option>
                                            </g:if>
                                        </g:each>
                                    </select>
                                </td></tr><!--tr><td>

                                <label for="sname"
                                       style="color:red">Source name (contextual only; column names with optional formatting for the name for each unique
                                Objects, e.g. "name (state)"</label></td><td>
                                <select class="form-control" id="sname" name="sname">
                                    <option value=""
                                <g:if test="${sname == '' || sname == null}">selected</g:if>>(none)
                                    </option>
                                <g:each in="${columns}" var="column">
                                    <g:if test="${column != 'the_geom'}">
                                        <option value="${column}"
                                        <g:if test="${sname == column}">selected</g:if>>${column}</option>
                                    </g:if>
                                </g:each>
                                </select>
                            </td></tr--><tr><td>

                                <label for="sdesc">Source description (contextual only; column names with optional formatting for the description
                                for each unique Objects, e.g. "state (area_km)"</label></td><td>
                                <!--input type="text" id="sdesc" name="sdesc" value="${sdesc}" maxlength="256"/-->
                                <select class="form-control" id="sdesc" name="sdesc">
                                    <option value=""
                                            <g:if test="${sdesc == '' || sdesc == null}">selected</g:if>>(none)
                                    </option>
                                    <g:each in="${columns}" var="column">
                                        <g:if test="${column != 'the_geom'}">
                                            <option value="${column}"
                                                    <g:if test="${sdesc == column}">selected</g:if>>${column}</option>
                                        </g:if>
                                    </g:each>
                                </select>
                            </td></tr>
                            </g:if>

                            <tr><td>

                                <label for="indb">This field is intended for inclusion in biocache (SOLR index)</label>
                            </td><td>
                                <input class="form-control" type="checkbox" id="indb" name="indb"
                                       <g:if test="${indb}">checked</g:if>/>
                            </td></tr><tr><td>

                            <g:if test="${type != 'e'}">
                                <label for="namesearch">This field's objects are included in the objects search (gaz autocomplete). (Contextual
                                only)</label></td><td>
                                <input class="form-control" type="checkbox" id="namesearch" name="namesearch"
                                       <g:if test="${namesearch}">checked</g:if>/>
                            </td></tr><tr><td>
                            </g:if>

                            <label for="defaultlayer">When more than ONE field is created from a source layer, use the 'defaultlayer' for
                            intersection requests</label></td><td>
                            <input class="form-control" type="checkbox" id="defaultlayer" name="defaultlayer"
                                   <g:if test="${defaultlayer}">checked</g:if>/>
                        </td></tr><tr><td>

                            <g:if test="${type != 'e'}">
                                <label for="intersect">Include this Field in calculated Tabulations (Contextual only)</label></td><td>
                                <input class="form-control" type="checkbox" id="intersect" name="intersect"
                                       <g:if test="${intersect}">checked</g:if>/>
                            </td></tr><tr><td>
                            </g:if>

                            <g:if test="${type != 'e'}">
                                <label for="layerbranch">Used by Spatial Portal. When Contextual Layers are listed by their Classifications in a
                                tree structure, list objects in the layer as individual leaves in the tree. (Contextual only and
                                defaultlayer=true) [classification=${classification1} > ${classification2}]</label></td><td>
                                <input class="form-control" type="checkbox" id="layerbranch" name="layerbranch"
                                       <g:if test="${layerbranch}">checked</g:if>/>
                            </td></tr><tr><td>
                            </g:if>

                            <label for="analysis">This field is available in the Spatial Portal Tool lists</label></td><td>
                            <input class="form-control" type="checkbox" id="analysis" name="analysis"
                                   <g:if test="${analysis}">checked</g:if>/>
                        </td></tr><tr><td>

                            <label for="addtomap">This field is available in the Spatial Portal Add To Map list</label>
                        </td><td>
                            <input class="form-control" type="checkbox" id="addtomap" name="addtomap"
                                   <g:if test="${addtomap}">checked</g:if>/>
                        </td></tr><tr><td>

                            <label for="enabled">Enabled (makes the field available for use, disable to remove field from use)</label>
                        </td><td>
                            <input class="form-control" type="checkbox" id="enabled" name="enabled"
                                   <g:if test="${enabled}">checked</g:if>/>
                        </td></tr><tr><td>

                        </td></tr></table>
                        <g:if test="${layer_creation == null}">
                            <input type="submit" class="btn btn-default"
                                   value='${is_field ? "Update Field" : "Create Field"}'/>
                        </g:if>

                        <input type="hidden" name="raw_id" value="${raw_id}"/>

                        <input type="hidden" name="id" value="${id}"/>
                    </form>
                </div>

                <div role="tabpanel" class="tab-pane" id="backgroundProcesses">
                    <table class="table table-bordered">
                        <tr>
                            <td>Task ID</td>
                            <td>Task</td>
                            <td>Created</td>
                            <td>Tag</td>
                            <td>Status</td>
                            <td>Message</td>
                        </tr>
                        <g:each var="t" in="${task}">
                            <tr>
                                <td>${t.id}</td>
                                <td>${t.name}</td>
                                <td>${t.created}</td>
                                <td>${t.tag}</td>
                                <td>${t.status}</td>
                                <td>${t.message}</td>
                            </tr>
                        </g:each>
                    </table>
                </div>
            </div>
        </div>
    </div>
</div>
</body>
</html>