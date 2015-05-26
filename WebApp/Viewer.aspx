﻿<%-- 
  Copyright 2012 Applied Geographics, Inc.

  Licensed under the Apache License, Version 2.0 (the "License");
  you may not use this file except in compliance with the License.
  You may obtain a copy of the License at

      http://www.apache.org/licenses/LICENSE-2.0

  Unless required by applicable law or agreed to in writing, software
  distributed under the License is distributed on an "AS IS" BASIS,
  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
  See the License for the specific language governing permissions and
  limitations under the License.
--%>

<%@ Page Language="C#" AutoEventWireup="true" CodeFile="Viewer.aspx.cs" Inherits="Viewer" EnableViewState="false" EnableSessionState="true" EnableEventValidation="false" %>
<%@ Register TagPrefix="uc1" TagName="Footer" Src="Footer.ascx" %>
<%@ Register TagPrefix="uc1" TagName="Header" Src="Header.ascx" %>
<%@ Register TagPrefix="uc1" TagName="SearchPanel" Src="SearchPanel.ascx" %>
<%@ Register TagPrefix="uc1" TagName="SelectionPanel" Src="SelectionPanel.ascx" %>
<%@ Register TagPrefix="uc1" TagName="LegendPanel" Src="LegendPanel.ascx" %>
<%@ Register TagPrefix="uc1" TagName="LocationPanel" Src="LocationPanel.ascx" %>
<%@ Register TagPrefix="uc1" TagName="MarkupPanel" Src="MarkupPanel.ascx" %>

<!DOCTYPE html>

<html>
<head id="head" runat="server">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>AppGeo GPV</title>
  <script type="text/javascript"> if (typeof(JSON) == "undefined") { location.href = "Incompatible.htm"; } </script></head>
