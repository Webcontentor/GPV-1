﻿//  Copyright 2012 Applied Geographics, Inc.
//
//  Licensed under the Apache License, Version 2.0 (the "License");
//  you may not use this file except in compliance with the License.
//  You may obtain a copy of the License at
//
//      http://www.apache.org/licenses/LICENSE-2.0
//
//  Unless required by applicable law or agreed to in writing, software
//  distributed under the License is distributed on an "AS IS" BASIS,
//  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
//  See the License for the specific language governing permissions and
//  limitations under the License.

var GPV = (function (gpv) {
  $(function () {
    var metersPerFoot = 0.3048;
    var zoomFactor = 1.414213562373095;
    var appState = gpv.appState;

    var $map = $("#mapMain");
    var fullExtent = gpv.configuration.fullExtent;
    var resizeHandle;

    var mapTabChangedHandlers = [];
    var functionTabChangedHandlers = [];
    var extentChangedHandlers = [];
    var mapShapeHandlers = [];

    // =====  controls required prior to map control creation  =====

    var $ddlExternalMap = $("#ddlExternalMap").on("change", setExternalMap);

    // =====  map control  =====

    // TODO: add support for measurement
    // TODO: add support for markup

    var crs = new L.Proj.CRS('GPV:1', gpv.settings.coordinateSystem, {
      resolutions: [
        8192, 4096, 2048, 1024, 512, 256, 128,
        64, 32, 16, 8, 4, 2, 1, 0.5
      ],
      origin: [0, 4000000]
    });

    var map = L.map('mapMain', {
      crs: crs
    });

    var shingleLayer = L.shingleLayer({ urlBuilder: refreshMap }).addTo(map);

    // =====  control events  =====
    
    $(window).on("resize", function () {
      if (resizeHandle) {
        clearTimeout(resizeHandle);
      }

      resizeHandle = setTimeout(function () {
        resizeHandle = undefined;
        shingleLayer.redraw();
      }, 250);
    });

    $("#cmdEmail").on("click", function () {
      gpv.post({
        url: "Services/SaveAppState.ashx",
        data: {
          state: appState.toJson()
        },
        success: function (result) {
          if (result && result.id) {
            var loc = document.location;
            var url = [loc.protocol, "//", loc.hostname, loc.port.length && loc.port != "80" ? ":" + loc.port : "", loc.pathname, "?state=", result.id];
            loc.href = "mailto:?subject=Map&body=" + encodeURIComponent(url.join(""));
          }
        }
      });
    });

    $("#cmdFullView").on("click", function () {
      zoomToFullExtent();
    });

    $('#cmdMenu').on("click", function () {
      var left = $('#pnlFunctionSizer').css('left') === '0px' ? '-400px' : '0px';
      $('#pnlFunctionSizer').animate({ left: left }, { duration: 800 });
    });

    $("#cmdPrint").on("click", function () {
      var $form = $("#frmPrint");
      $form.find('[name="state"]').val(appState.toJson());
      $form.find('[name="width"]').val($map.width());
      $form.submit();
    });

    $("#cmdSaveMap").on("click", function () {
      var $form = $("#frmSaveMap");
      $form.find('[name="m"]').val($("#ddlSaveMap").val() == "image" ? "SaveMapImage" : "SaveMapKml");
      $form.find('[name="state"]').val(appState.toJson());
      $form.find('[name="width"]').val($map.width());
      $form.find('[name="height"]').val($map.height());
      $form.submit();
    });

    $("#cmdZoomSelect").on("click", function () {
      zoomToSelection(1.6);
    });

    var $ddlLevel = $("#ddlLevel").on("change", function () {
      appState.Level = $(this).val();
      shingleLayer.redraw();
    });

    var $ddlMapTheme = $("#ddlMapTheme").on("change", function(){
      var mapTab = $("#ddlMapTheme :selected").attr("data-maptab");
      appState.MapTab = mapTab;
      triggerMapTabChanged();
      shingleLayer.redraw();
    });

    $(".FunctionExit").on("click", function () {
      var left = $('#pnlFunctionTabs').css('left') === '12px' ? '-400px' : '12px';
      $('#pnlFunction').fadeOut(800, function () {
        $('#pnlFunctionTabs').animate({ left: left }, 800)
      });
    });


    $(".MenuItem").on("click", function(){
      var left = $('#pnlFunctionTabs').css('left') === '12px' ? '-400px' : '12px';
      var name = $(this).text();
      $('#pnlFunctionTabs').animate({ left: left }, 800, function () {
        $(".FunctionPanel").hide();
        $("#pnl" + name).show();
        $('#pnlFunction').fadeIn(800);
      });
      $.each(functionTabChangedHandlers, function () {
        this(name);
      });
    });

    // =====  map tools  =====

    var $MapTool = $(".MapTool");

    $("#optIdentify").on("click", function () {
      gpv.selectTool($(this), { mode: "drawPoint", pannable: false, drawStyle: { strokeWidth: "0px"} }, "default");
    });

    $("#optPan").on("click", function () {
      //gpv.selectTool($(this), { mode: "pan", pannable: true, drawStyle: defaultDrawStyle });
    });

    // =====  component events  =====

    gpv.on("selection", "changed", function (truncated, scaleBy) {
      if (scaleBy) {
        zoomToSelection(scaleBy);
      }
      else {
        shingleLayer.redraw();
      }
    });

    // =====  private functions  =====

    function mapShape(e, geo) {
      switch ($MapTool.filter(".Selected").attr("id")) {
        case "optCoordinates":
          appState.Coordinates.push({ coordinates: geo.coordinates });
          appState.CoordinateLabels.push("1");
          shingleLayer.redraw();
          return;

        case "optIdentify":
          var data = ["maptab=", appState.MapTab, "&visiblelayers=", encodeURIComponent(gpv.legendPanel.getVisibleLayers(appState.MapTab).join("\x01")),
            "&level=", appState.Level, "&x=", geo.coordinates[0], "&y=", geo.coordinates[1], "&distance=4",
            "&scale=", $map.geomap("option", "pixelSize")].join("");

          var windowName = "identify";
          var settings = gpv.settings;

          if (settings.identifyPopup == "multiple") {
            windowName += (new Date()).getTime();
          }

          var features = "width=" + settings.identifyWindowWidth + ",height=" + settings.identifyWindowHeight + ",menubar=no,titlebar=no,toolbar=no,status=no,scrollbars=yes,location=yes,resizable=yes";
          window.open("Identify.aspx?" + data, windowName, features, true);
          return;
      }

      $.each(mapShapeHandlers, function () {
        this(e, geo);
      });
    }

    function refreshMap(size, bbox, callback) {
      var same = sameBox(appState.Extent.bbox, bbox);
      appState.Extent.bbox = bbox;
      setExternalMap();

      if (!same) {
        $.each(extentChangedHandlers, function () {
          this(bbox);
        });
      }

      appState.VisibleLayers[appState.MapTab] = gpv.legendPanel.getVisibleLayers(appState.MapTab);

      return gpv.post({
        url: "Services/MapImage.ashx",
        data: {
          m: "MakeMapImage",
          state: appState.toJson(),
          width: size.x,
          height: size.y
        }
      }).done(function (url) {
        callback(url);
      });
    }

    function sameBox(a, b) {
      return a[0] == b[0] && a[1] == b[1] && a[2] == b[2] && a[3] == b[3];
    }

    function setExtent(extent) {
      $ddlLevel.val(appState.Level); 
      map.fitProjectedBounds(L.Bounds.fromArray(extent));
      return map.getProjectedBounds().toArray();
    }

    function setExternalMap() {
      var externalName = $ddlExternalMap.val();
      var cmd = $("#cmdExternalMap");
      var extent = appState.Extent.bbox;

      if (!externalName || !extent) {
        cmd.attr("href", "#").addClass("Disabled");
        return;
      }

      gpv.post({
        url: "Services/ExternalMap.ashx",
        data: {
          name: externalName,
          minx: extent[0],
          miny: extent[1],
          maxx: extent[2],
          maxy: extent[3],
          pixelSize: map.getProjectedPixelSize()
        },
        success: function (result) {
          if (result && result.url) {
            cmd.attr("href", result.url).removeClass("Disabled");
          }
        }
      });
    }

    function triggerMapTabChanged() {
      $.each(mapTabChangedHandlers, function () {
        this();
      });
    }

    function zoomToActive() {
      gpv.selection.getActiveExtent(function (bbox) {
        if (bbox) {
          map.fitProjectedBounds(L.Bounds.fromArray(bbox).pad(1.6));
        }
      });
    }

    function zoomToFullExtent() {
      map.fitProjectedBounds(L.Bounds.fromArray(fullExtent));
    }

    function zoomToSelection(scaleBy) {
      gpv.selection.getSelectionExtent(function (bbox) {
        if (bbox) {
          map.fitProjectedBounds(L.Bounds.fromArray(bbox).pad(scaleBy));
        }
      });
    }

    // =====  public interface  =====

    gpv.viewer = {
      extentChanged: function (fn) { extentChangedHandlers.push(fn); },
      getExtent: function () { return map.getProjectedBounds().toArray(); },
      functionTabChanged: function (fn) { functionTabChangedHandlers.push(fn); },
      mapShape: function (fn) { mapShapeHandlers.push(fn); },
      mapTabChanged: function (fn) { mapTabChangedHandlers.push(fn); },
      refreshMap: function () { $ddlLevel.val(appState.Level); shingleLayer.redraw(); },
      setExtent: setExtent,
      zoomToActive: zoomToActive
    };

    // =====  finish initialization  =====

    zoomToFullExtent();
    gpv.loadComplete();

    $MapTool.filter(".Selected").trigger("click");
    triggerMapTabChanged();
  });

  return gpv;
})(GPV || {});