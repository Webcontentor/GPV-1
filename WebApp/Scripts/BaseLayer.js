﻿//  Copyright 2016 Applied Geographics, Inc.
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
    var previousChecked;
    var $container = $(".LegendScroll");
    var $layerContainer = $("#pnlLayerScroll");
    var $tileContainer = $("#pnlBaseMapScroll");
    $tileContainer.find(".LegendCheck").on("click", function () {
      if (previousChecked != null) {
        gpv.viewer.toggleTileGroup(previousChecked, false);
      }
      var $this = $(this);
      var isChecked = $this.is(":checked");
      gpv.viewer.toggleTileGroup($this.attr("data-tilegroup"), isChecked);
      gpv.appState.VisibleTiles[gpv.appState.MapTab] = getVisibleTiles(gpv.appState.MapTab);
      previousChecked = $this.attr("data-tilegroup");
    });
    // =====  public functions  =====

    function getVisibleLayers(mapTabID) {
      var layerIds = [];
      $layerContainer.find(".LegendTop").filter('[data-maptab="' + mapTabID + '"]').find(".LegendCheck:checked").each(function (i, e) {
        var layer = $(this).attr("data-layer");
        if (layer) {
          layerIds.push(layer);
        }
      });
      return layerIds;
    }

    function getVisibleTiles(mapTabID) {
      var tileGroupIds = [];
      $tileContainer.find(".LegendTop").filter('[data-maptab="' + mapTabID + '"]').find(".LegendCheck:checked").each(function (i, e) {
        var tileGroup = $(this).attr("data-tilegroup");
        if (tileGroup) {
          tileGroupIds.push(tileGroup);
        }
        if (tileGroup == 'Imagery') {
          $(this).prop("checked", "checked");
        }
      });
      return tileGroupIds;
    }
    // =====  public interface  =====
    gpv.baselayer = {
      getVisibleLayers: getVisibleLayers,
      getVisibleTiles: getVisibleTiles
    };
   // alert(document.getElementsByName('ucBaseMapPanel$'));
    //document.getElementsByName('ucBaseMapPanel$').checked = true;
    //$('input["data-tilegroup=Imagery"]').props("checked", "checked");
   // $tileContainer.filter('[value=ucBaseMapPanel$ctl04]').attr('checked', true);
  });

  return gpv;
})(GPV || {});