<body>
  <div id="pnlBody">
    <div id="pnlHeader">
      <a id="cmdMenu" runat="server" class="CommandLink" style="float: left; margin: 8px" title="Show the help pages" href="#" target="menu"><span class="glyphicon glyphicon-menu-hamburger" style="font-size: 22px;"></span></a>
      <uc1:Header ID="Header1" runat="server" />
      <a id="cmdHelp" runat="server" class="CommandLink" style="float: right; margin: 8px" title="Show the help pages" href="Help.aspx" target="help"><span class="glyphicon glyphicon-question-sign" style="font-size: 22px;"></span></a>
    </div>
    <div id="pnlContent" runat="server">
      <div id="pnlFunctionSizer" runat="server">
        <div id="pnlFunctionTabs" class="TabPanel">
          <span style="font-size: 20px">Map Theme: </span>
          <select id="ddlMapTheme" style="font-size: 18px; margin-top: 12px">
            <asp:PlaceHolder id="plhMapThemes" runat="server"></asp:PlaceHolder>
          </select><br />
          <div style="font-size: 18px; text-align: right; top: 50px; height: 30px;">
            <span id="labLevel" runat="server" style="display: none">Level: </span>
            <select id="ddlLevel" runat="server" class="Input" style="width: 70px; display: none"></select>
          </div>
          <hr />
          <ul class="TabScroll">
            <li id="tabSearch" runat="server" class="MenuItem Normal" style="display: none">Search</li>
            <li id="tabSelection" runat="server" class="MenuItem Normal" style="display: none">Selection</li>
            <li id="tabLegend" runat="server" class="MenuItem Normal" style="display: none">Legend</li>
            <li id="tabLocation" runat="server" class="MenuItem Normal" style="display: none">Location</li>
            <li id="tabMarkup" runat="server" class="MenuItem Normal" style="display: none">Markup</li>
            <li id="tabShare" runat="server" class="MenuItem Normal">Share</li>
          </ul>
           <div style="left: 10px; top: auto; right: 12px; bottom: 0px; height: 24px; z-index: 5">
            <div style="position: relative; float: left; text-align: center; padding-top: 2px; height: 20px">
              <span id="spnVersion" runat="server" class="VersionText"></span>&nbsp;&nbsp;
              <a class="VersionText" href="http://www.appgeo.com" target="AppGeo">AppGeo</a>
            </div>
          </div>
        </div>
        <div id="pnlFunction" style="display: none">
          <%-- Fuction tab name with < to click to return to main menu --%>
          <div id="pnlSearch" runat="server" class="FunctionPanel" style="display: none">
            <uc1:SearchPanel ID="ucSearchPanel" runat="server" />
          </div>
          <div id="pnlSelection" runat="server" class="FunctionPanel" style="display: none">
            <uc1:SelectionPanel ID="ucSelectionPanel" runat="server" />
          </div>
          <div id="pnlLegend" runat="server" class="FunctionPanel" style="display: none">
            <uc1:LegendPanel ID="ucLegendPanel" runat="server" />
          </div>
          <div id="pnlLocation" runat="server" class="FunctionPanel" style="display: none">
            <uc1:LocationPanel ID="ucLocationPanel" runat="server" />
          </div>
          <div id="pnlMarkup" runat="server" class="FunctionPanel" style="display: none">
            <uc1:MarkupPanel ID="ucMarkupPanel" runat="server" />
          </div>
          <div id="pnlShare" runat="server" class="FunctionPanel" style="display: none">
            <div class="FunctionHeader"><span class="glyphicon glyphicon-menu-left FunctionExit" aria-hidden="true"></span>Share</div>
            <div id="pnlShareContent">
              <div id="cmdPrint" class="Button" title="Printable Map"><span style="font-size: 16px; margin: 3px;" class="glyphicon glyphicon-print"></span></div>
              <div id="cmdEmail" class="Button" title="Email This Page"><span style="font-size: 16px; margin: 3px;" class="glyphicon glyphicon-envelope"></span></div>
              <div style="position: relative; left: 12px; top: 50px; height: 20px">
              <select id="ddlExternalMap" runat="server" class="Input" style="width: 200px"></select>
                <a id="cmdExternalMap" href="#" class="CommandLink Disabled" target="external">Go</a>
              </div>
              <div style="position: relative; left: 12px; top: 80px; height: 20px">
                <span id="cmdSaveMap" class="CommandLink">Save Map</span>
                <select id="ddlSaveMap" runat="server" class="Input" style="width: 90px">
                  <option value="image">as Image</option>
                  <option value="kml">as KML</option>
                </select>
              </div>
            </div>
          </div>
        </div>
      </div>
      <div id="pnlMapSizer" runat="server">
        <div id="pnlMapTabs" class="TabPanel" style="display: none;">
          <div class="TabScroll">
            <asp:PlaceHolder id="plhMapTabs" runat="server"></asp:PlaceHolder>
          </div>
        </div>
        <div id="pnlMap" class="MainPanel">
          <div style="left: 10px; right: 12px; height: 24px; z-index: 5">
            <div style="position: relative; float: left; width: 40%; height: 100%; display: none;">
              <div id="zoomBar" runat="server" style="margin-top: 4px"><span id="zoomBarMinus"></span><span id="zoomBarActive"><span id="zoomBarLeft" class="ZoomBar"></span><asp:PlaceHolder ID="plhZoomBar" runat="server" /><span id="zoomBarRight" class="ZoomBar"></span><span id="zoomBarSlider" class="ZoomBar"></span></span><span id="zoomBarPlus"></span></div>
            </div>
        <%--    <div style="position: relative; float: left; width: 40%; text-align: right; padding-top: 3px; height: 18px">
              Scale 1" =
              <input type="text" id="tboScale" runat="server" class="Input" style="width: 45px; cursor: default" />
              ft
            </div>--%>
          </div>
          <div style="left: 400px; top: 20px; right: 20px; height: 25px; z-index: 5">
            <div id="cmdFullView" class="Button" title="Full View"><span style="font-size: 16px; margin: 3px;" class="glyphicon glyphicon-globe"></span></div>
            <%--<div id="cmdZoomPrevious" class="Button" title="Back to Previous Extent"></div>--%>
            <div id="cmdZoomSelect" class="Button" title="Zoom to Selected Features"></div>
            <%--<div id="optZoomIn" runat="server" class="Button MapTool" title="Zoom In"></div>--%>
            <div id="optPan" runat="server" class="Button MapTool Selected" title="Pan"><span style="font-size: 16px; margin: 3px;" class="glyphicon glyphicon-hand-up"></span></div>


            <div id="optIdentify" runat="server" class="Button MapTool" title="Identify"><span style="font-size: 16px; margin: 3px;" class="glyphicon glyphicon-info-sign"></span></div>
          </div>
          <div id="mapMain" runat="server">
            <div id="mapTip" style="display: none"></div>
          </div>
          <div id="pnlScaleBar" runat="server">
            <div id="pnlScaleBarBackground"> </div>
            <div id="scaleBar"></div>
            <div id="scaleBarText"></div>
          </div>

        </div>
      </div>

      <%--<div id="contentDivider" runat="server"></div>--%>
    </div>
    <div id="pnlFooter"><uc1:Footer ID="Footer1" runat="server" /></div>
    <form id="frmSaveMap" method="post" action="Services/MapImage.ashx">
      <input type="hidden" name="m" />
      <input type="hidden" name="state" />
      <input type="hidden" name="width" />
      <input type="hidden" name="height" />
    </form>
    <form id="frmPrint" method="post" action="PrintableMap.aspx" target="print">
      <input type="hidden" name="state" />
      <input type="hidden" name="width" />
    </form>
  </div>
</body>
</html>
